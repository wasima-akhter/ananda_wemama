import '../../../../app/service_export.dart';

class VerifyOtpService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // Future<bool> verify({required String email, required String otp}) async {
  //   //

  //   apiCall() {
  //     return ApiClient().post(
  //       Endpoints.verifyCode.getUrl,
  //       headers: HeaderHelpers.getAuthHeader(),
  //       data: {"email": email, "verifyCode": otp},
  //     );
  //   }

  //   final response = await _apiHelper.request<VerifyOtpDataModel>(
  //     apiCall: apiCall,
  //     parser: (data) => VerifyOtpDataModel.fromJson(data),
  //   );

  //   if (response == null) return false;

  //   // You can access user like:
  //   if (response.success) {
  //     _saveUserDataAfterVerify(response: response);
  //     print("response.data?.user.email : ${response.data?.user?.email}");
  //   }

  //   return response.success;
  // }

  // void _saveUserDataAfterVerify({required BaseResponse<VerifyOtpDataModel> response}) {
  //   // as success,
  //   // save the access token in app storage
  //   // save the user info in appstorage
  //   if (response.data != null) {
  //     final user = response.data?.user;

  //     // set user role
  //     // UserRole

  //     storage.setUserRole(user?.role?.toUserRole() ?? UserRole.customer);

  //     // token
  //     storage.setToken(response.data?.accessToken ?? '');

  //     // ✅ Now call ProfileController to refresh the profile
  //     if (Get.isRegistered<ProfileController>()) {
  //       final profileController = Get.find<ProfileController>();
  //       profileController.fetchMyProfile(); // fetch latest profile data
  //     }
  //   }
  // }

  // ///=============================RESEND OTP ===================================///
  // ///
  // ///
  // Future<bool> resendOtp({required String email}) async {
  //   //

  //   apiCall() {
  //     return ApiClient().post(
  //       Endpoints.resendCode.getUrl,
  //       headers: HeaderHelpers.jsonHeader(),
  //       data: {"email": email},
  //     );
  //   }

  //   final response = await _apiHelper.request<void>(apiCall: () => apiCall());

  //   if (response == null) return false;

  //   // You can access user like:
  //   if (response.success) {
  //     print("Resend otp is success!");
  //   }

  //   return response.success;
  // }
}
