import 'package:mama_app/core/common_widgets/custom_divider.dart';

import '../../../app/helper_widgets_export.dart';

class OngoingSessionCard extends StatelessWidget {
  const OngoingSessionCard({super.key});

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
          Row(
            children: [
              ContainerBordered(
                contClr: c.error,
                rad: 6,
                hp: 10,
                vp: 4,
                hasBrdr: true,
                brdrClr: c.primary,
                child: Text(
                  Strings.live.toUpperCase(),
                  style: TxtStyle.inter(fs: 10, w: 600, color: c.textOnPrimary),
                ),
              ),
              Gap(itemGap),
              Text(Strings.ongoingExpertSession.capEachWord(), style: TxtStyle.outfitSmTitle),
            ],
          ),

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
            children: [
              Expanded(
                child: ContainerBordered(
                  hasBrdr: true,
                  brdrClr: c.componentBorder,
                  rad: 30,
                  contClr: ctransp,
                  vp: 8,
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
              ),
              Gap(itemGap),
              Expanded(
                child: CusGestureDetector(
                  onTap: () => Get.toNamed(RoutePaths.meetingScreen),
                  child: ContainerBordered(
                    contClr: c.buttonPrimary,
                    rad: 30,
                    vp: 8,
                    child: Text(
                      Strings.joinLive.capEachWord(),
                      textAlign: TextAlign.center,
                      style: TxtStyle.outfitSemiB(fs: 13, w: 600, color: c.textOnPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
