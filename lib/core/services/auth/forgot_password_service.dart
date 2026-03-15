import '../../../../app/service_export.dart';
import '../../../features/auth/forgot_password/model/forgot_password_model.dart';

class ForgotPasswordService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  ///============================= SEND OTP ===================================///
  ///
  ///
  Future<bool> sendOtp({required String email}) async {
    //

    apiCall() {
      return ApiClient().post(
        Endpoints.resendCode.getUrl,
        headers: HeaderHelpers.jsonHeader(),
        data: {"email": email},
      );
    }

    final response = await _apiHelper.request<void>(apiCall: () => apiCall());

    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      print("Send otp is success!");
    }

    return response.success;
  }

  ///
  ///
  ///============================= SEND OTP ===================================///

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    //

    apiCall() {
      return ApiClient().patch(
        Endpoints.resetPassword.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
        data: {"email": email, "newPassword": newPassword, "confirmPassword": confirmPassword},
      );
    }

    final response = await _apiHelper.request<ForgotPassDataModel>(
      apiCall: apiCall,
      parser: (data) => ForgotPassDataModel.fromJson(data),
    );

    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      print("response.data?.user?.role : ${response.data?.user?.role}");
    }

    return response.success;
  }
}
