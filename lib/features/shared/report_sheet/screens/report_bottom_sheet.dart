import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/app_ui/cards/add_photos_card.dart';
import '../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../controller/report_controller.dart';
import '../modules/report_reason_tile.dart';

class ReportBottomSheet extends GetView<ReportController> {
  const ReportBottomSheet({super.key});

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

            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.reportReasons.length,
                separatorBuilder: (_, __) => Gap(itemGap * 0.9),
                itemBuilder: (_, index) =>
                    ReasonTile(reason: controller.reportReasons[index], controller: controller),
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
