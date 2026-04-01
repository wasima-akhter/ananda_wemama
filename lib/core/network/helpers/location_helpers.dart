import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/helper_widgets_export.dart';
import '../../common_widgets/models/my_location_result_model.dart';

class LocationHelper {
  /// Get current location with permission handling and user feedback
  static Future<LocationData?> getCurrentLocation({bool showSnackbar = true}) async {
    try {
      debugPrint('📍 Starting location fetch...');

      // 1️⃣ Check if GPS/location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('Service enabled: $serviceEnabled');

      if (!serviceEnabled) {
        if (showSnackbar) {
          Get.dialog(
            AlertDialog(
              title: Text(
                Strings.enableLocation.capEachWord(),
                style: TxtStyle.fs18.copyWith(color: c.textPrimary),
              ),
              content: Text(
                Strings.locationServicesOffMessage.capEachWord(),
                style: TxtStyle.norTxt,
              ),
              actions: [
                CustomBtnWTxt(
                  btnTxt: Strings.cancel.capEachWord(),
                  isLoading: false,
                  btnColor: bgClr,
                  txtClr: c.textPrimary,
                  onTap: () => Get.back(),
                  rad: 8,
                ),
                Gap(itemGap * 2),
                CustomBtnWTxt(
                  btnTxt: Strings.turnOn.capEachWord(),
                  isLoading: false,
                  btnColor: c.secondary,
                  txtClr: Colors.white,
                  onTap: () async {
                    Get.back();
                    await Geolocator.openLocationSettings();
                    // retry takking the current location
                    // 🔁 Retry getting current location after returning from settings
                    await Future.delayed(const Duration(seconds: 1));
                    final accuracyStatus = await Geolocator.getLocationAccuracy();
                    debugPrint("Accuracy status: $accuracyStatus");
                    await getCurrentLocation(showSnackbar: showSnackbar);
                  },
                  rad: 8,
                ),
              ],
            ),
            barrierDismissible: false,
          );
        }
        return null;
      }
      ////////////////-------------------

      // 2️⃣ Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('Current permission: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('Requesting permission...');
        permission = await Geolocator.requestPermission();
        debugPrint('Permission after request: $permission');

        if (permission == LocationPermission.denied) {
          if (showSnackbar) {
            // Permission denied snackbar
            Snack.showError(
              Strings.locationPermissionIsRequired.capEachWord(),
              title: Strings.permissionDenied.capEachWord(),
            );
          }
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (showSnackbar) {
          Get.dialog(
            AlertDialog(
              title: Text(Strings.permissionIsRequired.capEachWord()),
              content: Text(Strings.locationPermissionDeniedForeverPlzEnable.capEachWord()),
              actions: [
                TextButton(onPressed: () => Get.back(), child: Text(Strings.cancel)),
                TextButton(
                  onPressed: () {
                    Geolocator.openAppSettings();
                    Get.back();
                  },
                  child: Text(Strings.openSettings.capEachWord()),
                ),
              ],
            ),
          );
        }
        return null;
      }

      // 3️⃣ Get current position
      // Position position = await Geolocator.getCurrentPosition(
      //   locationSettings: const LocationSettings(
      //     accuracy: LocationAccuracy.bestForNavigation,
      //     distanceFilter: 10,
      //   ),
      // );
      // to avoid the device not getting loc error
      ////////////////-------------- Handled the position location

      Position? position;

      try {
        // 🥇 First attempt (balanced)
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
          timeLimit: const Duration(seconds: 8),
        );
      } catch (e) {
        debugPrint("⚠️ First attempt failed: $e");

        // ⏳ Give device time to stabilize GPS
        await Future.delayed(const Duration(seconds: 2));

        try {
          // 🥈 Second attempt (less strict)
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              distanceFilter: 20,
            ),
            timeLimit: const Duration(seconds: 10),
          );
        } catch (e) {
          debugPrint("❌ Retry failed: $e");

          // 🥉 Final fallback
          position = await Geolocator.getLastKnownPosition();
        }
      }

      if (position == null) {
        throw Exception("Location unavailable after retries");
      }
      ////////////////-------------- Handled the position location

      debugPrint('✅ Got position: ${position.latitude}, ${position.longitude}');

      // 4️⃣ Reverse geocode to get human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = '';
      String? city;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        city = place.locality;

        address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e!.isNotEmpty).join(', ');

        debugPrint('📍 Address: $address');
        if (city != null) debugPrint('📍 City: $city');
      }

      // 5️⃣ Return clean result
      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address.isNotEmpty
            ? address
            : 'Lat: ${position.latitude}, Lng: ${position.longitude}',
        city: city,
      );
    } catch (e) {
      debugPrint("❌ Error getting location: $e");
      if (showSnackbar) {
        // Failed to get location snackbar
        Snack.showError(
          'Failed to get location: ${e.toString()}',
          title: Strings.error.capEachWord(),
        );
      }
      return null;
    }
  }
}
