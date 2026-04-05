import 'package:geolocator/geolocator.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../shared/mood/mood_check_in/mood_check_in_controller.dart';
import '../../../station_location/controller/station_location_controller.dart';
import '../dialogs/permanent_denied_dialog.dart';
import '../dialogs/rationale_dialog.dart';
import '../dialogs/turnon_service_dialog.dart';
import '../screen/home_screen.dart';

class HomeController extends GetxController {
  final mcc = findCont<MoodCheckInController>();

  @override
  void onInit() {
    debugPrint(' token :$getToken ');
    super.onInit();
  }

  @override
  void onClose() => super.onClose();

  void closeAllPopups() {}

  // eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoSWQiOiI2OWI1Mjg0ZTJhNjg1YjQwOGQ4ZmY4MDciLCJlbWFpbCI6ImFuYW5kYUB5b3BtYWlsLmNvbSIsInByb2ZpbGVJZCI6IjY5YjUyODRlMmE2ODViNDA4ZDhmZjgwOSIsImlhdCI6MTc3NDM0ODQ3OCwiZXhwIjoxODA1ODg0NDc4fQ.jtVoZZOpuniKm4gbc7FCO746cffDZP7esa9Zp_SbchY
  // eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoSWQiOiI2OWI1Mjg0ZTJhNjg1YjQwOGQ4ZmY4MDciLCJlbWFpbCI6ImFuYW5kYUB5b3BtYWlsLmNvbSIsInByb2ZpbGVJZCI6IjY5YjUyODRlMmE2ODViNDA4ZDhmZjgwOSIsImlhdCI6MTc3NDM0ODQ3OCwiZXhwIjoxODA1ODg0NDc4fQ.jtVoZZOpuniKm4gbc7FCO746cffDZP7esa9Zp_SbchY
  // ─────────────────────────────────────────────────────────────────────────
  // 🔹 Location permission flow
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> runLocationPermissionFlow() async {
    debugPrint("🔑 runLocationPermissionFlow START");

    // ── Geolocator.isLocationServiceEnabled() can hang on Android if the
    //    location subsystem isn't ready yet. Wrap with a timeout so we never
    //    block the UI indefinitely.
    bool serviceOn;
    LocationPermission permission;

    try {
      serviceOn = await Geolocator.isLocationServiceEnabled().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint("🔑 ⚠️ isLocationServiceEnabled timed out — assuming OFF");
          return false;
        },
      );

      permission = await Geolocator.checkPermission().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint("🔑 ⚠️ checkPermission timed out — assuming denied");
          return LocationPermission.denied;
        },
      );
    } catch (e) {
      debugPrint("🔑 ❌ Geolocator check failed: $e — showing inactive overlay");
      HomeScreen.showLocationStatusOverlay(isActive: false);
      return;
    }

    debugPrint("🔑 serviceOn: $serviceOn | permission: $permission");

    final alreadyGranted =
        permission == LocationPermission.always || permission == LocationPermission.whileInUse;

    // ── Happy path ────────────────────────────────────────────────────────────
    if (serviceOn && alreadyGranted) {
      debugPrint("🔑 Happy path — showing active overlay");
      await _refreshLocationData();
      HomeScreen.showLocationStatusOverlay(isActive: true);
      return;
    }

    // ── Service OFF ───────────────────────────────────────────────────────────
    if (!serviceOn) {
      debugPrint("🔑 Service OFF — showing turn-on dialog");
      final userOpenedSettings = await _showTurnOnServiceDialog();
      debugPrint("🔑 userOpenedSettings: $userOpenedSettings");

      if (!userOpenedSettings) {
        HomeScreen.showLocationStatusOverlay(isActive: false);
        return;
      }

      await Future.delayed(const Duration(milliseconds: 900));

      final nowOn = await Geolocator.isLocationServiceEnabled().timeout(
        const Duration(seconds: 4),
        onTimeout: () => false,
      );
      debugPrint("🔑 After settings — nowOn: $nowOn");

      if (!nowOn) {
        HomeScreen.showLocationStatusOverlay(isActive: false);
        return;
      }
      // Service now ON → fall through to permission check
    }

    // ── Permission not granted ────────────────────────────────────────────────
    if (!alreadyGranted) {
      if (permission == LocationPermission.deniedForever) {
        debugPrint("🔑 Permission permanently denied");
        await _showPermanentlyDeniedDialog();
        HomeScreen.showLocationStatusOverlay(isActive: false);
        return;
      }

      debugPrint("🔑 Showing rationale dialog");
      final userAgreed = await _showRationaleDialog();
      debugPrint("🔑 userAgreed: $userAgreed");

      if (!userAgreed) {
        HomeScreen.showLocationStatusOverlay(isActive: false);
        return;
      }

      final result = await Geolocator.requestPermission().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint("🔑 ⚠️ requestPermission timed out");
          return LocationPermission.denied;
        },
      );
      debugPrint("🔑 requestPermission result: $result");

      if (result == LocationPermission.denied || result == LocationPermission.deniedForever) {
        HomeScreen.showLocationStatusOverlay(isActive: false);
        return;
      }
    }

    // ── All checks passed ─────────────────────────────────────────────────────
    debugPrint("🔑 All checks passed — showing active overlay");
    await _refreshLocationData();
    HomeScreen.showLocationStatusOverlay(isActive: true);
  }

  Future<void> _refreshLocationData() async {
    try {
      await Get.find<StationLocationController>().getAndSaveInBackendCurrLoc();
    } catch (e) {
      debugPrint("HomeController: error refreshing location — $e");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 🔹 Dialogs
  // ─────────────────────────────────────────────────────────────────────────
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
        onAllowLocation: () {
          agreed = true;
          Get.back();
        },
      ),
    );

    return agreed;
  }

  Future<void> _showPermanentlyDeniedDialog() async {
    await showAnimatedDialog(context: Get.context!, child: PermanentDeniedDialog());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 🔹 Nearby suppliers
  // ─────────────────────────────────────────────────────────────────────────

  var isNearbySupplierLoading_ = false.obs;
  bool get isNearbySupplierLoading => isNearbySupplierLoading_.value;

  Future<void> getNearbySuppliersWithPriceStats({
    required double latitude,
    required double longitude,
  }) async {
    if (isNearbySupplierLoading_.value) return;
    isNearbySupplierLoading_.value = true;
    try {
      // await NearbySuppliersWPriceStatsService().fetchNearestSuppliersAndPriceStats(...)
    } catch (e) {
      debugPrint("Error fetching nearby suppliers: $e");
    } finally {
      isNearbySupplierLoading_.value = false;
    }
  }
}
 /*
First visit to HomeScreen
│
├─ Service ON + Permission granted
│     → _refreshLocationData()
│     → showOverlay(isActive: true)  ✅  ← this line was missing before
│
├─ Service OFF
│     → _showTurnOnServiceDialog()
│           "Not now"  → showOverlay(isActive: false)
│           "Turn On"  → openLocationSettings() → re-check
│                           still OFF → showOverlay(isActive: false)
│                           now ON    → fall through ↓
│
├─ Permission deniedForever
│     → _showPermanentlyDeniedDialog()
│     → showOverlay(isActive: false)
│
├─ Permission denied (requestable)
│     → _showRationaleDialog()
│           "Not now" → showOverlay(isActive: false)
│           "Allow"   → Geolocator.requestPermission()
│                           denied → showOverlay(isActive: false)
│                           granted → _refreshLocationData()
│                                   → showOverlay(isActive: true)  ✅

 */