import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_pass_type_text_form_field.dart';
import '../../../../core/common_widgets/visibility_suffix.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPassAfterVerify extends StatelessWidget {
  final ForgotPasswordController fpc;
  final GlobalKey<FormState> resetPassFormKey;
  const ForgotPassAfterVerify({super.key, required this.fpc, required this.resetPassFormKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Main title
        Text(Strings.createNewPassword.capEachWord(), style: 22.titleMclrCusFSOutfit),
        Gap(itemGap),

        // Subtitle
        Text(
          Strings.addSpecialChar,
          textAlign: TextAlign.center,
          style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.primary),
        ),
        Gap(itemGap * 5),

        // RESET PASSWORD SECTION
        Form(
          key: resetPassFormKey,
          child: Column(
            children: [
              Obx(
                () => CusPassTypeTextFormField(
                  controller: fpc.newPassCtrl,
                  focusNode: fpc.newPassFocus,
                  hintText: Strings.newPassword,
                  obscureText: fpc.isNewPassHidden,
                  prefix: SvgIcon(iconPath: IconsPath.lock).mOnly(left: 15, right: 6),
                  prefixSize: 48.h,
                  suffix: VisibilitySuffix(onTap: fpc.toggleNewPass, icon: fpc.newPasswordIcon),
                  validator: (value) => validatePassword(value),
                  hintW: 600,
                ),
              ),
              Gap(itemGap * 1.5),
              Obx(
                () => CusPassTypeTextFormField(
                  controller: fpc.confirmPassCtrl,
                  focusNode: fpc.confirmPassFocus,
                  hintText: Strings.confirmPassword,
                  obscureText: fpc.isConfirmPassHidden,
                  prefix: SvgIcon(iconPath: IconsPath.lock).mOnly(left: 15, right: 6),
                  prefixSize: 48.h,
                  suffix: VisibilitySuffix(
                    onTap: fpc.toggleConfirmPass,
                    icon: fpc.confirmPasswordIcon,
                  ),
                  validator: (value) =>
                      validateConfirmPass(confirmPass: value, password: fpc.newPassCtrl.text),
                  hintW: 600,
                ),
              ),
              Gap(itemGap * 2),
              CustomBtnWTxt(
                rad: 30,
                isSmall: true,
                btnTxt: Strings.continueTxt,
                isLoading: fpc.isResetPassLoading,
                onTap: () => fpc.onTapResetPass(formKey: resetPassFormKey),
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
