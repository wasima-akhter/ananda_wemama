import 'package:we_mama/features/auth/core/auth_form_fields_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../core/auth_button_templates.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPassAfterVerify extends StatelessWidget {
  final ForgotPasswordController fpc;
  final GlobalKey<FormState> resetPassFormKey;
  const ForgotPassAfterVerify({
    super.key,
    required this.fpc,
    required this.resetPassFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Main title

        //
        Text(
          Strings.createNewPassword.capEachWord(),
          style: TxtStyle.dmSerifDisplayRegular(),
        ),
        Gap(itemGap),

        // Subtitle
        Text(
          Strings.addSpecialChar.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center(),
        ),
        Gap(itemGap * 5),

        // RESET PASSWORD SECTION
        Form(
          key: resetPassFormKey,
          child: Column(
            children: [
              Obx(
                () => AuthFormPasswordField(
                  passwordCtrler: fpc.newPassCtrl,
                  passwordFocus: fpc.newPassFocus,
                  isPasswordHidden: fpc.isNewPassHidden,
                  togglePasswordVisibility: fpc.toggleNewPass,
                  passwordIcon: fpc.newPasswordIcon,
                  hintText: Strings.newPassword,
                ),
              ),
              Gap(itemGap * 1.5),
              Obx(
                () => AuthFormPasswordField(
                  passwordCtrler: fpc.confirmPassCtrl,
                  passwordFocus: fpc.confirmPassFocus,
                  isPasswordHidden: fpc.isConfirmPassHidden,
                  togglePasswordVisibility: fpc.toggleConfirmPass,
                  passwordIcon: fpc.confirmPasswordIcon,
                  hintText: Strings.confirmPassword,
                ),
              ),
              Gap(itemGap * 2),

              Obx(
                () => AuthButton(
                  isLoading: fpc.isResetPassLoading,
                  onTap: () => fpc.onTapResetPass(formKey: resetPassFormKey),
                ),
              ),

              Gap(itemGap * 1.5),
            ],
          ),
        ),

        // CONTINUE BUTTON AFTER SUCCESS
      ],
    );
  }
}
