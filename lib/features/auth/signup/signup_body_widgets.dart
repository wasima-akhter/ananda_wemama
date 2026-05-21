import '../../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/helpers/visibility_suffix.dart';
import '../../../core/components/ui/inputs/cus_pass_type_text_form_field.dart';
import '../../../core/utils/validator/validators.dart';
import 'controller/signup_controller.dart';

class SignupHeaderSection extends StatelessWidget {
  final double itemGap;

  const SignupHeaderSection({super.key, required this.itemGap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mamaLogoWithoutTxtImage,
        Gap(itemGap),

        Text(Strings.signup, style: 17.titleMclrCusFSURB),

        Gap(itemGap * 2),

        ContainerBordered(
          mh: 20,
          rad: 6,
          contClr: c.inputBackground,
          child: Text(
            Strings.joinOurSafeCommunity,
            style: 12.norSecclrCusFSoutfit,
          ),
        ),

        Gap(itemGap * 2),
      ],
    );
  }
}

class SignupFormSection extends StatelessWidget {
  final SignupController controller;
  final GlobalKey<FormState> formKey;
  final double itemGap;

  const SignupFormSection({
    super.key,
    required this.controller,
    required this.formKey,
    required this.itemGap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// EMAIL
        CusNameTypeTextFormField(
          controller: controller.emailCtrl,
          hintText: Strings.enterEmail,
          prefix: SvgIcon(
            iconPath: IconsPath.email,
            height: 22,
          ).mOnly(left: 15, right: 6),
          prefixSize: 45,
          focusNode: controller.emailFocus,
          validator: validateEmail,
        ),
        Gap(itemGap),

        /// PASSWORD
        Obx(() {
          return CusPassTypeTextFormField(
            controller: controller.passCtrl,
            hintText: Strings.enterPassword,
            prefix: SvgIcon(
              iconPath: IconsPath.lock,
              height: 22,
            ).mOnly(left: 15, right: 6),
            prefixSize: 45,
            focusNode: controller.passFocus,
            obscureText: controller.isPassHidden,
            suffix: VisibilitySuffix(
              onTap: controller.togglePass,
              icon: controller.passwordIcon,
            ),
            validator: validatePassword,
          );
        }),

        Gap(itemGap),

        /// CONFIRM PASSWORD
        Obx(() {
          return CusPassTypeTextFormField(
            controller: controller.confirmPassCtrl,
            hintText: Strings.retypePassword,
            prefix: SvgIcon(
              iconPath: IconsPath.lock,
              height: 22,
            ).mOnly(left: 15, right: 6),
            prefixSize: 45,
            focusNode: controller.confirmPassFocus,
            obscureText: controller.isConPassHidden,
            suffix: VisibilitySuffix(
              onTap: controller.toggleConPass,
              icon: controller.conPassIcon,
            ),
            validator: (value) => validateConfirmPass(
              confirmPass: value,
              password: controller.passCtrl.text,
            ),
          );
        }),

        Gap(itemGap * 2.5),

        /// CONTINUE BUTTON
        Obx(() {
          return filledBtnWTxt(
            btnTxt: Strings.continueTxt,
            isLoading: controller.isLoading,
            onTap: () => controller.onTapSignup(formKey),
          );
        }),
      ],
    );
  }
}

class SignupSocialSection extends StatelessWidget {
  final double itemGap;

  const SignupSocialSection({super.key, required this.itemGap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Strings.signUpWith, style: 13.norSecclrCusFSoutfit),
        Row(
          children: [
            Expanded(
              child: ContainerBordered(
                contClr: c.cardPrimary,
                vp: 20,
                child: SvgIcon(height: 35, iconPath: IconsPath.apple),
              ),
            ),
            Gap(itemGap * 1.5),
            Expanded(
              child: ContainerBordered(
                contClr: c.cardPrimary,
                vp: 20,
                child: SvgIcon(height: 35, iconPath: IconsPath.google),
              ),
            ),
          ],
        ).mHV(0, 10),
      ],
    );
  }
}
