import '../../../../app/helper_widgets_export.dart';
import '../controller/signin_controller.dart';
import '../widgets/signin_body_widgets.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SigninController>();
    final formKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      bottomWidget: const SocialSection(),
      appBar: CommonAppBarContent(title: '', hasBackNavArrow: false),
      child:
          //  Text("data"),
          _SigninBody(controller: controller, formKey: formKey),
    );
  }
}

class _SigninBody extends StatelessWidget {
  final SigninController controller;
  final GlobalKey<FormState> formKey;

  const _SigninBody({required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderSection(controller: controller),
          FormSection(controller: controller, formKey: formKey),
        ],
      ).getcm,
    );
  }
}
