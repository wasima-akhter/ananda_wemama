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
            Text(
              "Set Children",
              style: TxtStyle.outfit(fs: 18, w: 600, color: c.primary),
            ),

            Gap(itemGap * 3),

            /// Children List
            Obx(() {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: controller.childrenDob.length,
                separatorBuilder: (_, __) => Gap(itemGap),
                itemBuilder: (context, index) {
                  final child = controller.childrenDob[index];

                  return Obx(() {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: c.cardPrimary,
                        borderRadius: 35.brdrRad,
                      ),
                      child: Row(
                        children: [
                          /// Label
                          Text(
                            "Children ${index + 1}",
                            style: TxtStyle.outfitSemiB(
                              fs: 14,
                              color: c.textPrimary,
                            ),
                          ),

                          const Spacer(),

                          /// Editable DOB
                          CusGestureDetector(
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
                              child.value.isEmpty
                                  ? "Date Of Birth"
                                  : child.value,
                              style: TxtStyle.outfit(
                                fs: 14,
                                color: child.value.isEmpty
                                    ? c.textSecondary
                                    : c.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
              );
            }),

            Gap(itemGap * 2),

            /// Add Children Button
            Align(
              alignment: Alignment.centerRight,
              child: CusGestureDetector(
                onTap: () {
                  controller.addChild();
                },
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
                        style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
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
    );
  }
}
