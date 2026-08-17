import 'package:flutter/foundation.dart';
import 'package:we_mama/core/constants/icon_and_image_paths.dart';
import 'package:we_mama/features/auth/signin/model/signin_model.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/config/app_info.dart';
import '../../../../core/services/auth/signin_service.dart';
import '../../../../core/services/auth/verify_otp_service.dart';
import '../../../../core/services/deep_link/app_link_service.dart';
import '../../../../core/services/push_notification/push_notification_service.dart';

class SigninController extends GetxController {
  static SigninController get to => Get.find<SigninController>();

  /// ================= FORM CONTROLLERS =================
  final emailCtrler = TextEditingController();
  final passwordCtrler = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  /// ================= UI STATE =================
  final _showPassword = false.obs;
  bool get isPasswordHidden => !_showPassword.value;

  String get passwordIcon =>
      _showPassword.value ? IconsPath.visibilityOn : IconsPath.visibilityOff;

  void togglePasswordVisibility() => _showPassword.toggle();

  //
  final rememberMe = false.obs;

  // =========== Auth Progress ===========
  final authInProgress = false.obs;

  bool get isAnyAuthLoading => authInProgress.value;
  void _startAuth() {
    authInProgress.value = true;
  }

  void _stopAuth() {
    authInProgress.value = false;
  }

  /// ================= LOADING STATE =================
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// ================= NAVIGATION =================
  void goToSignup() => Get.toNamed(RoutePaths.signup);

  void goToForgotPassword() => Get.toNamed(RoutePaths.forgotPassword);

  /// ================= LOGIN ACTION =================
  Future<void> onTapLogin(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);
    if (!isValid || _isLoading.value) return;

    if (_isLoading.value) return;

    unfocusAll();

    //
    _startAuth();
    _isLoading.value = true;

