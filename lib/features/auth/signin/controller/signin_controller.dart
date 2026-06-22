import 'package:flutter/foundation.dart';
import 'package:mama_app/core/constants/icon_and_image_paths.dart';
import 'package:mama_app/features/auth/signin/model/signin_model.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/config/app_info.dart';
import '../../../../core/services/auth/signin_service.dart';
import '../../../../core/services/auth/verify_otp_service.dart';

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
        case LoginResultType.emailNotVerified:
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
        case LoginResultType.profileIncomplete:
          Get.offAllNamed(RoutePaths.setupProfile);
          return;

        // ✅ SUCCESS
        case LoginResultType.success:
          storage.setLoggedIn(true);
          storage.setSeenOnboarding(true);

          _handleLoginSuccess();
          return;

        // ❌ FAILED
        case LoginResultType.failed:
          return;
      }
    } catch (e, stack) {
      log('Login Error: $e');
      log('STACK: $stack');
    } finally {
      _isLoading.value = false;
    }
  }

  void _handleLoginSuccess() {
    clearFields();
    Get.offAllNamed(RoutePaths.mainNav);
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

  @override
  void onClose() {
    emailCtrler.dispose();
    passwordCtrler.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
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
  final _isSocialLoading = false.obs;
  bool get isSocialLoading => _isSocialLoading.value;

  // ── Google ──────────────────────────────────────────────────────

  Future<void> onTapGoogleLogin() async {
    if (_isSocialLoading.value) return;
    _isSocialLoading.value = true;

    try {
      final idToken = await SocialLoginService().getGoogleIdToken();
      if (idToken == null) return; // user cancelled — do nothing

      await _handleSocialLogin(authToken: idToken, provider: 'google');
    } catch (e, stack) {
      log('Google login error: $e');
      log('STACK: $stack');
    } finally {
      _isSocialLoading.value = false;
    }
  }

  // ── Apple ───────────────────────────────────────────────────────

  Future<void> onTapAppleLogin() async {
    if (_isSocialLoading.value) return;
    _isSocialLoading.value = true;

    try {
      final idToken = await SocialLoginService().getAppleIdToken();
      if (idToken == null) return; // user cancelled — do nothing

      await _handleSocialLogin(authToken: idToken, provider: 'apple');
    } catch (e, stack) {
      log('Apple login error: $e');
      log('STACK: $stack');
    } finally {
      _isSocialLoading.value = false;
    }
  }

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
      case SocialLoginResultType.success:
        storage.setLoggedIn(true);
        storage.setSeenOnboarding(true);
        clearFields();
        Get.offAllNamed(RoutePaths.mainNav);

      case SocialLoginResultType.profileIncomplete:
        Get.offAllNamed(RoutePaths.setupProfile);

      case SocialLoginResultType.failed:
        // ApiServiceHelper already shows the error toast — nothing extra needed.
        break;

      case SocialLoginResultType.cancelled:
        break;
    }
  }
}
