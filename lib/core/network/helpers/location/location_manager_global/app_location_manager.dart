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

bool get isIOS {
  return Theme.of(Get.context!).platform == TargetPlatform.iOS;
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
    print("📍 Rechecked on resume — active: $granted");
  }

  void _listenToLocationService() {
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      ServiceStatus status,
    ) async {
      if (status == ServiceStatus.disabled) {
        isLocationActive.value = false;
        print("📍 Location service turned OFF");
      } else if (status == ServiceStatus.enabled) {
        // Re-check permission before marking active
        final permission = await Geolocator.checkPermission();
        final granted =
            permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
        isLocationActive.value = granted;
        print("📍 Location service turned ON — active: $granted");
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

      // If backend stores user's location, clear it here
      // await _clearBackendLocation();

      // Open device location settings
      final opened = await Geolocator.openLocationSettings();

      if (opened) {
        print("📍 Location settings opened");
        return true;
      }

      return false;
    } catch (e) {
      print("❌ disableLocation error: $e");
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
        if (isIOS) {
          // iOS: always go to settings, no retry delay needed
          await Geolocator.openLocationSettings();

          // User returns from Settings
          await Future.delayed(const Duration(seconds: 1));

          serviceEnabled = await Geolocator.isLocationServiceEnabled();

          if (!serviceEnabled) {
            return LocationFlowResult.serviceDisabled;
          }

          return LocationFlowResult.serviceDisabled;
        }

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
      }

      if (permission == LocationPermission.denied) {
        return LocationFlowResult.permissionDenied;
      }

      if (permission == LocationPermission.deniedForever) {
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
      print("❌ enableLocationGateway error: $e");
      isLocationActive.value = false;
      return LocationFlowResult.failed;
    }
  }
  // ─────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────

  /// Ensures fresh location with dialog handling
  /// Shows dialogs if service/permission issues occur
  Future<LocationFlowResult> ensureFreshLocation({
    bool showDialogs = true,
    bool forceRefresh = true,
  }) async {
    if (isLoading.value) return LocationFlowResult.failed;

    isLoading.value = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      // ❌ SERVICE DISABLED → Show dialog
      if (!serviceEnabled) {
        isLocationActive.value = false;

        if (showDialogs) {
          final userTappedTurnOn = await _showTurnOnServiceDialog();

          if (userTappedTurnOn) {
            // Wait for user to return from settings
            await Future.delayed(const Duration(seconds: 1));

            // Retry check
            serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
              return LocationFlowResult.serviceDisabled;
            }
            // ✅ Service is now ON — fall through to permission check
          } else {
            return LocationFlowResult.serviceDisabled;
          }
        } else {
          return LocationFlowResult.serviceDisabled;
        }
      }

      // At this point, service is enabled
      var permission = await Geolocator.checkPermission();

      // ❌ PERMISSION DENIED → Show dialog
      if (permission == LocationPermission.denied) {
        if (showDialogs) {
          final userAgreed = await _showRationaleDialog();
          if (!userAgreed) {
            return LocationFlowResult.permissionDenied;
          }

          permission = await Geolocator.checkPermission();
        } else {
          return LocationFlowResult.permissionDenied;
        }
      }

      // ❌ PERMISSION PERMANENTLY DENIED
      if (permission == LocationPermission.deniedForever) {
        if (showDialogs) {
          await _showPermanentDeniedDialog();
        }
        return LocationFlowResult.permissionDeniedForever;
      }

      // ✅ Now try to get actual location
      final location = await LocationHelper.getCurrentLocation(
        showSnackbar: false, // ← No dialogs from helper
      );

      if (location == null) {
        isLocationActive.value = false;
        return LocationFlowResult.failed;
      }

      latitude.value = location.latitude;
      longitude.value = location.longitude;
      address.value = location.address;
      city.value = location.city ?? '';

      isLocationActive.value = true;
      locationFlowResult.value = LocationFlowResult.success;

      return LocationFlowResult.success;
    } catch (e) {
      print("❌ ensureFreshLocation error: $e");
      isLocationActive.value = false;
      return LocationFlowResult.failed;
    } finally {
      isLoading.value = false;
    }
  }

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

      print("✅ Updated location in backend");
    } catch (e) {
      print("❌ _updateBackend error: $e");
    }
  }

  // ─────────────────────────────────────────────
  // DIALOGS
  // ─────────────────────────────────────────────

  // Then replace the dialog methods:

  Future<bool> _showTurnOnServiceDialog() async {
    bool tappedTurnOn = false;

    await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: false,
      child: TurnOnServiceDialog(
        onTurnOn: () {
          tappedTurnOn = true;
        },
      ),
    );

    return tappedTurnOn;
  }

  Future<bool> _showRationaleDialog() async {
    bool agreed = false;

    await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: false,
      child: RationaleDialog(
        onAllowLocation: () async {
          Get.back();

          final permission = await Geolocator.requestPermission();
          agreed =
              permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse;
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
