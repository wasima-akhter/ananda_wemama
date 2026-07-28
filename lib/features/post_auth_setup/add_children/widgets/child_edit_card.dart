import 'package:we_mama/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/add_children_controller.dart';
import 'child_details_card.dart';
import 'child_details_header.dart';
import 'child_dob_field.dart';
import 'child_gender_selector.dart';

class ChildEditCard extends GetView<AddChildrenController> {
  const ChildEditCard({super.key, required this.child});

  final ChildInfo child;

  @override
  Widget build(BuildContext context) {
    return ChildDetailsCard(
      child: Column(
        children: [
          ChildDetailsHeader(onDelete: () => controller.deleteChild(child.id)),

          Gap(10.h),

          /// DOB
          Obx(
            () => ChildDobField(
              date: controller.editDob.value == null
                  ? "DD / MM / YYYY"
                  : controller.editDob.value!.formatMMMMdyyyy,
              onTap: controller.pickEditDob,
            ),
          ),

          Gap(10.h),

          /// GENDER
          Obx(
            () => ChildGenderSelector(
              selectedGender: controller.editGender.value?.name ?? "",
              onGenderChanged: (value) {
                controller.editGender.value = ChildGenderAdd.values.byName(
                  value,
                );
              },
            ),
          ),

          Gap(20.h),

          /// ACTIONS
          Row(
            children: [
              Expanded(
                child: AuthButton(
                  isLoading: false,
                  btnText: "Cancel",
                  variant: BtnVariant.outlined,
                  fs: 12,
                  onTap: controller.stopEditing,
                ),
              ),
              Gap(10.w),
              Expanded(
                child: AuthButton(
                  isLoading: false,
                  btnText: "Save",
                  fs: 12,
                  onTap: () => controller.saveEditedChild(child.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
