import 'package:flutter/foundation.dart';
import 'package:we_mama/core/services/auth/forgot_password_service.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/constants/icon_and_image_paths.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/services/auth/verify_otp_service.dart';

class ForgotPasswordController extends GetxController {
  /// ================= FLOW STATE =================
  final step = ForgotPasswordStep.enterEmail.obs;

  bool get isEnterEmail => step.value == ForgotPasswordStep.enterEmail;
  bool get isResetPassword => step.value == ForgotPasswordStep.resetPassword;
  // bool get isCompleted => step.value == ForgotPasswordStep.completed;

  /// ================= FORM CONTROLLERS =================
  final emailCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  final emailFocus = FocusNode();
  final newPassFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  /// ================= PASSWORD VISIBILITY =================
  final _showNewPassword = false.obs;
  final _showConfirmPassword = false.obs;

  bool get isNewPassHidden => !_showNewPassword.value;
  bool get isConfirmPassHidden => !_showConfirmPassword.value;

  String get newPasswordIcon =>
      _showNewPassword.value ? IconsPath.visibilityOn : IconsPath.visibilityOff;

  String get confirmPasswordIcon => _showConfirmPassword.value
      ? IconsPath.visibilityOn
      : IconsPath.visibilityOff;

  void toggleNewPass() => _showNewPassword.toggle();
  void toggleConfirmPass() => _showConfirmPassword.toggle();

  /// ================= LOADING STATES =================
  final _isSendOtpLoading = false.obs;
  bool get isSendOtpLoading => _isSendOtpLoading.value;

  final _isResetPassLoading = false.obs;
  bool get isResetPassLoading => _isResetPassLoading.value;

  /// ================= ACTIONS =================

  Future<void> onTapSendOtp({required GlobalKey<FormState> formKey}) async {
    final isValid = validateForm(formKey);
    if (!isValid || _isSendOtpLoading.value) return;

    unfocusAll();
    _isSendOtpLoading.value = true;

    final success = await VerifyOtpService().resendOtp(
      email: emailCtrl.text.trim(),
    );

    if (success) {
      final result = await Get.toNamed(
        RoutePaths.verifyOtp,
        arguments: {
          'flow': OtpFlowType.forgotPassword,
          'email': emailCtrl.text.trim(),
        },
      );

      if (result == true) {
        step.value = ForgotPasswordStep.resetPassword;
      }
    }

    _isSendOtpLoading.value = false;
  }

  Future<void> onTapResetPass({required GlobalKey<FormState> formKey}) async {
    final isValid = validateForm(formKey);
    if (!isValid || _isResetPassLoading.value) return;

    unfocusAll();
    _isResetPassLoading.value = true;

    // Call API here
    final success = await ForgotPasswordService().resetPassword(
      email: emailCtrl.text.trim(),

      newPassword: newPassCtrl.text,
      confirmPassword: confirmPassCtrl.text,
    );

    _isResetPassLoading.value = false;

    if (success) {
      clearAllFields();
      // show a pop
      resetPasswordConfirmDialog(onConfirm: onTapContinueToLogin);

      // step.value = ForgotPasswordStep.completed;
    }
  }

  Future<void> onTapContinueToLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await Future.delayed(const Duration(milliseconds: 300));

    Get.offAllNamed(RoutePaths.signin);
  }

  @override
  void onInit() {
    if (kDebugMode) {
      emailCtrl.text = "abc@yopmail.com";
    }
    super.onInit();
  }

  /// ================= HELPERS =================

  void unfocusAll() {
    emailFocus.unfocus();
    newPassFocus.unfocus();
    confirmPassFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void clearAllFields() {
    emailCtrl.clear();
    newPassCtrl.clear();
    confirmPassCtrl.clear();

    _showNewPassword.value = false;
    _showConfirmPassword.value = false;

    step.value = ForgotPasswordStep.enterEmail;

    unfocusAll();
  }

  /// ================= CLEANUP =================

  // @override
  // void onClose() {
  //   FocusManager.instance.primaryFocus?.unfocus();

  //   emailFocus.dispose();
  //   newPassFocus.dispose();
  //   confirmPassFocus.dispose();

  //   emailCtrl.dispose();
  //   newPassCtrl.dispose();
  //   confirmPassCtrl.dispose();

  //   super.onClose();
  // }
  @override
  void onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.onClose();
  }
}
