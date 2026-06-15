import '../../../../app/helper_widgets_export.dart';
import '../controller/setup_profile_controller.dart';
import 'setup_select_field_with_error.dart';

class SetupLocationSection extends StatelessWidget {
  final SetupProfileController controller;

  const SetupLocationSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Where do you live?",
          style: TxtStyle.poppinsSemiB(w: 600, ls: 0.64, fs: 14),
        ),

        Gap(6.h),

        Obx(
          () => SetupSelectFieldWithError(
            title: "State",
            value: controller.selectedState.value,
            placeholder: "Select your state".cap,
            errorText: controller.stateError.value,
            onTap: controller.openStateBottomSheet,
          ),
        ),

        Gap(6.h),

        Obx(
          () => SetupSelectFieldWithError(
            title: "City",
            value: controller.selectedCity.value,
            placeholder: "Select your city".cap,
            errorText: controller.cityError.value,
            onTap: controller.openCityBottomSheet,
          ),
        ),
      ],
    );
  }
}
