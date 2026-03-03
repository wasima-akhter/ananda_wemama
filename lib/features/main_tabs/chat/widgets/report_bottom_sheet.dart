import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/add_photos_card.dart';
import '../../../../core/common_widgets/cus_des_type_text_form_field.dart';
import '../controller/chat_report_controller.dart';

class ReportBottomSheet extends GetView<ChatReportController> {
  const ReportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatReportController>();

    return SafeArea(
      top: false,
      child: Container(
        padding: 12.pv,
        decoration: BoxDecoration(color: bgClr, borderRadius: 30.brdrRad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Title Row
            Row(
              spacing: itemGap,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Strings.reportUser.capEachWord(), style: TxtStyle.outfitLarTitle),
                CusCircleIconButton(
                  radius: 15,
                  onTap: () => Get.back(),
                  child: SvgIconColored(
                    iconColor: c.primary,
                    iconPath: IconsPath.closeCircle,
                    height: 28,
                  ),
                ),
              ],
            ),

            Text(Strings.whyReUReporting, style: TxtStyle.outfitxSmNor).mR(S.w * 0.12),

            Gap(itemGap * 2),

            /// 🔹 Add photo + note
            Row(
              children: [
                AddPhotosCard(onTap: controller.onTapAddPhotoCard),
                Gap(itemGap * 1.2),
                Expanded(
                  child: CusDesTypeTextFormField(
                    minLines: 3,
                    minHeight: 40,
                    maxHeight: 65,
                    rad: 12,
                    style: TxtStyle.outfitSmNor,
                    bgClr: ctransp,
                    isPaddingLess: true,
                    controller: controller.noteCtrl,
                    hintText: Strings.note,
                  ),
                ),
              ],
            ),

            Gap(itemGap * 2.5),

            /// 🔹 Reactive List
            ///
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.reportReasons.length,
                separatorBuilder: (_, __) => Gap(itemGap * 0.9),
                itemBuilder: (context, index) {
                  final item = controller.reportReasons[index];

                  return Obx(() {
                    final isSelected = controller.selectedReason.value == item; // 👈 inside Obx

                    return CusGestureDetector(
                      onTap: () => controller.selectReason(item),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected ? c.primary : c.cardPrimary,
                          borderRadius: 35.brdrRad,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TxtStyle.outfitSemiB(
                                  fs: 14,
                                  color: isSelected ? white : c.textPrimary,
                                ),
                                child: Text(item),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: isSelected
                                  ? SvgIconColored(
                                      key: const ValueKey("tick"),
                                      iconPath: IconsPath.smallTick,
                                      iconColor: white,
                                      height: 18,
                                    )
                                  : const SizedBox.shrink(key: ValueKey("empty")),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            Gap(itemGap * 2.5),
            CustomBtnWTxt(btnTxt: Strings.submit, isLoading: controller.isLoading, isSmall: true),
          ],
        ),
      ),
    );
  }
}
