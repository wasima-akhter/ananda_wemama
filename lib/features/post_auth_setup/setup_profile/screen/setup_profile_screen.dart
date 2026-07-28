import 'package:we_mama/features/auth/core/auth_button_templates.dart';
import 'package:we_mama/features/auth/core/auth_form_fields_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/error_field/error_field.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../controller/setup_profile_controller.dart';
import '../modules/setup_dob_section.dart';
import '../modules/setup_location_section.dart';

class SetupProfileScreen extends StatelessWidget {
  const SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spc = Get.find<SetupProfileController>();
    final formKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AuthButton(
              isLoading: spc.isLoading,
              onTap: () => spc.onTapContinueSetUp(formKey),
            ),
          ],
        ),
      ),

      child: Form(
        key: formKey,
        child: Column(
          children: [
            BrandedHeaderSection(
              titleText: Strings.aboutYou,
              subtitleText: Strings.getToKnowBetter,
            ),

            Gap(20.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthFormNameField(
                  nameCtrler: spc.nameCtrl,
                  nameFocus: spc.nameFocus,
                  label: "What's your name?",
                  hintColor: c.foregroundSecondary.withValues(alpha: 0.7),
                ),

                Obx(() {
                  if (spc.nameError.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return SetupFieldError(error: spc.nameError.value);
                }),
              ],
            ),
            Gap(10.h),

            SetupDobSection(),

            Gap(16.h),

            SetupLocationSection(),

            Gap(16.h),
          ],
        ),
      ).getcm,
    );
  }
}
