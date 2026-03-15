import 'package:mama_app/core/common_widgets/custom_divider.dart';
import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../app/helper_widgets_export.dart';

class UpcomingExpertSessionCard extends StatelessWidget {
  final void Function()? onTapQues;
  final TextEditingController writeQuesCtrl;
  final FocusNode writeQuesFocusNode;
  const UpcomingExpertSessionCard({
    super.key,
    this.onTapQues,
    required this.writeQuesCtrl,
    required this.writeQuesFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardOngoing,
      rad: 20,

      hp: 16,
      vp: 12,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.upcomingExpertSession.capEachWord(), style: TxtStyle.outfitSmTitle),

          Gap(itemGap),

          CustomDivider(isFullWidth: true, h: 0.6),
          Gap(itemGap),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              circledImageBgComponent(),
              Gap(itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(Strings.fakeDrName, style: TxtStyle.urbanistSmTitle),
                    Text(Strings.fakeDrSpecialty, style: TxtStyle.urbanistSmTitleSec),
                  ],
                ),
              ),
              Gap(itemGap),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Strings.fakeTime,
                    style: TxtStyle.outfitSemiB(fs: 12, w: 500, color: c.primary),
                  ),
                  Text(Strings.fakeDate, style: TxtStyle.outfit(fs: 12)),
                ],
              ),
            ],
          ),

          Gap(itemGap),

          Text(Strings.babySleepSession.capEachWord(), style: TxtStyle.urbanistSmTitle600),

          Text(Strings.gentleRoutines.cap, style: TxtStyle.outfit(fs: 13, color: c.secondary)),

          Gap(itemGap),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContainerBordered(
                hasBrdr: true,
                brdrClr: c.primary,
                rad: 30,
                contClr: ctransp,
                hp: 12,
                vp: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(iconPath: IconsPath.share),
                    Gap(itemGap),
                    Text(
                      Strings.share.cap,
                      textAlign: TextAlign.center,
                      style: TxtStyle.outfitSmTitle,
                    ),
                  ],
                ),
              ),
              Gap(itemGap),
              CusGestureDetector(
                onTap: () => Get.toNamed(RoutePaths.meetingScreen),
                child: ContainerBordered(
                  contClr: c.buttonPrimary,
                  rad: 30,
                  vp: 8,
                  hp: 18,
                  child: Row(
                    children: [
                      SvgIcon(iconPath: IconsPath.reminderBellSkew),
                      Gap(itemGap),
                      Text(
                        Strings.remindMe.capEachWord(),
                        textAlign: TextAlign.center,
                        style: TxtStyle.outfitSemiB(fs: 13, w: 600, color: c.textOnPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(itemGap),
              CusGestureDetector(
                onTap: () => showAskYourQuesDialog(
                  onTap: onTapQues,
                  writeQuesCtrl: writeQuesCtrl,
                  writeQuesFocusNode: writeQuesFocusNode,
                ),
                child: ContainerBordered(
                  contClr: c.buttonPrimary,
                  rad: 30,
                  vp: 8,
                  hp: 12,
                  child: SvgIcon(iconPath: IconsPath.chatDotSquare, height: 21),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
