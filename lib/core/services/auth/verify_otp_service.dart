import '../../../../app/service_export.dart';
import '../../../features/auth/otp/model/verify_otp_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../push_notification/push_notification_service.dart';

class VerifyOtpService extends GetxService {
  Future<bool> verify({required String email, required String otp}) async {
    //

    apiCall() {
      return ApiClient().post(
        Endpoints.verifyCode.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
        data: {"email": email, "verifyCode": otp},
      );
    }

    final response = await ApiExecutor().execute<VerifyOtpDataModel>(
      apiCall: apiCall,
      parser: (data) => VerifyOtpDataModel.fromJson(data),
    );

    // You can access user like:
    if (response.isSuccess) {
      _saveUserDataAfterVerify(response: response);
      log("response.data?.user.email : ${response.data?.user?.email}");
    }
    return response.isSuccess;
  }

  void _saveUserDataAfterVerify({
    required Result<VerifyOtpDataModel> response,
  }) {
    if (response.data != null) {
      final token = response.data?.accessToken ?? '';
      storage.setToken(token);
      log("✅ Token saved: '$token'");

      // ✅ Now call ProfileController to refresh the profile
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.fetchMyProfile();
      }

      // ✅ Upload FCM token now that Bearer token is available
      if (Get.isRegistered<PushNotificationService>()) {
        log(
          "🔧 [VerifyOtpService] triggering FCM token upload after verify...",
        );
        PushNotificationService.to.uploadTokenAfterLogin();
      } else {
        log(
          "⚠️ [VerifyOtpService] PushNotificationService not registered — skipping FCM upload",
        );
      }
    }
  }

  ///=============================RESEND OTP ===================================///
  ///
  ///
  Future<bool> resendOtp({required String email}) async {
    //

    apiCall() {
      return ApiClient().post(
        Endpoints.resendCode.getUrl,
        headers: HeaderHelpers.jsonHeader(),
        data: {"email": email},
      );
    }

    final response = await ApiExecutor().execute<void>(
      apiCall: () => apiCall(),
    );

    return response.isSuccess;
  }
}
