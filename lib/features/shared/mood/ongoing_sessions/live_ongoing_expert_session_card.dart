import 'package:mama_app/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../main_tabs/experts/model/expert_session_list_model.dart';
/*
class LiveOngoingSessionCard extends StatelessWidget {
  const LiveOngoingSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: S.w - 40.w,
      child: ContainerBordered(
        contClr: c.cardOngoing,
        rad: 20,

        hp: 16,
        vp: 16,
        boxShadow: boxShadowBottom(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     ContainerBordered(
            //       contClr: c.error,
            //       rad: 6,
            //       hp: 10,
            //       vp: 4,
            //       hasBrdr: true,
            //       brdrClr: c.primary,
            //       child: Text(
            //         Strings.live.toUpperCase(),
            //         style: TxtStyle.inter(fs: 10, w: 600, color: c.textOnPrimary),
            //       ),
            //     ),
            //     Gap(itemGap),
            //     Text(Strings.ongoingExpertSession.capEachWord(), style: TxtStyle.outfitSmTitle),
            //   ],
            // ),

            // Gap(itemGap),

            // CustomDivider(isFullWidth: true, h: 0.6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    circledImageBgComponent(brdrClr: c.error),

                    Positioned(
                      bottom: -8,
                      left: 4,

                      child: ContainerBordered(
                        contClr: c.error,
                        rad: 6,
                        hp: 6,
                        vp: 2,
                        // hasBrdr: true,
                        // brdrClr: c.primary,
                        child: Text(
                          Strings.live.toUpperCase(),
                          style: TxtStyle.interSemiB(fs: 8, w: 600, color: white),
                        ),
                      ),
                    ),
                  ],
                ),
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Strings.fakeTime,
                      style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: c.primary),
                    ),
                    Text(Strings.fakeDate, style: TxtStyle.outfit(fs: 11)),
                  ],
                ),
              ],
            ),

            Gap(itemGap * 1.5),

            Text(Strings.babySleepSession.capEachWord(), style: TxtStyle.urbanistSmTitle600),

            Text(
              Strings.gentleRoutines.cap +
                  "hdfg duvodf vodhfvhfv dyifv du hv dfvhdfovoidfhod vh dfv",

              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.outfit(fs: 13, color: c.secondary),
            ),

            Gap(itemGap * 1.5),

            Row(
              children: [
                Expanded(
                  child: ContainerBordered(
                    hasBrdr: true,
                    brdrClr: c.primary,
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
      ),
    );
  }
}
*/

class LiveOngoingSessionCard extends StatelessWidget {
  const LiveOngoingSessionCard({super.key, required this.data, this.isFromOngoingScreen});

  final Session data;
  final bool? isFromOngoingScreen;

  @override
  Widget build(BuildContext context) {
    final doctorName = (data.expert?.name ?? "Unknown").capEachWord();
    final specialty = (data.expert?.profession?.title ?? "Specialist").capEachWord();
    final sessionTitle = (data.title ?? "Session").capEachWord();
    final description = (data.description ?? "").cap;
    final time = data.time ?? "--:--";
    final date = DateHelper().formatUTCtimestamp(data.date.toString()).date;

    final imgUrl = data.expert?.image ?? '';
    final channelName = data.channelName ?? '';

    return SizedBox(
      // width: S.w - 40.w,
      child: ContainerBordered(
        contClr: c.cardOngoing,
        rad: 20,
        hp: 16,
        vp: 16,
        boxShadow: boxShadowBottom(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    circledNetworkImageBgComponent(imagePath: imgUrl, brdrClr: c.error),
                    Positioned(
                      bottom: -(10.h),
                      child: ContainerBordered(
                        contClr: c.error,
                        rad: 6,
                        hp: 6,
                        vp: 2,
                        child: Text(
                          Strings.live.toUpperCase(),
                          style: TxtStyle.interSemiB(fs: 8, w: 600, color: white),
                        ),
                      ),
                    ),
                  ],
                ),

                Gap(itemGap),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctorName, style: TxtStyle.urbanistSmTitle),
                      Text(specialty, style: TxtStyle.urbanistSmTitleSec),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(time, style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: c.primary)),
                    Text(date, style: TxtStyle.outfit(fs: 11)),
                  ],
                ),
              ],
            ),

            Gap(itemGap * 1.5),

            /// Title
            Text(
              sessionTitle,
              style: TxtStyle.urbanistSmTitle600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            /// Description
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.outfit(fs: 13, color: c.secondary),
            ),

            /// push the button to the bottom
            isFromOngoingScreen == true ? Gap(itemGap) : const Spacer(),

            /// Buttons (always bottom)
            Row(
              children: [
                Expanded(
                  child: ContainerBordered(
                    hasBrdr: true,
                    brdrClr: c.primary,
                    rad: 30,
                    contClr: ctransp,
                    vp: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgIcon(iconPath: IconsPath.share),
                        Gap(itemGap),
                        Text(Strings.share.cap, style: TxtStyle.outfitSmTitle),
                      ],
                    ),
                  ),
                ),

                Gap(itemGap),

                Expanded(
                  child: CusGestureDetector(
                    onTap: () {
                      if (channelName.isNotEmpty) {
                        Get.toNamed(RoutePaths.meetingScreen, arguments: channelName);
                      }
                    },
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
      ),
    );
  }
}

class LiveOngoingSessionCardShimmer extends StatelessWidget {
  const LiveOngoingSessionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: S.w - 40.w,
      child: ContainerBordered(
        contClr: c.cardOngoing,
        rad: 20,
        hp: 16,
        vp: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              children: [
                ShimmerWidget.circular(width: 40.w, height: 40.w, shimmerClr: c.cardReminder),

                Gap(itemGap),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectangular(
                        width: 100.w,
                        height: 10.h,
                        shimmerClr: c.cardOngoing,
                      ),
                      6.verticalSpace,
                      ShimmerWidget.rectangular(
                        width: 70.w,
                        height: 8.h,
                        shimmerClr: c.cardOngoing,
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    ShimmerWidget.rectangular(
                      width: 40.w,
                      height: 10.h,
                      shimmerClr: c.cardReminder,
                    ),
                    6.verticalSpace,
                    ShimmerWidget.rectangular(width: 30.w, height: 8.h, shimmerClr: c.cardReminder),
                  ],
                ),
              ],
            ),

            Gap(itemGap * 1.5),

            ShimmerWidget.rectangular(width: 140.w, height: 12.h, shimmerClr: c.cardReminder),

            6.verticalSpace,

            ShimmerWidget.rectangular(
              width: double.infinity,
              height: 10.h,
              shimmerClr: c.cardOngoing,
            ),
            6.verticalSpace,
            ShimmerWidget.rectangular(width: 200.w, height: 10.h, shimmerClr: c.cardReminder),

            Spacer(),

            Row(
              children: [
                Expanded(
                  child: ShimmerWidget.rectangular(
                    width: double.infinity,
                    height: 36.h,
                    shimmerClr: c.cardOngoing,
                  ),
                ),
                Gap(itemGap),
                Expanded(
                  child: ShimmerWidget.rectangular(
                    width: double.infinity,
                    height: 36.h,
                    shimmerClr: c.cardOngoing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
