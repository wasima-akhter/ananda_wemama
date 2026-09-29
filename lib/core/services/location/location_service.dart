import '../../../../app/service_export.dart';

class LocationService extends GetxService {
  // Update user location in backend
  Future<bool> updateLocation({
    required String address,
    required double latitude,
    required double longitude,
    String? city,
  }) async {
    final data = {
      'address': address,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    apiCall() {
      return ApiClient().post(
        Endpoints.addLocation.getUrl, // or POST depending on your API
        // reqName: 'Update Location',
        data: data,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    try {
      final response = await ApiExecutor().execute(
        apiCall: apiCall,
        parser: (data) => data,
      );

      if (response.isSuccess == true) {
        //

        print("✅ Location updated successfully in backend");
      } else {
        print(
          "❌ Failed to update location: ${response.message ?? 'Unknown error'}",
        );
      }

      return response.isSuccess;
    } catch (e) {
      print("Error updating location: $e");
      return false;
    }
  }

  // Get user location from backend
  // Future<Map<String, dynamic>?> getUserLocation() async {
  //   apiCall() {
  //     return ApiClient().get(Endpoints.getUserLocation.getUrl, // reqName: 'Get Location');
  //   }

  //   try {
  //     final response = await ApiExecutor().execute(apiCall: apiCall, parser: (data) => data);

  //     return response?.data;
  //   } catch (e) {
  //     print("Error getting location: $e");
  //     return null;
  //   }
  // }
}
