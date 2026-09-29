import 'package:we_mama/core/constants/icon_and_image_paths.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/account_overview/change_password/change_password_service.dart';

class ChangePasswordController extends GetxController {
  /// Text Controllers
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  /// Focus Nodes
  final oldPassFocus = FocusNode();
  final newPassFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  /// Loading State
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  //
  var showOldPassword = false.obs;

  String get oldPasswordIcon =>
      !showOldPassword.value ? IconsPath.visibilityOff : IconsPath.visibilityOn;

  bool get isOldPassHidden => !showOldPassword.value;

  void toggleOldPass() {
    showOldPassword.value = !showOldPassword.value;
  }

  ///

  var showPassword = false.obs;
  var showConPassword = false.obs;

  String get newPasswordIcon =>
      !showPassword.value ? IconsPath.visibilityOff : IconsPath.visibilityOn;
  bool get isNewPassHidden => !showPassword.value;
  String get conPassIcon =>
      !showConPassword.value ? IconsPath.visibilityOff : IconsPath.visibilityOn;
  bool get isConPassHidden => !showConPassword.value;

  void toggleNewPass() {
    showPassword.value = !showPassword.value;
  }

  void toggleConPass() {
    showConPassword.value = !showConPassword.value;
  }

  /// Unfocus all fields
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
    oldPassFocus.unfocus();
    newPassFocus.unfocus();
    confirmPassFocus.unfocus();
  }

  /// Clear all fields + unfocus
  void clearForm() {
    oldPassCtrl.clear();
    newPassCtrl.clear();
    confirmPassCtrl.clear();

    oldPassFocus.unfocus();
    newPassFocus.unfocus();
    confirmPassFocus.unfocus();
  }

  @override
  void onClose() {
    /// Dispose controllers
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();

    /// Dispose focus nodes
    oldPassFocus.dispose();
    newPassFocus.dispose();
    confirmPassFocus.dispose();

    super.onClose();
  }

  Future<void> onTapUpdatePassword({
    required GlobalKey<FormState> formKey,
  }) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;
    print("validated both email and password");
    unfocusAll();
    isLoading_.value = true;

    final success = await ChangePasswordService().changePassword(
      oldPassword: oldPassCtrl.text,
      newPassword: newPassCtrl.text,
      confirmPassword: confirmPassCtrl.text,
    );

    isLoading_.value = false;

    if (success) {
      // Get.toNamedReplace(
      //   RoutePaths.success,
      //   arguments: SuccessViewDataModel(
      //     title: Strings.passwordChangedSuccessfully,
      //     subtitle: Strings.continueLoginAgain,
      //     btnTxt: Strings.continueTxt,
      //   ),
      // );

      clearForm();
    }
  }
}
