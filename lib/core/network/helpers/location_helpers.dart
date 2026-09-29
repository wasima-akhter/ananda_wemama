import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/ui/my_location_result_model.dart';

class LocationHelper {
  /// Get current location — NO DIALOGS
  /// Returns null if service disabled or permission denied
  static Future<LocationData?> getCurrentLocation({
    bool showSnackbar = true,
  }) async {
    try {
      print('📍 Starting location fetch...');

      // 1️⃣ Check service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Service enabled: $serviceEnabled');

      if (!serviceEnabled) {
        print('❌ Service disabled');
        return null;
      }

      // 2️⃣ Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('❌ Permission denied');
        return null;
      }

      // 3️⃣ Get position with retries
      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
          timeLimit: const Duration(seconds: 8),
        );
      } catch (e) {
        print("⚠️ First attempt failed: $e");
        await Future.delayed(const Duration(seconds: 2));

        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              distanceFilter: 20,
            ),
            timeLimit: const Duration(seconds: 10),
          );
        } catch (e) {
          print("❌ Retry failed: $e");
          position = await Geolocator.getLastKnownPosition();
        }
      }

      if (position == null) {
        throw Exception("Location unavailable after retries");
      }

      print('✅ Got position: ${position.latitude}, ${position.longitude}');

      // 4️⃣ GRACEFUL reverse geocoding — don't fail if it errors
      String address = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
      String? city;

      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            ).timeout(
              const Duration(seconds: 5), // ← Add timeout
              onTimeout: () {
                print('⏱️ Geocoding timeout');
                return [];
              },
            );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          city = place.locality;

          address = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((e) => e != null && e.isNotEmpty).join(', ');

          print('📍 Address: $address');
          if (city != null) print('📍 City: $city');
        }
      } catch (e) {
        // ✅ Geocoding failed, but we still have position — continue anyway
        print('⚠️ Geocoding failed: $e — using fallback address');
        // address stays as lat/lng fallback
      }

      // 5️⃣ Return result (with or without address)
      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        city: city,
      );
    } catch (e) {
      print("❌ Error getting location: $e");
      return null;
    }
  }
}
