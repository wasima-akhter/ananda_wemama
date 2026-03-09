import 'package:flutter/gestures.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/signup_controller.dart';
import '../signup_body_widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();
    final formKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: ""),

      bottomWidget: SignupSocialSection(itemGap: itemGap),
      child: SignupBody(controller: controller, formKey: formKey, itemGap: itemGap),
    );
  }
}

class SignupBody extends StatelessWidget {
  final SignupController controller;
  final GlobalKey<FormState> formKey;
  final double itemGap;

  const SignupBody({
    super.key,
    required this.controller,
    required this.formKey,
    required this.itemGap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SignupHeaderSection(itemGap: itemGap),
          SignupFormSection(controller: controller, formKey: formKey, itemGap: itemGap),

          Gap(itemGap * 1.5),

          // ── Terms Checkbox ──
          Obx(
            () => CusGestureDetector(
              onTap: controller.toggleAgreement,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IgnorePointer(
                    child: CustomCheckBox(
                      value: controller.agreedToTerms.value,
                      onChanged: (_) {},
                      borderColor: c.primary,
                      checkColor: c.scaffoldBackground,
                      activeColor: c.primary,
                      size: 20,
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TxtStyle.outfit(fs: 13, w: 400, color: c.primary),
                        children: [
                          TextSpan(text: "${Strings.agreeToTerms} "),
                          TextSpan(
                            text: Strings.learnMore,
                            style: TxtStyle.outfit(fs: 13, w: 600, color: c.secondary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed(RoutePaths.termsAndConditions),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Gap(itemGap * 2),
        ],
      ).getcm,
    );
  }
}
