import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/date_helper.dart';
import '../controller/setup_profile_controller.dart';
import 'setup_select_field_with_error.dart';

class SetupDobSection extends StatelessWidget {
  const SetupDobSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SetupProfileController.to;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SetupSelectFieldWithError(
            title: "When is your date of birth?",
            value: controller.selectedDob.value,
            placeholder: Strings.dateOfBirth.cap,
            errorText: controller.dobError.value,
            showArrow: false,
            onTap: () => pickDateWithOptions(
              selectedDate: controller.selectedDob,
              keepPrivate: controller.keepDobPrivate,
              unfocusAll: controller.unfocusAll,
              showKeepPrivate: false,
            ),
          ),
        ),

        Gap(10.h),

        Obx(
          () => AppCheckbox(
            label: "Keep my date of birth private",
            activeColor: c.foregroundPrimary,
            checkColor: c.foregroundPrimary,
            borderColor: c.foregroundPrimary,
            labelStyle: TxtStyle.poppinsSemiB(w: 600, ls: 0.64, fs: 13),
            size: ScreenSize.isSmallWidth ? 17 : 20,
            value: controller.keepDobPrivate.value,
            onChanged: (_) => controller.toggleKeepDobPrivate(),
          ),
        ),
      ],
    );
  }
}
