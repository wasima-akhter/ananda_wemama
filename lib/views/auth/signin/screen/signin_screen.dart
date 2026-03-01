import 'package:mama_app/core/helpers/image_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_pass_type_text_form_field.dart';
import '../../../../core/common_widgets/visibility_suffix.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/signin_controller.dart';

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
