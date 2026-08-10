import 'package:we_mama/features/auth/forgot_password/widgets/forgot_pass_after_verify.dart';
import 'package:we_mama/features/auth/forgot_password/widgets/forgot_pass_before_verify.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../core/auth_scaffold.dart';
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
        backgroundColor: bgClrNew,
        appBar: getOnboardAppBar(hasBack: true),
        body: SingleChildScrollView(
          child: Obx(() {
            final beforeVerification = fpc.isEnterEmail;
            final afterVerification = fpc.isResetPassword;

            // final isFinalContinueVisible = fpc.isCompleted;

            return Align(
              // alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  // Back button (left aligned)
                  Align(
                    alignment: Alignment.topLeft,
                    child: CusGestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 2.w,
                        ),
                        child: SvgIconColored(
                          iconPath: IconsPath.arrowBackSmall,
                          height: 14,
                        ),
                      ),
                    ),
                  ),
                  Gap(30.h),
                  if (beforeVerification)
                    ForgotPassBeforeVerify(
                      fpc: fpc,
                      sendVerificationKey: sendVerificationKey,
                    ),

                  if (afterVerification)
                    // Form section
                    ForgotPassAfterVerify(
                      fpc: fpc,
                      resetPassFormKey: resetPassFormKey,
                    ),

                  // if (isFinalContinueVisible)
                  //   // last continue button
                  //   ForgotPassFinalView(
                  //     isLoading: false,
                  //     onTap: fpc.onTapContinueToLogin,
                  //   ),

                  //
                  Gap(60.h),
                ],
              ).getcm,
            );
          }),
        ),
      ),
    );
  }
}
