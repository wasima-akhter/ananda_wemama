import '../../../../app/helper_widgets_export.dart';
import '../../../auth/core/auth_button_templates.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../controller/lifestyle_and_interests_controller.dart';
import '../widgets/lifestyle_interest_grid.dart';

class LifestyleAndInterestsScreen extends StatelessWidget {
  const LifestyleAndInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lic = Get.find<LifestyleAndInterestsController>();

    final formKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: AuthButton(
        isLoading: false,
        onTap: lic.onTapContinue,
        //  isLoading: msc.isLoading,
        //  msc.onTapContinue(mumStageFormKey),
      ),
      child: Column(
        children: [
          BrandedHeaderSection(
            titleText: Strings.whatMattersToYou,
            subtitleText: Strings.selectUpTo10,
          ),

          Gap(10.h),
          LifestyleInterestsGrid(),
          Gap(10.h),
        ],
      ).getcm,
    );
  }
}
