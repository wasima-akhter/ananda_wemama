import 'package:we_mama/features/auth/core/auth_button_templates.dart';
import 'package:we_mama/features/auth/core/auth_form_fields_templates.dart';
import 'package:we_mama/features/auth/forgot_password/controller/forgot_password_controller.dart';

import '../../../../app/helper_widgets_export.dart';

class ForgotPassBeforeVerify extends StatelessWidget {
  final ForgotPasswordController fpc;
  final GlobalKey<FormState> sendVerificationKey;
  const ForgotPassBeforeVerify({
    super.key,
    required this.fpc,
    required this.sendVerificationKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main title
        Text(
          Strings.forgotPassword.capEachWord(),
          style: TxtStyle.dmSerifDisplayRegular(),
        ),
        Gap(20.h),

        // Subtitle
        Text(
          Strings.sendVerificationEmail.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center(),
        ),
        Gap(30.h),
        // SEND OTP SECTION
        Form(
          key: sendVerificationKey,
          child: Column(
            children: [
              AuthFormEmailField(
                emailCtrler: fpc.emailCtrl,
                emailFocus: fpc.emailFocus,
              ),

              Gap(itemGap * 3),
              Obx(
                () => AuthButton(
                  btnText: Strings.sendCode,
                  isLoading: fpc.isSendOtpLoading,
                  onTap: () => fpc.onTapSendOtp(formKey: sendVerificationKey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
