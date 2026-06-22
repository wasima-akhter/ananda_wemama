import 'package:mama_app/core/components/ui/helpers/shapes/custom_divider.dart';
import 'package:mama_app/features/auth/core/auth_button_templates.dart';
import 'package:mama_app/features/auth/core/auth_form_fields_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/signin_controller.dart';

class SignInTopSection extends StatelessWidget {
  const SignInTopSection({super.key});

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
            Strings.welcomeBack,
            textAlign: TextAlign.center,
            style: TxtStyle.dmSerifDisplayRegular(fs: 28),
          ),
        ),

        Text(
          Strings.loginWelcomeText,
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiB(
            fs: 12,
            w: 600,
            // h: 1.4,
            // ls: 0.05, // 4% = 0.64px
          ),
        ),
      ],
    );
  }
}

class FormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const FormSection({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final controller = SigninController.to;
    return Column(
      children: [
        Gap(20.h),
        AuthFormEmailField(
          emailCtrler: controller.emailCtrler,
          emailFocus: controller.emailFocus,
        ),
        Gap(itemGap),

        Obx(() {
          return AuthFormPasswordField(
            passwordCtrler: controller.passwordCtrler,
            passwordFocus: controller.passwordFocus,
            isPasswordHidden: controller.isPasswordHidden,
            togglePasswordVisibility: controller.togglePasswordVisibility,
            passwordIcon: controller.passwordIcon,
          );
        }),

        Gap(itemGap * 2),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => AppCheckbox(
                value: controller.rememberMe.value,
                onChanged: (val) => controller.rememberMe.value = val,
                label: 'Remember me',
              ),
            ),

            CusGestureDetector(
              onTap: controller.goToForgotPassword,
              child: Text(
                "${Strings.forgotPassword}?",
                style: TxtStyle.outfitSemiB(color: c.secondary, fs: 11),
              ),
            ),
          ],
        ),
        Gap(itemGap * 2),
        Obx(() {
          return AuthButton(
            isLoading: controller.isLoading,
            btnText: Strings.signIn,
            onTap: () => controller.onTapLogin(formKey),
          );
        }),

        Gap(ScreenSize.isSmallWidth ? itemGap : itemGap * 2),
        const SocialSection(),
        Gap(itemGap * 4),

        //
        CusGestureDetector(
          onTap: () {
            Get.toNamed(RoutePaths.signup);
          },
          child: Row(
            spacing: 6.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.dontHaveAnAccount.capEachWord(),
                style: TxtStyle.poppinsSemiB(
                  w: 600,
                  color: c.secondary,
                  fs: 11,
                ),
              ),
              Text(
                Strings.createAccount.capEachWord(),
                style: TxtStyle.poppinsSemiB(
                  w: 600,
                  color: c.secondary,
                  fs: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// social_section.dart — drop-in replacement
// Requires SigninController to be in scope (Get.find / controller binding)

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = SigninController.to;

    return Obx(
      () => AbsorbPointer(
        // Block all taps while a social login is in flight
        absorbing: ctrl.isSocialLoading,
        child: Opacity(
          opacity: ctrl.isSocialLoading ? 0.6 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── "or" divider ─────────────────────────────────────
              Row(
                spacing: 20.w,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomDivider(
                      clr: c.strokePrimary.withValues(alpha: 0.4),
                    ),
                  ),
                  Text(
                    Strings.or.capEachWord(),
                    style: TxtStyle.poppinsSemiB(w: 600, fs: 13),
                  ),
                  Expanded(
                    child: CustomDivider(
                      clr: c.strokePrimary.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ).mHV(S.w * 0.1, 0),

              Gap(ScreenSize.isSmallWidth ? itemGap : itemGap * 2),

              // ── Google button ────────────────────────────────────
              GestureDetector(
                onTap: ctrl.onTapGoogleLogin,
                child: ContainerBordered(
                  contClr: inputBgClr,
                  hasBrdr: true,
                  brdrClr: newBorderClr,
                  brdrW: 1,
                  vp: 8,
                  alignment: Alignment.center,
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgIcon(
                        height: ScreenSize.isSmallWidth ? 22 : 28,
                        iconPath: IconsPath.google,
                      ),
                      Text(
                        "Continue with Google".capEachWord(),
                        style: TxtStyle.poppinsSemiB(w: 600, fs: 12),
                      ),
                    ],
                  ),
                ),
              ),

              Gap(itemGap),

              // ── Apple button ─────────────────────────────────────
              GestureDetector(
                onTap: ctrl.onTapAppleLogin,
                child: ContainerBordered(
                  contClr: inputBgClr,
                  hasBrdr: true,
                  brdrClr: newBorderClr,
                  brdrW: 1,
                  vp: 8,
                  alignment: Alignment.center,
                  child: Row(
                    spacing: 12.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgIcon(
                        height: ScreenSize.isSmallWidth ? 24 : 30,
                        iconPath: IconsPath.apple,
                      ),
                      Text(
                        "Continue with Apple".capEachWord(),
                        style: TxtStyle.poppinsSemiB(w: 600, fs: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
