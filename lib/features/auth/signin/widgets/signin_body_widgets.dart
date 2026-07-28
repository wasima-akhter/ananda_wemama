import 'package:we_mama/core/components/ui/helpers/shapes/custom_divider.dart';
import 'package:we_mama/features/auth/core/auth_button_templates.dart';
import 'package:we_mama/features/auth/core/auth_form_fields_templates.dart';

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
              () => IgnorePointer(
                ignoring: controller.isAnyAuthLoading,
                child: AppCheckbox(
                  value: controller.rememberMe.value,
                  onChanged: (val) => controller.rememberMe.value = val,
                  label: 'Remember me',
                ),
              ),
            ),

            Obx(
              () => IgnorePointer(
                ignoring: controller.isAnyAuthLoading,
                child: CusGestureDetector(
                  onTap: controller.goToForgotPassword,
                  child: Text(
                    "${Strings.forgotPassword}?",
                    style: TxtStyle.outfitSemiB(color: c.secondary, fs: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
        Gap(itemGap * 2),
        Obx(() {
          return AbsorbPointer(
            absorbing: controller.isAnyAuthLoading,
            child: AuthButton(
              isLoading: controller.isLoading,
              btnText: Strings.signIn,
              onTap: () => controller.onTapLogin(formKey),
            ),
          );
        }),

        Gap(ScreenSize.isSmallWidth ? itemGap : itemGap * 2),
        SocialSection(
          googleLoading: controller.googleLoading,
          appleLoading: controller.appleLoading,
          onTapApple: controller.onTapAppleLogin,
          onTapGoogle: controller.onTapGoogleLogin,
          type: SocialActivityType.signin,
          authInProgress: controller.authInProgress,
        ),
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

enum SocialActivityType { signin, signup }

class SocialSection extends StatelessWidget {
  final SocialActivityType type;

  final RxBool googleLoading;
  final RxBool appleLoading;

  final VoidCallback onTapGoogle;
  final VoidCallback onTapApple;
  final RxBool authInProgress;
  const SocialSection({
    super.key,
    required this.type,
    required this.googleLoading,
    required this.appleLoading,
    required this.onTapGoogle,
    required this.onTapApple,
    required this.authInProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── "or" divider ─────────────────────────────────────
        Row(
          spacing: 20.w,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomDivider(clr: c.strokePrimary.withValues(alpha: 0.4)),
            ),
            Text(
              Strings.or.capEachWord(),
              style: TxtStyle.poppinsSemiB(w: 600, fs: 13),
            ),
            Expanded(
              child: CustomDivider(clr: c.strokePrimary.withValues(alpha: 0.4)),
            ),
          ],
        ).mHV(S.w * 0.1, 0),

        Gap(ScreenSize.isSmallWidth ? itemGap : itemGap * 2),

        // ── Google button ────────────────────────────────────
        Obx(() {
          final isLoading = googleLoading.value;
          final disabled = authInProgress.value && !googleLoading.value;
          return AbsorbPointer(
            absorbing: disabled,
            child: Opacity(
              opacity: isLoading ? 0.6 : 1.0,
              child: CusGestureDetector(
                onTap: onTapGoogle,
                child: ContainerBordered(
                  contClr: inputBgClr,
                  hasBrdr: true,
                  brdrClr: newBorderClr,
                  brdrW: 1,
                  vp: 8,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        SvgIcon(
                          height: ScreenSize.isSmallWidth ? 22 : 28,
                          iconPath: IconsPath.google,
                        ),

                      SizedBox(width: 10.w),

                      Text(
                        isLoading
                            ? type == SocialActivityType.signup
                                  ? "Signing up..."
                                  : "Signing in..."
                            : "Continue with Google".capEachWord(),
                        style: TxtStyle.poppinsSemiB(w: 600, fs: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        Gap(itemGap),

        // ── Apple button ─────────────────────────────────────
        Obx(() {
          final isLoading = appleLoading.value;
          final disabled = authInProgress.value && !googleLoading.value;
          return AbsorbPointer(
            absorbing: disabled,
            child: Opacity(
              opacity: isLoading ? 0.6 : 1.0,
              child: CusGestureDetector(
                onTap: onTapApple,
                child: ContainerBordered(
                  contClr: inputBgClr,
                  hasBrdr: true,
                  brdrClr: newBorderClr,
                  brdrW: 1,
                  vp: 8,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        SvgIcon(
                          height: ScreenSize.isSmallWidth ? 24 : 30,
                          iconPath: IconsPath.apple,
                        ),

                      SizedBox(width: 12.w),

                      Text(
                        isLoading
                            ? type == SocialActivityType.signup
                                  ? "Signing up..."
                                  : "Signing in..."
                            : "Continue with Apple".capEachWord(),
                        style: TxtStyle.poppinsSemiB(w: 600, fs: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
