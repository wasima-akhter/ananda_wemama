import '../../../../app/controller_export.dart';
import '../../../../core/constants/icon_and_image_paths.dart';
import '../../../../core/services/auth/signin_service.dart';
import '../../../../core/services/auth/signup_service.dart';
import '../../../../core/services/push_notification/push_notification_service.dart';

class SignupController extends GetxController {
  // ─────────────────────────────
  // 🔹 Text Controllers
  // ─────────────────────────────
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  // ─────────────────────────────
  // 🔹 Focus Nodes
  // ─────────────────────────────
  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  // ─────────────────────────────
  // 🔹 UI State
  // ─────────────────────────────

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final showPassword = false.obs;
  final showConPassword = false.obs;

  bool get isPassHidden => !showPassword.value;
  bool get isConPassHidden => !showConPassword.value;

  String get passwordIcon =>
      showPassword.value ? IconsPath.visibilityOn : IconsPath.visibilityOff;

  String get conPassIcon =>
      showConPassword.value ? IconsPath.visibilityOn : IconsPath.visibilityOff;

  void togglePass() => showPassword.toggle();
  void toggleConPass() => showConPassword.toggle();

  // ─────────────────────────────
  // 🔹 Navigation Helpers
  // ─────────────────────────────
  void goToVerifyOtp() {
    Get.toNamed(
      RoutePaths.verifyOtp,
      arguments: {'flow': OtpFlowType.signup, 'email': emailCtrl.text.trim()},
    );
  }

  // ─────────────────────────────
  // 🔹 Input & Focus Utilities
  // ─────────────────────────────
  void unfocusAll() {
    emailFocus.unfocus();
    passFocus.unfocus();
    confirmPassFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void clearAll() {
    emailCtrl.clear();
    passCtrl.clear();
    confirmPassCtrl.clear();

    showPassword.value = false;
    showConPassword.value = false;

    unfocusAll();
  }

  // ─────────────────────────────
  // 🔹 Actions
  // ─────────────────────────────
  Future<void> onTapSignup(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;

    unfocusAll();
    isLoading_.value = true;

    try {
      final success = await SignupService().signUp(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        conPassword: confirmPassCtrl.text.trim(),
      );

      if (success) {
        // DO NOT SEND OTP  MANUALLY.
        // BACKEDN ALREADY IS SENDING IT.
        //
        // final sentOtpSuccess = await VerifyOtpService().resendOtp(
        //   email: emailCtrl.text.trim(),
        // );

        // if (sentOtpSuccess) {
        final result = await Get.toNamed(
          RoutePaths.verifyOtp,
          arguments: {
            'flow': OtpFlowType.signup,
            'email': emailCtrl.text.trim(),
          },
        );
        // }
      }

      clearAll();
      print("Signup logic placeholder executed");
    } catch (e, s) {
      print("Signup error: $e");
      print(s.toString());
    } finally {
      isLoading_.value = false;
    }
  }

  //

  //

  final googleLoading = false.obs;
  final appleLoading = false.obs;
  Future<void> onTapGoogleSignup() async {
    if (googleLoading.value) return;
    googleLoading.value = true;

    try {
      final idToken = await SocialLoginService().getGoogleIdToken();
      if (idToken == null) return;

      final result = await SignupService().socialSignup(
        authToken: idToken,
        provider: 'google',
      );

      switch (result.type) {
        case SocialLoginApiResultType.success:
          storage.setLoggedIn(true);
          storage.setSeenOnboarding(true);

          await _handlePostAuthSuccess(isGoogle: true);
          return;

        case SocialLoginApiResultType.profileIncomplete:
          storage.setLoggedIn(true);
          storage.setSeenOnboarding(true);

          if (Get.isRegistered<PushNotificationService>()) {
            await PushNotificationService.to.uploadTokenAfterLogin();
          }

          Get.offAllNamed(RoutePaths.setupProfile);
          return;

        case SocialLoginApiResultType.failed:
        case SocialLoginApiResultType.cancelled:
          return;
      }
    } finally {
      googleLoading.value = false;
    }
  }

  Future<void> onTapAppleSignup() async {
    if (appleLoading.value) return;
    appleLoading.value = true;

    try {
      final idToken = await SocialLoginService().getAppleIdToken();
      if (idToken == null) return;

      final result = await SignupService().socialSignup(
        authToken: idToken,
        provider: 'apple',
      );

      switch (result.type) {
        case SocialLoginApiResultType.success:
          storage.setLoggedIn(true);
          storage.setSeenOnboarding(true);

          await _handlePostAuthSuccess(isGoogle: false);
          return;

        case SocialLoginApiResultType.profileIncomplete:
          storage.setLoggedIn(true);
          storage.setSeenOnboarding(true);

          if (Get.isRegistered<PushNotificationService>()) {
            await PushNotificationService.to.uploadTokenAfterLogin();
          }

          Get.offAllNamed(RoutePaths.setupProfile);
          return;

        case SocialLoginApiResultType.failed:
        case SocialLoginApiResultType.cancelled:
          return;
      }
    } finally {
      appleLoading.value = false;
    }
  }

  Future<void> _handlePostAuthSuccess({required bool isGoogle}) async {
    if (Get.isRegistered<PushNotificationService>()) {
      print("Uploading FCM token after social signup/login");

      await PushNotificationService.to.uploadTokenAfterLogin();

      print("FCM token uploaded");
    }

    Snack.showSuccess(
      "Signup successful! Please sign in with ${isGoogle ? 'Google' : 'Apple'} from the Sign In screen.",
    );

    await Future.delayed(
      Duration(seconds: 1),
      () => Get.toNamed(RoutePaths.signin),
    );
  }

  // ─────────────────────────────
  // 🔹 Lifecycle
  // ─────────────────────────────
  // @override
  // void onClose() {
  //   emailCtrl.dispose();
  //   passCtrl.dispose();
  //   confirmPassCtrl.dispose();

  //   emailFocus.dispose();
  //   passFocus.dispose();
  //   confirmPassFocus.dispose();

  //   super.onClose();
  // }
  @override
  void onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.onClose();
  }
}
