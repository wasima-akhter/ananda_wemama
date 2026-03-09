import 'package:intl/intl.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../features/main_tabs/home/sub_feature/edit_profile/controller/edit_profile_controller.dart';
import '../../helpers/date_helper.dart';

class SetChildrenBottomSheet extends StatelessWidget {
  const SetChildrenBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
        decoration: BoxDecoration(
          color: bgClr,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(itemGap * 3),

            /// Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Gap(30.w),
                Text("Set Children", style: TxtStyle.outfit(fs: 18, w: 600, color: c.primary)),
                CusGestureDetector(
                  onTap: () => Get.back(),
                  child: SvgIcon(iconPath: IconsPath.closeCircle, height: 22),
                ),
              ],
            ),

            Gap(itemGap),

            /// Children list
            Obx(() {
              return Column(
                children: [
                  ...List.generate(controller.children.length, (index) {
                    final child = controller.children[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: c.cardPrimary, borderRadius: 20.brdrRad),
                      child: Row(
                        children: [
                          /// Left section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Children ${index + 1}",
                                  style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary),
                                ),

                                Gap(4),

                                /// DOB
                                Obx(() {
                                  return CusGestureDetector(
                                    onTap: () async {
                                      final picked = await pickDateGeneric();

                                      if (picked != null) {
                                        controller.updateDob(
                                          index,
                                          DateFormat("dd-MM-yyyy").format(picked),
                                        );
                                      }
                                    },
                                    child: Text(
                                      child.dob.value.isEmpty
                                          ? "${Strings.select} ${Strings.dateOfBirth.capEachWord()}"
                                          : child.dob.value,
                                      style: TxtStyle.outfit(
                                        fs: 13,
                                        color: child.dob.value.isEmpty
                                            ? c.textSecondary
                                            : c.textPrimary,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),

                          Gap(10),

                          /// Male
                          Row(
                            children: [
                              Obx(() {
                                return Radio<bool>(
                                  value: true,
                                  groupValue: child.gender.value == "male",
                                  activeColor: c.primary,
                                  onChanged: (_) => controller.updateGender(index, "male"),
                                );
                              }),
                              Text("Male", style: TxtStyle.outfit(fs: 13)),
                            ],
                          ),

                          /// Female
                          Row(
                            children: [
                              Obx(() {
                                return Radio<bool>(
                                  value: true,
                                  groupValue: child.gender.value == "female",
                                  activeColor: c.primary,
                                  onChanged: (_) => controller.updateGender(index, "female"),
                                );
                              }),
                              Text("Female", style: TxtStyle.outfit(fs: 13)),
                            ],
                          ),
                        ],
                      ),
                    ).mB(12);
                  }),
                ],
              );
            }),

            Gap(itemGap * 2),

            /// Add children
            Align(
              alignment: Alignment.centerRight,
              child: CusGestureDetector(
                onTap: controller.addChild,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(color: c.cardPrimary, borderRadius: 30.brdrRad),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgIconColored(
                        iconPath: IconsPath.addPlusCircle,
                        iconColor: c.primary,
                        height: 18,
                      ),
                      Gap(itemGap),
                      Text("Add Children", style: TxtStyle.outfitSemiB(fs: 14, color: c.primary)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
