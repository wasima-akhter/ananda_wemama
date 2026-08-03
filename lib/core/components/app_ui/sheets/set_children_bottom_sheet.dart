import 'package:intl/intl.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../features/main_tabs/home/sub_feature/edit_profile/controller/edit_profile_controller.dart';
import '../../../helpers/date_helper.dart';
import '../../ui/inputs/custom_radio.dart';

class SetChildrenBottomSheet extends StatelessWidget {
  const SetChildrenBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditProfileController.to;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: S.h * 0.75,
        ), // ✅ prevents overflow
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

              // title row — unchanged
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gap(30.w),
                  Text(
                    Strings.setChildren,
                    style: TxtStyle.outfit(
                      fs: 18,
                      w: 600,
                      color: c.foregroundSecondary,
                    ),
                  ),
                  CusGestureDetector(
                    onTap: () => Get.back(),
                    child: SvgIcon(iconPath: IconsPath.closeCircle, height: 22),
                  ),
                ],
              ),

              Gap(itemGap),

              // ✅ Flexible + scroll so it grows but doesn't overflow
              Flexible(
                child: Obx(() {
                  if (controller.children.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        Strings.noChildrenAddedYet,
                        style: TxtStyle.outfit(fs: 13, color: c.textSecondary),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.children.length,
                    itemBuilder: (_, index) {
                      final child = controller.children[index];

                      return Stack(
                        clipBehavior: Clip.none,
                        key: ValueKey(child),
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: c.cardPrimary,
                              borderRadius: 20.brdrRad,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Children ${index + 1}",
                                        style: TxtStyle.outfitSemiB(
                                          fs: 14,
                                          color: c.foregroundSecondary,
                                        ),
                                      ),
                                      Gap(4),
                                      Obx(
                                        () => CusGestureDetector(
                                          onTap: () async {
                                            final picked =
                                                await pickDatePickerForChildren(
                                                  child: child,
                                                );
                                            if (picked != null) {
                                              controller.updateChildDob(
                                                index,
                                                DateFormat(
                                                  "dd-MM-yyyy",
                                                ).format(picked),
                                              );
                                            }
                                          },
                                          child: Text(
                                            child.dob.value.isEmpty
                                                ? "${Strings.select} ${Strings.dateOfBirth.capEachWord()}"
                                                : child.dob.value,
                                            style: TxtStyle.outfit(
                                              fs: 12,
                                              color: child.dob.value.isEmpty
                                                  ? c.textSecondary
                                                  : c.foregroundSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(10),

                                Obx(
                                  () => Row(
                                    children: [
                                      CusGestureDetector(
                                        onTap: () => controller
                                            .updateChildGender(index, "male"),
                                        child: Row(
                                          children: [
                                            CustomRadio(
                                              isSelected:
                                                  child.gender.value == "male",
                                            ),
                                            Gap(6),
                                            Text(
                                              "Male",
                                              style: TxtStyle.outfit(fs: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(16.w),

                                      CusGestureDetector(
                                        onTap: () => controller
                                            .updateChildGender(index, "female"),
                                        child: Row(
                                          children: [
                                            CustomRadio(
                                              isSelected:
                                                  child.gender.value ==
                                                  "female",
                                            ),
                                            Gap(6),
                                            Text(
                                              "Female",
                                              style: TxtStyle.outfit(fs: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).mB(12),

                          Positioned(
                            top: -7,
                            right: -7,
                            child: CusGestureDetector(
                              onTap: () => controller.removeChild(index),
                              child: Container(
                                padding: 3.pa,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white, // background circle
                                ),
                                child: SvgIconColored(
                                  iconPath:
                                      IconsPath.minus, // 🔥 your minus icon
                                  height: 14,
                                  iconColor: c.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),

              Gap(itemGap * 2),

              // add button — unchanged
              Align(
                alignment: Alignment.centerRight,
                child: CusGestureDetector(
                  onTap: controller.addChild,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: c.cardPrimary,
                      borderRadius: 30.brdrRad,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIconColored(
                          iconPath: IconsPath.addPlusCircle,
                          iconColor: c.primary,
                          height: 18,
                        ),
                        Gap(itemGap),
                        Text(
                          "Add Children",
                          style: TxtStyle.outfitSemiB(fs: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
