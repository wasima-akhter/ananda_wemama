import '../../../../app/service_export.dart';
import '../../../features/auth/forgot_password/model/forgot_password_model.dart';

class ForgotPasswordService extends GetxService {
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

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
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
        // headers: HeaderHelpers.getAuthHeader(),
        headers: HeaderHelpers.jsonHeader(),
        data: {
          "email": email,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
      );
    }

    final response = await ApiExecutor().execute<ForgotPassDataModel>(
      apiCall: apiCall,
      parser: (data) => ForgotPassDataModel.fromJson(data),
    );

    return response.isSuccess;
  }
}
