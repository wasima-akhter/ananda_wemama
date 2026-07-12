import '../../../../../app/service_export.dart';

class ChangePasswordService extends GetxService {
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

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
  }
}
