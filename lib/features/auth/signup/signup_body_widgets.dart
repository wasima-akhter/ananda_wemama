import '../../../../app/helper_widgets_export.dart';
import '../../../core/helpers/string_helper.dart';
import '../core/auth_button_templates.dart';
import '../core/auth_form_fields_templates.dart';
import '../signin/widgets/signin_body_widgets.dart';
import 'controller/signup_controller.dart';

class SignupHeaderSection extends StatelessWidget {
  const SignupHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8.h,
      children: [
        Container(
          // color: Colors.grey,
          child: Text(
            Strings.createYourAccount,
            textAlign: TextAlign.center,
            style: TxtStyle.dmSerifDisplayRegular(
              fs: ScreenSize.isSmallWidth ? 24 : 28,
            ),
          ),
        ),

        Text(
          Strings.joinOurTrustedCommunity,
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiB(
            fs: ScreenSize.isSmallWidth ? 11 : 12,
            w: 600,
            // h: 1.4,
            ls: 0.5, // 4% = 0.64px
          ),
        ),
      ],
    );
  }
}

class SignupFormSection extends StatelessWidget {
  final SignupController controller;
  final GlobalKey<FormState> formKey;

  const SignupFormSection({
    super.key,
    required this.controller,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// EMAIL
        ///
        AuthFormEmailField(
          emailCtrler: controller.emailCtrl,
          emailFocus: controller.emailFocus,
          hintText: Strings.enterEmail,
        ),
        Gap(itemGap),

        /// PASSWORD
        Obx(() {
          return AuthFormPasswordField(
            passwordCtrler: controller.passCtrl,
            passwordFocus: controller.passFocus,
            isPasswordHidden: controller.isPassHidden,
            togglePasswordVisibility: controller.togglePass,
            passwordIcon: controller.passwordIcon,
            hintText: Strings.enterPassword,
          );
        }),

        Gap(itemGap),

        /// CONFIRM PASSWORD
        Obx(() {
          return AuthFormPasswordField(
            passwordCtrler: controller.confirmPassCtrl,
            passwordFocus: controller.confirmPassFocus,
            isPasswordHidden: controller.isConPassHidden,
            togglePasswordVisibility: controller.toggleConPass,
            passwordIcon: controller.conPassIcon,
            hintText: Strings.retypePassword,
          );
        }),

        Gap(itemGap * 2.5),

        /// CONTINUE BUTTON
        Obx(() {
          return AuthButton(
            isLoading: controller.isLoading,
            onTap: () => controller.onTapSignup(formKey),
          );
        }),

        Gap(itemGap * 2),
        SocialSection(
          googleLoading: controller.googleLoading,
          appleLoading: controller.appleLoading,
          onTapApple: controller.onTapAppleSignup,
          onTapGoogle: controller.onTapGoogleSignup,
          type: SocialActivityType.signup,
          authInProgress: false.obs,
        ),
        Gap(itemGap * 3),
        // terms
        Column(
          children: [
            Text(
              'By continuing, you agree to our',
              style: TxtStyle.poppinsSemiB(
                color: c.foregroundSecondary,
                fs: 11,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                linkText(
                  'Terms of Service',
                  onTap: () => Get.toNamed(RoutePaths.termsAndConditions),
                ),
                Text(
                  ' and ',
                  style: TxtStyle.poppinsSemiB(
                    color: c.foregroundSecondary,
                    fs: 11,
                  ),
                ),
                linkText(
                  'Privacy Policy',
                  onTap: () => Get.toNamed(RoutePaths.privacyPolicy),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
