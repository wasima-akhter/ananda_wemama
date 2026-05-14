import '../../../../app/controller_export.dart';
import '../../../../core/services/auth/signup_service.dart';
import '../../../../core/services/auth/verify_otp_service.dart';

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

  final agreedToTerms = false.obs;
  void toggleAgreement() => agreedToTerms.toggle();

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final showPassword = false.obs;
  final showConPassword = false.obs;

  bool get isPassHidden => !showPassword.value;
  bool get isConPassHidden => !showConPassword.value;

  IconData get passwordIcon => showPassword.value ? Icons.visibility : Icons.visibility_off;

  IconData get conPassIcon => showConPassword.value ? Icons.visibility : Icons.visibility_off;

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

    if (!agreedToTerms.value) {
      Snack.showWarning("Please agree to the Terms of Service to continue.");
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    try {
      final success = await SignupService().signUp(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        conPassword: confirmPassCtrl.text.trim(),
      );

      if (success) {
        final sentOtpSuccess = await VerifyOtpService().resendOtp(email: emailCtrl.text.trim());

        if (sentOtpSuccess) {
          final result = await Get.toNamed(
            RoutePaths.verifyOtp,
            arguments: {'flow': OtpFlowType.signup, 'email': emailCtrl.text.trim()},
          );
        }
      }

      clearAll();
      print("Signup logic placeholder executed");
    } catch (e, s) {
      print("Signup error: $e");
      print(s);
    } finally {
      isLoading_.value = false;
    }
  }

  // ─────────────────────────────
  // 🔹 Lifecycle
  // ─────────────────────────────
  @override
  void onClose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();

    emailFocus.dispose();
    passFocus.dispose();
    confirmPassFocus.dispose();

    super.onClose();
  }
}
