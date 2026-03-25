import 'package:flutter/foundation.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/config/app_info.dart';
import '../../../../core/services/auth/signin_service.dart';

class SigninController extends GetxController {
  /// ================= FORM CONTROLLERS =================
  final emailCtrler = TextEditingController();
  final passwordCtrler = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  /// ================= UI STATE =================
  final _showPassword = false.obs;
  bool get isPasswordHidden => !_showPassword.value;

  IconData get passwordIcon => _showPassword.value ? Icons.visibility : Icons.visibility_off;

  void togglePasswordVisibility() => _showPassword.toggle();

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

      final success = await SigninService().signIn(email: email, password: password);

      if (!success) return;

      storage.setLoggedIn(true);
      storage.setSeenOnboarding(true);

      _handleLoginSuccess();
    } catch (e) {
      debugPrint('Login Error: $e');
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
    debugPrint('Base URL: $baseUrl');

    if (kDebugMode) {
      emailCtrler.text = "ananda@yopmail.com";
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
}
