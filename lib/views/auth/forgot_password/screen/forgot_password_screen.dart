import 'package:mama_app/core/helpers/string_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_pass_type_text_form_field.dart';
import '../../../../core/common_widgets/visibility_suffix.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final fpc = Get.find<ForgotPasswordController>();

    final sendOtpKey = GlobalKey<FormState>();
    final resetPassFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.forgotPassword),
        body: Center(
          child: SingleChildScrollView(
            child: Obx(() {
              final showPassSection = fpc.showPassSection.value;
              final showContinueBtn = fpc.showContinueBtn.value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome tetxt
                  Text(
                    (showPassSection == false && showContinueBtn == false)
                        ? Strings.forgotPassword.capEachWord()
                        : Strings.welcomeBackUser.capEachWord(),
                    style: title_600_mClr_Outfit,
                  ),
                  Gap(itemGap),

                  Text(
                    (showPassSection == false && showContinueBtn == false)
                        ? Strings.sendVerificationEmail.capEachWord()
                        : Strings.passwordChangedContinueLogin,
                    style: TxtStyle.inter(w: 500),
                  ),
                  Gap(itemGap * 5),

                  Column(
                    children: [
                      showPassSection == false
                          ? Form(
                              key: sendOtpKey,
                              child: Column(
                                children: [
                                  CusNameTypeTextFormField(
                                    controller: fpc.emailCtrl,
                                    focusNode: fpc.emailFocus,
                                    hintText: Strings.enterEmailAddress,
                                    validator: (value) => validateEmail(value),
                                    hintW: 600,
                                  ),

                                  Gap(itemGap * 3),
                                  CustomBtnWTxt(
                                    btnTxt: Strings.verify,
                                    isLoading: fpc.isSendOtpLoading,
                                    onTap: () => fpc.onTapSendOtp(formKey: sendOtpKey),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),

                      if (showPassSection == true && showContinueBtn == false)
                        Form(
                          key: resetPassFormKey,
                          child: Column(
                            children: [
                              CusPassTypeTextFormField(
                                controller: fpc.newPassCtrl,
                                focusNode: fpc.newPassFocus,
                                hintText: Strings.newPassword,
                                obscureText: fpc.isNewPassHidden,
                                suffix: VisibilitySuffix(
                                  onTap: fpc.toggleNewPass,
                                  icon: fpc.newPasswordIcon,
                                ),
                                validator: (value) => validatePassword(value),

                                hintW: 600,
                              ),
                              Gap(itemGap * 1.5),

                              CusPassTypeTextFormField(
                                controller: fpc.confirmPassCtrl,
                                focusNode: fpc.confirmPassFocus,
                                hintText: Strings.confirmPassword,

                                obscureText: fpc.isConPassHidden,
                                suffix: VisibilitySuffix(
                                  onTap: fpc.toggleConPass,
                                  icon: fpc.conPassIcon,
                                ),
                                validator: (value) => validateConfirmPass(
                                  confirmPass: value,
                                  password: fpc.newPassCtrl.text,
                                ),
                                hintW: 600,
                              ),
                              Gap(itemGap * 2),
                              CustomBtnWTxt(
                                btnTxt: Strings.resetPassword,
                                isLoading: fpc.isResetPassLoading,
                                onTap: () => fpc.onTapResetPass(formKey: resetPassFormKey),
                              ),
                              Gap(itemGap * 1.5),
                            ],
                          ),
                        ),
                      if (showContinueBtn == true)
                        Column(
                          children: [
                            CustomBtnWTxt(
                              btnTxt: Strings.continueTxt,
                              isLoading: false,
                              onTap: () {
                                GNav.pushNamedReplace(RoutePaths.signin);
                              },
                            ),
                            Gap(itemGap * 1.5),
                          ],
                        ),
                    ],
                  ),
                ],
              ).getcm;
            }),
          ),
        ),
      ),
    );
  }
}
