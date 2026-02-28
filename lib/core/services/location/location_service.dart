import 'package:flutter/material.dart';

import '../../../../app/service_export.dart';

class LocationService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // Update user location in backend
  Future<bool> updateLocation({
    required String address,
    required double latitude,
    required double longitude,
    String? city,
  }) async {
    final data = {
      'location': address,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      // if (city != null && city.isNotEmpty) 'city': city,
    };

    apiCall() {
      return ApiClient().post(
        Endpoints.addLocation.getUrl, // or POST depending on your API
        reqName: 'Update Location',
        data: data,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    try {
      final response = await _apiHelper.request(apiCall: apiCall, parser: (data) => data);

      if (response?.success == true) {
        //

        debugPrint("✅ Location updated successfully in backend");
      } else {
        debugPrint("❌ Failed to update location: ${response?.message ?? 'Unknown error'}");
      }

      return response?.success ?? false;
    } catch (e) {
      debugPrint("Error updating location: $e");
      return false;
    }
  }

  // Get user location from backend
  // Future<Map<String, dynamic>?> getUserLocation() async {
  //   apiCall() {
  //     return ApiClient().get(Endpoints.getUserLocation.getUrl, reqName: 'Get Location');
  //   }

  //   try {
  //     final response = await _apiHelper.request(apiCall: apiCall, parser: (data) => data);

  //     return response?.data;
  //   } catch (e) {
  //     debugPrint("Error getting location: $e");
  //     return null;
  //   }
  // }
}
