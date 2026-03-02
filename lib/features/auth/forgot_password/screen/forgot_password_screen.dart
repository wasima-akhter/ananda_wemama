import 'package:mama_app/features/auth/forgot_password/widgets/forgot_pass_after_verify.dart';
import 'package:mama_app/features/auth/forgot_password/widgets/forgot_pass_before_verify.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fpc = Get.find<ForgotPasswordController>();

    final sendVerificationKey = GlobalKey<FormState>();
    final resetPassFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: ''),
        body: Center(
          child: SingleChildScrollView(
            child: Obx(() {
              final beforeVerification = fpc.isEnterEmail;
              final afterVerification = fpc.isResetPassword;

              final isFinalContinueVisible = fpc.isCompleted;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  if (beforeVerification)
                    ForgotPassBeforeVerify(fpc: fpc, sendVerificationKey: sendVerificationKey),

                  if (afterVerification)
                    // Form section
                    ForgotPassAfterVerify(fpc: fpc, resetPassFormKey: resetPassFormKey),

                  if (isFinalContinueVisible)
                    // last continue button
                    buildFinalSection(
                      isLoading: false,
                      onTapContinueToLogin: fpc.onTapContinueToLogin,
                    ),
                ],
              ).getcm;
            }),
          ),
        ),
      ),
    );
  }

  Column buildFinalSection({void Function()? onTapContinueToLogin, required bool isLoading}) {
    return Column(
      children: [
        // Main title
        Text(Strings.gladToSeeUAgain.capEachWord(), style: 22.titleMclrCusFSOutfit),
        Gap(itemGap),

        // Subtitle
        Text(
          Strings.passwordChangedContinueLogin,
          textAlign: TextAlign.center,
          style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.primary),
        ),
        Gap(itemGap * 3),
        CustomBtnWTxt(
          rad: 30,
          isSmall: true,
          btnTxt: Strings.continueTxt,
          isLoading: isLoading,
          onTap: onTapContinueToLogin,
        ),
        Gap(itemGap * 1.5),
      ],
    );
  }
}
