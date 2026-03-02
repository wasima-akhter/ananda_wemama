import 'package:mama_app/core/common_widgets/app_screen_template.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/signin_controller.dart';
import '../widgets/signin_body_widgets.dart';
/*
class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sinc = Get.find<SigninController>();

    final signInFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: '', hasBackNavArrow: false),

        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: signInFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo + Title
                        mamaLogoWithoutTxtImage,
                        Gap(itemGap),
                        Text(
                          Strings.login,
                          textAlign: TextAlign.center,
                          style: 17.titleMclrCusFSURB,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Strings.or.capEachWord(), style: 16.titleMclrCusFSURB),
                            Gap(itemGap),
                            CusGestureDetector(
                              onTap: () {
                                GNav.pushNamed(RoutePaths.signup);
                              },
                              child: Text(Strings.createAccount, style: 13.norSecclrUnderLoutfit),
                            ),
                            Gap(itemGap),
                            SvgIcon(iconPath: IconsPath.arrowRightSm, height: 24),
                          ],
                        ),
                        Gap(itemGap * 3),

                        // Email & Password Fields
                        CusNameTypeTextFormField(
                          controller: sinc.emailCtrler,
                          hintText: Strings.email,
                          prefix: SvgIcon(iconPath: IconsPath.email).mOnly(left: 15, right: 6),
                          prefixSize: 45,
                          focusNode: sinc.emailFocus,
                          validator: (value) => validateEmail(value),
                        ),
                        Gap(itemGap),
                        Obx(() {
                          return CusPassTypeTextFormField(
                            controller: sinc.passwordCtrler,
                            hintText: Strings.password,
                            prefix: SvgIcon(iconPath: IconsPath.lock).mOnly(left: 15, right: 6),
                            prefixSize: 48,
                            focusNode: sinc.passFocus,
                            obscureText: sinc.isPassHidden,
                            suffix: VisibilitySuffix(
                              onTap: sinc.toggleEye,
                              icon: sinc.passwordIcon,
                            ),
                            validator: (value) => validatePassword(value),
                          );
                        }),
                        Gap(itemGap * 2.5),
                        Obx(
                          () => filledBtnWTxt(
                            onTap: () async => await sinc.onTapLogin(signInFormKey),
                            btnTxt: Strings.login,
                            isLoading: sinc.isLoading,
                          ),
                        ),
                        Gap(itemGap * 1.5),
                        CusGestureDetector(
                          onTap: () {
                            GNav.pushNamed(RoutePaths.forgotPassword);
                          },
                          child: Text(
                            "${Strings.forgotPassword}?",
                            style: TxtStyle.outfit(color: c.primary),
                          ),
                        ),

                        // 👇 Spacer pushes the bottom buttons down
                        const Spacer(),

                        // Bottom Apple/Google buttons
                        Column(
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
                        ),
                      ],
                    ).getcm,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SigninController>();
    final formKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: '', hasBackNavArrow: false),
      child: _SigninBody(controller: controller, formKey: formKey),
    );
  }
}

class _SigninBody extends StatelessWidget {
  final SigninController controller;
  final GlobalKey<FormState> formKey;

  const _SigninBody({required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderSection(controller: controller),
          FormSection(controller: controller, formKey: formKey),
          const Spacer(),
          const SocialSection(),
        ],
      ).getcm,
    );
  }
}
