import '../../../../app/controller_export.dart';

class SignupController extends GetxController {
  // Text Controllers

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  // Focus Nodes

  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  var showPassword = false.obs;
  var showConPassword = false.obs;

  IconData get passwordIcon => !showPassword.value ? Icons.visibility_off : Icons.visibility;
  bool get isPassHidden => showPassword.value;

  IconData get conPassIcon => !showConPassword.value ? Icons.visibility_off : Icons.visibility;
  bool get isConPassHidden => showConPassword.value;

  void togglePass() => showPassword.toggle();
  void toggleConPass() => showConPassword.toggle();

  /// 🔹 Unfocus all fields (prevents keyboard/nav issues)
  void unfocusAll() {
    emailFocus.unfocus();
    passFocus.unfocus();
    confirmPassFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Reset all inputs + UI state
  void clearAll() {
    emailCtrl.clear();
    passCtrl.clear();
    confirmPassCtrl.clear();

    showPassword.value = false;
    showConPassword.value = false;

    unfocusAll();
  }

  Future<void> onTapSignup(GlobalKey<FormState> signUpFormKey) async {
    final isValid = validateForm(signUpFormKey);

    // ✅ FIXED condition
    if (!isValid || isLoading_.value) return;

    unfocusAll(); // 👈 important before API call

    print("validated all signup fields");
    isLoading_.value = true;

    // final success = await SignupService().signUp(
    //   name: nameCtrl.text.trim(),
    //   phone: phoneCtrl.text.trim(),
    //   email: emailCtrl.text.trim(),
    //   password: passCtrl.text.trim(),
    //   conPassword: confirmPassCtrl.text.trim(),
    // );

    isLoading_.value = false;

    // if (success) {
    //   clearAll(); // 👈 prevent leftover text + keyboard bugs

    //   Get.offAllNamed(
    //     RoutePaths.verifyOtp,

    //     arguments: {'flow': OtpFlowType.signup, 'email': emailCtrl.text.trim()},
    //   );
    // }
  }

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
