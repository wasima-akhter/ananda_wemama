import 'package:geolocator/geolocator.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../features/main_tabs/home/dialogs/permanent_denied_dialog.dart';
import '../../../../features/main_tabs/home/dialogs/rationale_dialog.dart';
import '../../../../features/main_tabs/home/dialogs/turnon_service_dialog.dart';
import '../../../components/ui/dialogs/popups.dart';

/// Handles the one-time, context-aware permission + service request shown
/// when the user lands on HomeScreen for the first time in a session.
class LocationPermissionFlow {
  LocationPermissionFlow._();

  /// Call this from HomeScreen (or HomeController.onInit) on first visit.
  ///
  /// Logic:
  ///  1. If permission already granted AND service on → silently fetch location.
  ///  2. If service OFF → show "Turn on" dialog with matching context.
  ///  3. If permission denied/unknown → request it with contextual rationale dialog.
  ///  4. If permanently denied → open app settings dialog.
  static Future<void> requestIfNeeded({
    required bool isFirstVisit,
    VoidCallback? onLocationReady, // callback when location is available
    VoidCallback? onLocationUnavailable, // callback when we still can't get it
  }) async {
    if (!isFirstVisit) return;

    // ── 1. Check current status ──────────────────────────────────────────────
    final serviceOn = await Geolocator.isLocationServiceEnabled().timeout(
      const Duration(seconds: 5),
      onTimeout: () => false,
    );
    final permission = await Geolocator.checkPermission();

    final alreadyGranted =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    if (serviceOn && alreadyGranted) {
      // Silent happy path — location is already available
      onLocationReady?.call();
      return;
    }

    // ── 2. Service OFF ───────────────────────────────────────────────────────
    if (!serviceOn) {
      final turnedOn = await _showTurnOnServiceDialog();
      if (!turnedOn) {
        onLocationUnavailable?.call();
        return;
      }
      // Re-check after user returns from settings
      final nowOn = await Geolocator.isLocationServiceEnabled().timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
      if (!nowOn) {
        onLocationUnavailable?.call();
        return;
      }
    }

    // ── 3. Permission not granted ────────────────────────────────────────────
    if (!alreadyGranted) {
      if (permission == LocationPermission.deniedForever) {
        await _showPermanentlyDeniedDialog();
        onLocationUnavailable?.call();
        return;
      }

      // Show rationale dialog BEFORE requesting the system permission dialog
      final userAgreed = await _showRationaleDialog();
      if (!userAgreed) {
        onLocationUnavailable?.call();
        return;
      }

      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.denied ||
          result == LocationPermission.deniedForever) {
        onLocationUnavailable?.call();
        return;
      }
    }

    // ── 4. All good — fetch location ─────────────────────────────────────────
    onLocationReady?.call();
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────────

  /// Returns true if the user tapped "Turn On" (and we opened settings).
  static Future<bool> _showTurnOnServiceDialog() async {
    bool tapped = false;

    await showAnimatedDialog(
      context: Get.context!,
      child: TurnOnServiceDialog(onTurnOn: () => tapped = true),
      barrierDismissible: false,
    );

    return tapped;
  }

  /// Returns true if user tapped "Allow".
  static Future<bool> _showRationaleDialog() async {
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

  static Future<void> _showPermanentlyDeniedDialog() async {
    await showAnimatedDialog(
      context: Get.context!,
      child: PermanentDeniedDialog(),
    );
  }

  //
}
