import 'package:mama_app/core/helpers/image_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_pass_type_text_form_field.dart';
import '../../../../core/common_widgets/visibility_suffix.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final supc = Get.find<SignupController>();

    final signUpFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,

      child: Scaffold(
        appBar: CommonAppBarContent(title: ""),
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,

        body: LayoutBuilder(
          builder: (context, constraints) {
            return BounceSingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        mamaLogoWithoutTxtImage,
                        Gap(itemGap),

                        Text(
                          Strings.signup,
                          textAlign: TextAlign.center,
                          style: 17.titleMclrCusFSURB,
                        ),

                        Gap(itemGap * 2),

                        ContainerBordered(
                          mh: 20,
                          rad: 6,
                          contClr: white,
                          child: Text(Strings.joinOurSafeCommunity, style: 12.norSecclrCusFSoutfit),
                        ),

                        Gap(itemGap * 2),

                        // ===== Your Form Fields =====
                        CusNameTypeTextFormField(
                          controller: supc.emailCtrl,
                          hintText: Strings.enterEmail,
                          prefix: SvgIcon(iconPath: IconsPath.email).mOnly(left: 15, right: 6),
                          prefixSize: 45,

                          focusNode: supc.emailFocus,
                          validator: (value) => validateEmail(value),
                        ),
                        Gap(itemGap),

                        Obx(() {
                          return CusPassTypeTextFormField(
                            controller: supc.passCtrl,
                            hintText: Strings.enterPassword,
                            prefix: SvgIcon(iconPath: IconsPath.lock).mOnly(left: 15, right: 6),
                            prefixSize: 48,
                            focusNode: supc.passFocus,
                            obscureText: supc.isPassHidden,
                            suffix: VisibilitySuffix(
                              onTap: supc.togglePass,
                              icon: supc.passwordIcon,
                            ),
                            validator: (value) => validatePassword(value),
                          );
                        }),
                        Gap(itemGap),

                        Obx(() {
                          return CusPassTypeTextFormField(
                            controller: supc.confirmPassCtrl,
                            hintText: Strings.retypePassword,
                            prefix: SvgIcon(iconPath: IconsPath.lock).mOnly(left: 15, right: 6),
                            prefixSize: 48,
                            focusNode: supc.confirmPassFocus,
                            obscureText: supc.isConPassHidden,
                            suffix: VisibilitySuffix(
                              onTap: supc.toggleConPass,
                              icon: supc.conPassIcon,
                            ),
                            validator: (value) => validateConfirmPass(
                              confirmPass: value,
                              password: supc.passCtrl.text,
                            ),
                          );
                        }),
                        Gap(itemGap * 2.5),

                        Obx(
                          () => filledBtnWTxt(
                            btnTxt: Strings.continueTxt,
                            isLoading: supc.isLoading,
                            onTap: () async => Get.offAllNamed(
                              RoutePaths.verifyOtp,
                              arguments: {
                                'flow': OtpFlowType.signup,
                                'email': supc.emailCtrl.text.trim(),
                              },
                            ),

                            //  await supc.onTapSignup(signUpFormKey),
                          ),
                        ),

                        // 👇 THIS PUSHES BOTTOM SECTION DOWN
                        const Spacer(),

                        // ===== BOTTOM SECTION =====
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
