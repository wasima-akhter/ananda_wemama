import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../features/main_tabs/home/dialogs/permanent_denied_dialog.dart';
import '../../../../../features/main_tabs/home/dialogs/rationale_dialog.dart';
import '../../../../../features/main_tabs/home/dialogs/turnon_service_dialog.dart';
import '../../../../components/ui/dialogs/popups.dart';
import '../../../../services/location/location_service.dart';
import '../../location_helpers.dart';

enum LocationFlowResult {
  success,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  failed,
}

// Add this field
StreamSubscription<ServiceStatus>? _serviceStatusSubscription;

class AppLocationManager extends GetxService {
  static AppLocationManager get to => Get.find<AppLocationManager>();

  // active vars
  final isLocationActive = false.obs;

  final locationFlowResult = LocationFlowResult.failed.obs;
  //

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final address = ''.obs;
  final city = ''.obs;

  final isLoading = false.obs;

  bool get hasLocation => latitude.value != 0.0 && longitude.value != 0.0;

  // ─────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocation();
    _listenToLocationService();
    _listenToAppLifecycle(); // 👈 add this
  }

  void _listenToAppLifecycle() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        await _recheckLocationStatus();
      }
      return null;
    });
  }

  Future<void> _recheckLocationStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLocationActive.value = false;
      return;
    }

    final permission = await Geolocator.checkPermission();
    final granted =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    isLocationActive.value = granted;
    log("📍 Rechecked on resume — active: $granted");
  }

  void _listenToLocationService() {
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      ServiceStatus status,
    ) async {
      if (status == ServiceStatus.disabled) {
        isLocationActive.value = false;
        log("📍 Location service turned OFF");
      } else if (status == ServiceStatus.enabled) {
        // Re-check permission before marking active
        final permission = await Geolocator.checkPermission();
        final granted =
            permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
        isLocationActive.value = granted;
        log("📍 Location service turned ON — active: $granted");
      }
    });
  }

  Future<bool> disableLocation() async {
    try {
      // Clear in-memory state
      isLocationActive.value = false;

      latitude.value = 0.0;
      longitude.value = 0.0;
      address.value = '';
      city.value = '';

      // Clear storage
      storage.setUserLatitude(0.0);
      storage.setUserLongitude(0.0);
      storage.setUserAddress('');
      storage.setUserCity('');

      // Update backend
      await _updateBackend();

      // Open location settings only
      await Geolocator.openLocationSettings();

      log("📍 Location disabled");

      return true;
    } catch (e) {
      log("❌ disableLocation error: $e");
      return false;
    }
  }

  @override
  void onClose() {
    _serviceStatusSubscription?.cancel();
    super.onClose();
  }

  void _loadSavedLocation() {
    latitude.value = storage.getUserLatitude ?? 0.0;
    longitude.value = storage.getUserLongitude ?? 0.0;
    address.value = storage.getUserAddress;
    city.value = storage.getUserCity;
  }

  Future<LocationFlowResult> enableLocationGateway({
    bool showDialogs = true,
  }) async {
    try {
      // ─────────────────────────────
      // 1. CHECK GPS SERVICE
      // ─────────────────────────────
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // ❗ THIS is the ONLY way to open system location settings
        await Geolocator.openLocationSettings();

        // wait for user to return
        await Future.delayed(const Duration(seconds: 2));

        serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!serviceEnabled) {
          return LocationFlowResult.serviceDisabled;
        }
      }

      // ─────────────────────────────
      // 2. CHECK PERMISSION
      // ─────────────────────────────
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return LocationFlowResult.permissionDenied;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // ❗ THIS is required for "forever denied"
        await Geolocator.openAppSettings();

        return LocationFlowResult.permissionDeniedForever;
      }

      // ─────────────────────────────
      // 3. GET LOCATION
      // ─────────────────────────────
      final location = await LocationHelper.getCurrentLocation();

      if (location == null) {
        return LocationFlowResult.failed;
      }

      latitude.value = location.latitude;
      longitude.value = location.longitude;
      address.value = location.address;
      city.value = location.city ?? '';

      isLocationActive.value = true;

      await _updateBackend();

      return LocationFlowResult.success;
    } catch (e) {
      log("❌ enableLocationGateway error: $e");
      isLocationActive.value = false;
      return LocationFlowResult.failed;
    }
  }
  // ─────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────

  Future<LocationFlowResult> ensureFreshLocation({
    bool showDialogs = true,
    bool forceRefresh = true,
  }) async {
    if (isLoading.value) return LocationFlowResult.failed;

    isLoading.value = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        isLocationActive.value = false;
        locationFlowResult.value = LocationFlowResult.serviceDisabled;

        return LocationFlowResult.serviceDisabled;
      }

      var permission = await Geolocator.checkPermission();

      final granted =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      if (!granted) {
        isLocationActive.value = false;

        if (permission == LocationPermission.deniedForever) {
          locationFlowResult.value = LocationFlowResult.permissionDeniedForever;

          return LocationFlowResult.permissionDeniedForever;
        }

        locationFlowResult.value = LocationFlowResult.permissionDenied;

        return LocationFlowResult.permissionDenied;
      }

      final location = await LocationHelper.getCurrentLocation();

      if (location == null) {
        isLocationActive.value = false;
        locationFlowResult.value = LocationFlowResult.failed;

        return LocationFlowResult.failed;
      }

      latitude.value = location.latitude;
      longitude.value = location.longitude;

      isLocationActive.value = true;
      locationFlowResult.value = LocationFlowResult.success;

      return LocationFlowResult.success;
    } catch (e) {
      isLocationActive.value = false;
      locationFlowResult.value = LocationFlowResult.failed;

      return LocationFlowResult.failed;
    } finally {
      isLoading.value = false;
    }
  }
  // ─────────────────────────────────────────────
  // BACKEND
  // ─────────────────────────────────────────────

  Future<void> _updateBackend() async {
    try {
      final success = await Get.find<LocationService>().updateLocation(
        address: address.value,
        latitude: latitude.value,
        longitude: longitude.value,
        city: city.value.isNotEmpty ? city.value : null,
      );

      if (!success) return;

      storage.setUserLatitude(latitude.value);
      storage.setUserLongitude(longitude.value);
      storage.setUserAddress(address.value);

      if (city.value.isNotEmpty) {
        storage.setUserCity(city.value);
      }

      log("✅ Updated location in backend");
    } catch (e) {
      log("❌ _updateBackend error: $e");
    }
  }

  // ─────────────────────────────────────────────
  // DIALOGS
  // ─────────────────────────────────────────────

  Future<bool> _showTurnOnServiceDialog() async {
    bool tapped = false;

    await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: false,
      child: TurnOnServiceDialog(onTurnOn: () => tapped = true),
    );

    return tapped;
  }

  Future<bool> _showRationaleDialog() async {
    bool agreed = false;

    await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: false,
      child: RationaleDialog(
        onAllowLocation: () async {
          agreed = true;

          Get.back();

          await Future.delayed(const Duration(milliseconds: 300));

          final permission = await Geolocator.requestPermission();

          log("📍 Permission after rationale: $permission");

          if (permission == LocationPermission.deniedForever) {
            await Geolocator.openAppSettings();
          }
        },
      ),
    );

    return agreed;
  }

  Future<void> _showPermanentDeniedDialog() async {
    await showAnimatedDialog(
      context: Get.context!,
      child: PermanentDeniedDialog(),
    );
  }
}
