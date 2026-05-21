import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/helpers/visibility_suffix.dart';
import '../../../../core/components/ui/inputs/cus_pass_type_text_form_field.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/signin_controller.dart';

class HeaderSection extends StatelessWidget {
  final SigninController controller;
  const HeaderSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mamaLogoWithoutTxtImage,
        Gap(itemGap),
        Text(Strings.login, style: 17.titleMclrCusFSURB),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Strings.or.capEachWord(), style: 16.titleMclrCusFSURB),
            Gap(itemGap),
            CusGestureDetector(
              onTap: controller.goToSignup,
              child: Text(
                Strings.createAccount,
                style: 13.norSecclrUnderLoutfit,
              ),
            ),
            Gap(itemGap),
            SvgIcon(iconPath: IconsPath.arrowRightSm, height: 24),
          ],
        ),
        Gap(itemGap * 3),
      ],
    );
  }
}

class FormSection extends StatelessWidget {
  final SigninController controller;
  final GlobalKey<FormState> formKey;

  const FormSection({
    super.key,
    required this.controller,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CusNameTypeTextFormField(
          controller: controller.emailCtrler,
          hintText: Strings.email,
          prefix: SvgIcon(
            iconPath: IconsPath.email,
            height: 22,
          ).mOnly(left: 15, right: 6),
          prefixSize: 45,
          focusNode: controller.emailFocus,
          validator: validateEmail,
        ),
        Gap(itemGap),

        Obx(() {
          return CusPassTypeTextFormField(
            controller: controller.passwordCtrler,
            hintText: Strings.password,
            prefix: SvgIcon(
              iconPath: IconsPath.lock,
              height: 22,
            ).mOnly(left: 15, right: 6),
            prefixSize: 45,
            focusNode: controller.passwordFocus,
            obscureText: controller.isPasswordHidden,
            suffix: VisibilitySuffix(
              onTap: controller.togglePasswordVisibility,
              icon: controller.passwordIcon,
            ),

            validator: validatePassword,
          );
        }),

        Gap(itemGap * 2.5),

        Obx(() {
          return CustomBtnWTxt(
            rad: 30,
            isSmall: true,
            onTap: () => controller.onTapLogin(formKey),
            btnTxt: Strings.login,
            isLoading: controller.isLoading,
          );
        }),

        Gap(itemGap * 1.5),

        CusGestureDetector(
          onTap: controller.goToForgotPassword,
          child: Text(
            "${Strings.forgotPassword}?",
            style: TxtStyle.outfit(color: c.primary),
          ),
        ),
      ],
    );
  }
}

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
