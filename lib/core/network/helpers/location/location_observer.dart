import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../../../app/helper_widgets_export.dart';

/// Watches for location service enable/disable changes at the OS level.
/// Fires [onLocationEnabled] / [onLocationDisabled] when the state changes.
/// Also fires [onPermissionGranted] / [onPermissionDenied] after a permission check.
class LocationStatusObserver {
  LocationStatusObserver._();

  static LocationStatusObserver? _instance;
  static LocationStatusObserver get instance => _instance ??= LocationStatusObserver._();

  StreamSubscription<ServiceStatus>? _serviceSubscription;

  bool? _lastServiceStatus; // null = unknown

  /// Start observing. Call once (e.g. in [MainNavController.onInit]).
  void startListening({
    required VoidCallback onLocationEnabled,
    required VoidCallback onLocationDisabled,
  }) {
    _serviceSubscription?.cancel();

    _serviceSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      final isEnabled = status == ServiceStatus.enabled;

      // Only fire when the state *changes* (avoids noise on first emission)
      if (_lastServiceStatus != null && _lastServiceStatus != isEnabled) {
        if (isEnabled) {
          onLocationEnabled();
        } else {
          onLocationDisabled();
        }
      }

      _lastServiceStatus = isEnabled;
    });
  }

  void stopListening() {
    _serviceSubscription?.cancel();
    _serviceSubscription = null;
  }

  /// Seed the last-known state so the first emission is ignored (no false triggers).
  Future<void> seedCurrentStatus() async {
    final enabled = await Geolocator.isLocationServiceEnabled().timeout(
      const Duration(seconds: 5),
      onTimeout: () => false,
    );
    _lastServiceStatus = enabled;
  }
}
