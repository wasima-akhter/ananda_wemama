import '../../../../app/helper_widgets_export.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../../core/auth_scaffold.dart';
import '../widgets/signin_body_widgets.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final formKey = GlobalKey<FormState>(); // stable across rebuilds

  @override
  Widget build(BuildContext context) {
    return AppScreenTemplate(
      enableRefresh: false,
      appBar: getOnboardAppBar(),

      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [OnboardLogoHeaderRow(hasBack: false)],
          ),
          Gap(20.h),

          _SigninBody(formKey: formKey),
        ],
      ).getcm,
    );
  }
}

class _SigninBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _SigninBody({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SignInTopSection(),
          FormSection(formKey: formKey),
        ],
      ),
    );
  }
}
