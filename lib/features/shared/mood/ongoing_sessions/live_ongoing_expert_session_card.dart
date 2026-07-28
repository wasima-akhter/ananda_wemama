import 'package:we_mama/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../../core/utils/share_util/share_util.dart';
import '../../../main_tabs/experts/model/expert_session_list_model.dart';
import '../../../video_meeting/controller/arg_model/meeting_ctrl_ag_model.dart';

class NoLiveSessionCard extends StatelessWidget {
  const NoLiveSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: newCardClr,
      rad: 20,
      hp: 16,
      vp: 20,
      child: Column(
        children: [
          Icon(Icons.videocam_off_rounded, color: c.secondary, size: 40),

          Gap(itemGap),

          Text("No Live Session Right Now", style: TxtStyle.urbanistSmTitle600),

          Gap(6),

          Text(
            "Check back later or explore upcoming sessions",
            style: TxtStyle.outfit(fs: 12, color: c.secondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LiveOngoingSessionCard extends StatelessWidget {
  const LiveOngoingSessionCard({
    super.key,
    this.data,
    this.isFromOngoingScreen,
  });

  final Session? data;
  final bool? isFromOngoingScreen;

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return NoLiveSessionCard();
    }
    final doctorName = (data?.expert?.name ?? "Unknown").capEachWord();
    final specialty = (data?.expert?.profession?.title ?? "Specialist")
        .capEachWord();
    final sessionTitle = (data?.title ?? "Session").capEachWord();
    final description = (data?.description ?? "").cap;
    final time = DateHelper().formatUTCtimestamp(data?.time.toString()).time;

    final date = DateHelper().formatUTCtimestamp(data?.date.toString()).date;

    final imgUrl = data?.expert?.image ?? '';
    final channelName = data?.channelName ?? '';

    return SizedBox(
      // width: S.w - 40.w,
      child: ContainerBordered(
        contClr: newCardClr,
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
                    circledNetworkImageBgComponent(
                      imagePath: imgUrl,
                      brdrClr: c.error,
                      radius: 22,
                      isUser: true,
                      name: doctorName,
                    ),
                    Positioned(
                      bottom: -(10.h),
                      left: 2,
                      right: 2,
                      child: ContainerBordered(
                        alignment: Alignment.center,
                        contClr: c.error,
                        rad: 6,
                        hp: 4,
                        vp: 2,
                        child: Text(
                          Strings.live.toUpperCase(),
                          style: TxtStyle.interSemiB(
                            fs: 8,
                            w: 600,
                            color: white,
                          ),
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
                      Text(
                        doctorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TxtStyle.urbanistSmTitle,
                      ),
                      Text(
                        specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TxtStyle.outfitSemiB(
                          fs: 12,
                          w: 500,
                          color: c.strokePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TxtStyle.outfitSemiB(
                        fs: 11,
                        w: 500,
                        color: c.primary,
                      ),
                    ),
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
              style: TxtStyle.outfit(fs: 13, color: c.strokePrimary),
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
                    vp: 7,
                    child: CusGestureDetector(
                      // <-- add this
                      onTap: () => ShareService.shareSession(data!),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIcon(iconPath: IconsPath.share),
                          Gap(itemGap),
                          Text(
                            Strings.share.cap,
                            style: TxtStyle.outfitSmTitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Gap(itemGap),

                Expanded(
                  child: CusGestureDetector(
                    onTap: () {
                      if (channelName.isNotEmpty) {
                        Get.toNamed(
                          RoutePaths.meetingScreen,
                          arguments: MeetingCtrlAgModel(
                            channelname: channelName,
                            sessionTitle: sessionTitle,
                            hostName: doctorName,
                          ),
                        );
                      }
                    },
                    child: ContainerBordered(
                      contClr: c.buttonPrimary,
                      rad: 30,
                      vp: 8,
                      child: Text(
                        Strings.joinLive.capEachWord(),
                        textAlign: TextAlign.center,
                        style: TxtStyle.outfitSemiB(
                          fs: 13,
                          w: 600,
                          color: c.textOnPrimary,
                        ),
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
      width: S.w - 40,
      height: S.h * 0.25,
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
                ShimmerWidget.circular(
                  width: 40.w,
                  height: 40.w,
                  shimmerClr: c.cardReminder,
                ),

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
                    ShimmerWidget.rectangular(
                      width: 30.w,
                      height: 8.h,
                      shimmerClr: c.cardReminder,
                    ),
                  ],
                ),
              ],
            ),

            Gap(itemGap * 1.5),

            ShimmerWidget.rectangular(
              width: 140.w,
              height: 12.h,
              shimmerClr: c.cardReminder,
            ),

            6.verticalSpace,

            ShimmerWidget.rectangular(
              width: double.infinity,
              height: 10.h,
              shimmerClr: c.cardOngoing,
            ),
            6.verticalSpace,
            ShimmerWidget.rectangular(
              width: 200.w,
              height: 10.h,
              shimmerClr: c.cardReminder,
            ),

            Gap(itemGap),

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
