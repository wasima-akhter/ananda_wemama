import '../../../../app/controller_export.dart';

class ForgotPasswordController extends GetxController {
  var showPassSection = false.obs;
  var showContinueBtn = false.obs;

  final emailCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  final emailFocus = FocusNode();
  final newPassFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  var showPassword = false.obs;
  var showConPassword = false.obs;

  IconData get newPasswordIcon => !showPassword.value ? Icons.visibility_off : Icons.visibility;
  bool get isNewPassHidden => showPassword.value;

  IconData get conPassIcon => !showConPassword.value ? Icons.visibility_off : Icons.visibility;
  bool get isConPassHidden => showConPassword.value;

  void toggleNewPass() => showPassword.toggle();
  void toggleConPass() => showConPassword.toggle();

  /// ================= KEYBOARD HELPER =================
  void unfocusAll() {
    emailFocus.unfocus();
    newPassFocus.unfocus();
    confirmPassFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// ================= CLEAR FORM =================
  void clearAllFields() {
    emailCtrl.clear();
    newPassCtrl.clear();
    confirmPassCtrl.clear();

    showPassword.value = false;
    showConPassword.value = false;
    showPassSection.value = false;
    showContinueBtn.value = false;

    unfocusAll();
  }

  // ================= SEND OTP =================
  final isSendOtpLoading_ = false.obs;
  bool get isSendOtpLoading => isSendOtpLoading_.value;

  void onTapSendOtp({required GlobalKey<FormState> formKey}) async {
    final isValid = validateForm(formKey);
    if (!isValid || isSendOtpLoading_.value) return;

    unfocusAll();
    isSendOtpLoading_.value = true;

    // final success = await ForgotPasswordService().sendOtp(email: emailCtrl.text.trim());

    isSendOtpLoading_.value = false;

    // if (success) {
    //   final result = await GNav.pushNamed(
    //     RoutePaths.verifyOtp,

    //     arguments: {'flow': OtpFlowType.forgotPassword, 'email': emailCtrl.text.trim()},
    //   );

    //   if (result == true) {
    //     showPassSection.value = true;
    //   }
    // }
  }

  // ================= RESET PASSWORD =================
  final isResetPassLoading_ = false.obs;
  bool get isResetPassLoading => isResetPassLoading_.value;

  Future<void> onTapResetPass({required GlobalKey<FormState> formKey}) async {
    final isValid = validateForm(formKey);
    if (!isValid || isResetPassLoading_.value) return;

    unfocusAll();
    isResetPassLoading_.value = true;

    // final success = await ForgotPasswordService().resetPassword(
    //   email: emailCtrl.text.trim(),
    //   newPassword: newPassCtrl.text,
    //   confirmPassword: confirmPassCtrl.text,
    // );

    isResetPassLoading_.value = false;

    // if (success) {
    //   showContinueBtn.value = true;
    // }
  }

  /// ================= LIFECYCLE CLEANUP =================
  @override
  void onClose() {
    emailCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();

    emailFocus.dispose();
    newPassFocus.dispose();
    confirmPassFocus.dispose();

    super.onClose();
  }
}
