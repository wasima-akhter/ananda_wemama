import '../../../../app/helper_widgets_export.dart';
import '../controller/signup_controller.dart';
import '../signup_body_widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();
    final formKey = GlobalKey<FormState>();
    final itemGap = 1.sh * 0.01;

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: ""),
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
          const Spacer(),
          SignupSocialSection(itemGap: itemGap),
        ],
      ).getcm,
    );
  }
}
