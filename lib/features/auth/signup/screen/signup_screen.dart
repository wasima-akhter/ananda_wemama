import '../../../../app/helper_widgets_export.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../../core/auth_scaffold.dart';
import '../controller/signup_controller.dart';
import '../signup_body_widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();
    final formKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: getOnboardAppBar(),

      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [OnboardLogoHeaderRow()],
          ),
          Gap(20.h),
          SignupBody(controller: controller, formKey: formKey),
        ],
      ).getcm,
    );
  }
}

class SignupBody extends StatelessWidget {
  final SignupController controller;
  final GlobalKey<FormState> formKey;

  const SignupBody({
    super.key,
    required this.controller,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SignupHeaderSection(), Gap(itemGap * 3),
          SignupFormSection(controller: controller, formKey: formKey),

          Gap(itemGap * 1.5),

          // ── Terms Checkbox ──
          Gap(itemGap * 2),
        ],
      ),
    );
  }
}
