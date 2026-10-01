import '../../../../app/service_export.dart';
import '../../../features/auth/otp/model/verify_otp_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../features/shared/subscription/subscription_upgrade/service/purchase_service.dart';
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
      await _saveUserDataAfterVerify(response: response);
      print("response.data?.user.email : ${response.data?.user?.email}");
    }
    return response.isSuccess;
  }

  Future<void> _saveUserDataAfterVerify({
    required Result<VerifyOtpDataModel> response,
  }) async {
    if (response.data != null) {
      final token = response.data?.accessToken ?? '';
      storage.setToken(token);
      print("✅ Token saved: '$token'");

      storage.setUserId(response.data?.user?.profileId ?? ''); // NEW
      print(
        "Logged in as: ${response.data?.user?.email}, id: ${response.data?.user?.profileId}",
      );

      // Revenue cat
      // ADD HERE:
      await PurchaseService.to.loginRevenueCatUser(
        response.data?.user?.profileId ?? '',
      );

      // ✅ Now call ProfileController to refresh the profile
      if (Get.isRegistered<ProfileController>() &&
          storage.getToken.isNotEmpty) {
        final profileController = Get.find<ProfileController>();
        profileController.fetchMyProfile();
      }

      // ✅ Upload FCM token now that Bearer token is available
      if (Get.isRegistered<PushNotificationService>()) {
        print(
          "🔧 [VerifyOtpService] triggering FCM token upload after verify...",
        );
        PushNotificationService.to.uploadTokenAfterLogin();
      } else {
        print(
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
