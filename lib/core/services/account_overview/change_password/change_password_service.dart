import '../../../../../app/service_export.dart';

class ChangePasswordService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    //
    // {
    //     "currentPassword": "123456",
    //     "newPassword": "123456",
    //     "confirmPassword": "123456"
    // }
    apiCall() {
      return ApiClient().patch(
        Endpoints.changePassword.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
        data: {
          "currentPassword": oldPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);

    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      print("response.success : ${response.success}");
    }

    return response.success;
  }
}
