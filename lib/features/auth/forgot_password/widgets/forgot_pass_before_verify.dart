import 'package:mama_app/features/auth/forgot_password/controller/forgot_password_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/utils/validator/validators.dart';

class ForgotPassBeforeVerify extends StatelessWidget {
  final ForgotPasswordController fpc;
  final GlobalKey<FormState> sendVerificationKey;
  const ForgotPassBeforeVerify({super.key, required this.fpc, required this.sendVerificationKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main title
        Text(Strings.forgotPassword.capEachWord(), style: 22.titleMclrCusFSOutfit),
        Gap(itemGap),

        // Subtitle
        Text(
          Strings.sendVerificationEmail.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.primary),
        ),
        Gap(itemGap * 5),
        // SEND OTP SECTION
        Form(
          key: sendVerificationKey,
          child: Column(
            children: [
              CusNameTypeTextFormField(
                controller: fpc.emailCtrl,
                focusNode: fpc.emailFocus,
                hintText: Strings.email,
                prefix: SvgIcon(iconPath: IconsPath.email).mOnly(left: 15, right: 6),
                prefixSize: 45.h,
                validator: (value) => validateEmail(value),
                hintW: 600,
              ),
              Gap(itemGap * 3),
              Obx(
                () => CustomBtnWTxt(
                  rad: 30,
                  btnTxt: Strings.sendVerification,
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
