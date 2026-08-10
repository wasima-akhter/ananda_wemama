import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/app_ui/cards/add_photos_card.dart';
import '../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../controller/report_controller.dart';
import '../modules/report_reason_tile.dart';

class ReportBottomSheet extends GetView<ReportController> {
  final bool isUserReport;
  final String? userId;
  final String? postId;
  const ReportBottomSheet({
    super.key,
    required this.isUserReport,
    this.userId,
    this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: 12.pv,
        decoration: BoxDecoration(color: bgClr, borderRadius: 30.brdrRad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: itemGap,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (isUserReport ? Strings.reportUser : "Report Content")
                      .capEachWord(),
                  style: TxtStyle.outfitLarTitle,
                ),
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

            Text(
              Strings.whyReUReporting,
              style: TxtStyle.outfitxSmNor,
            ).mR(ScreenSizeX.isTablet ? 0 : S.w * 0.12),

            Gap(itemGap * 2),

            Row(
              children: [
                Obx(
                  () => AddPhotoCard(
                    onTap: controller.onTapAddPhotoCard,
                    imageFile: controller.pickedImageOrFile.value,

                    onRemove: () => controller.pickedImageOrFile.value = null,
                  ),
                ),
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

            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.reportReasons.length,
                separatorBuilder: (_, _) => Gap(itemGap * 0.9),
                itemBuilder: (_, index) => ReasonTile(
                  reason: controller.reportReasons[index],
                  controller: controller,
                ),
              ),
            ),

            Gap(itemGap * 2.5),

            Obx(
              () => CustomBtnWTxt(
                btnTxt: Strings.submit,
                btnColor: c.primary,
                onTap: () => controller.report(
                  isUserReport: isUserReport,
                  postId: postId,
                  userId: userId,
                ),
                isLoading: controller.isLoading,
                isSmall: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
