import '../../../../app/helper_widgets_export.dart';
import '../controller/add_children_controller.dart';
import 'child_details_card.dart';
import 'child_details_header.dart';
import 'child_dob_field.dart';
import 'child_gender_selector.dart';

class ChildCreateCard extends StatelessWidget {
  const ChildCreateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddChildrenController.to;

    return ChildDetailsCard(
      child: Column(
        children: [
          ChildDetailsHeader(
            onDelete: null, // always idle
            trailingIcon: AppCompactButton(
              text: Strings.save,
              onTap: controller.saveChild,
            ),
          ),

          Gap(10.h),

          /// DOB
          Obx(
            () => ChildDobField(
              date: controller.createDob.value == null
                  ? "DD / MM / YYYY"
                  : controller.createDob.value!.formatMMMMdyyyy,
              onTap: controller.pickCreateDob,
            ),
          ),

          Gap(12.h),

          /// GENDER
          Obx(
            () => ChildGenderSelector(
              selectedGender: controller.createGender.value?.name ?? "",
              onGenderChanged: (value) {
                controller.createGender.value = ChildGenderAdd.values.byName(
                  value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