    try {
      final email = emailCtrler.text.trim();
      final password = passwordCtrler.text.trim();

      final result = await SigninService().signIn(
        email: email,
        password: password,
      );
      log("result type of login from controller : ${result.type}");
      switch (result.type) {
        // ❌ EMAIL NOT VERIFIED
        case LoginApiResultType.emailNotVerified:
          // Get.toNamed(
          //   RoutePaths.verifyOtp,
          //   arguments: {'flow': OtpFlowType.signup, 'email': email},
          // );

          final sentOtpSuccess = await VerifyOtpService().resendOtp(
            email: email,
          );

          if (sentOtpSuccess) {
            final result = await Get.toNamed(
              RoutePaths.verifyOtp,
              arguments: {'flow': OtpFlowType.signup, 'email': email},
            );
          }
          return;

        // ❌ PROFILE NOT COMPLETED
        case LoginApiResultType.profileIncomplete:
          Get.offAllNamed(RoutePaths.setupProfile);
          return;

        // ✅ SUCCESS
        case LoginApiResultType.success:
          storage.setLoggedIn(true);
          storage.setSeenOnboarding(true);

          await _handleLoginSuccess();
          return;

        // ❌ FAILED
        case LoginApiResultType.failed:
          return;
      }
    } catch (e, stack) {
      log('Login Error: $e');
      log('STACK: $stack');
    } finally {
      _isLoading.value = false;
      _stopAuth();
    }
  }

  Future<void> _handleLoginSuccess() async {
    log("1. handleLoginSuccess");

    clearFields();

    if (Get.isRegistered<PushNotificationService>()) {
      log("2. before uploadTokenAfterLogin");
      await PushNotificationService.to.uploadTokenAfterLogin();
      log("3. after uploadTokenAfterLogin");
    }

    final deepLinkService = Get.find<DeepLinkService>();

    log("4. pendingLiveId=${deepLinkService.pendingLiveId}");

    if (deepLinkService.pendingLiveId != null) {
      log("5. before handlePostLoginRedirect");
      await deepLinkService.handlePostLoginRedirect();
      log("6. after handlePostLoginRedirect");
    } else {
      log("7. navigating");
      Get.offAllNamed(RoutePaths.mainNav);
      log("8. navigation called");
    }
  }

  /// ================= HELPERS =================
  void unfocusAll() {
    emailFocus.unfocus();
    passwordFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void clearFields() {
    emailCtrler.clear();
    passwordCtrler.clear();
    _showPassword.value = false;
    unfocusAll();
  }

  /// ================= LIFECYCLE =================
  @override
  void onInit() {
    log('Base URL: $baseUrl');

    if (kDebugMode) {
      // emailCtrler.text = "ananda@yopmail.com";
      // emailCtrler.text = "mojahid.office404@gmail.com";
      emailCtrler.text = "xyzt@yopmail.com";
      passwordCtrler.text = "123456";
    }
    super.onInit();
  }

  // @override
  // void onClose() {
  //   emailCtrler.dispose();
  //   passwordCtrler.dispose();
  //   emailFocus.dispose();
  //   passwordFocus.dispose();
  //   super.onClose();
  // }

  @override
  void onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────
  //                           SOCIAL LOGIN
  // ─────────────────────────────────────────────────────────────────
  // ADD these imports to signin_controller.dart
  // ─────────────────────────────────────────────────────────────────
  // import '../../../../core/services/auth/social_login_service.dart';

  // ─────────────────────────────────────────────────────────────────
  // ADD this block inside SigninController (alongside existing methods)
  // ─────────────────────────────────────────────────────────────────

  // ── Social login loading state (separate so it doesn't block the normal login button) ──
  final googleLoading = false.obs;
  final appleLoading = false.obs;

  // ── Google ──────────────────────────────────────────────────────

  Future<void> onTapGoogleLogin() async {
    if (googleLoading.value) return;

    _startAuth();
    googleLoading.value = true;

    try {
      final idToken = await SocialLoginService().getGoogleIdToken();
      if (idToken == null) return; // user cancelled — do nothing

      await _handleSocialLogin(authToken: idToken, provider: 'google');
    } catch (e, stack) {
      log('Google login error: $e');
      log('STACK: $stack');
    } finally {
      googleLoading.value = false;
      _stopAuth();
    }
  }

  // ── Apple ───────────────────────────────────────────────────────

  Future<void> onTapAppleLogin() async {
    // if (Platform.isAndroid) {
    //   Snack.showWarning("Only for Apple users");
    // }
    if (appleLoading.value) return;

    _startAuth();
    appleLoading.value = true;

    try {
      final idToken = await SocialLoginService().getAppleIdToken();
      if (idToken == null) return; // user cancelled — do nothing

      await _handleSocialLogin(authToken: idToken, provider: 'apple');
    } catch (e, stack) {
      log('Apple login error: $e');
      log('STACK: $stack');
    } finally {
      appleLoading.value = false;
      _stopAuth();
    }
  }

  /*
  At the end, you should have these values
Item	Example
Bundle ID	com.company.myapp
Services ID	com.company.myapp.service
Team ID	ABCD123456
Key ID	XYZ9876543
Private Key	AuthKey_XXXXXX.p8
*/

  // ── Shared handler ───────────────────────────────────────────────

  Future<void> _handleSocialLogin({
    required String authToken,
    required String provider,
  }) async {
    final result = await SocialLoginService().socialLogin(
      authToken: authToken,
      provider: provider,
    );

    switch (result.type) {
      case SocialLoginApiResultType.success:
        storage.setLoggedIn(true);
        storage.setSeenOnboarding(true);

        FocusManager.instance.primaryFocus?.unfocus();

        await _handleLoginSuccess();
        Get.offAllNamed(RoutePaths.mainNav);

      case SocialLoginApiResultType.profileIncomplete:
        Get.offAllNamed(RoutePaths.setupProfile);

      case SocialLoginApiResultType.failed:
        // ApiServiceHelper already shows the error toast — nothing extra needed.
        break;

      case SocialLoginApiResultType.cancelled:
        break;
    }
  }
}
