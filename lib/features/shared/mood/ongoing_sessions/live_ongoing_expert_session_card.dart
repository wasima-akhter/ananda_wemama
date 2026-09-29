import 'dart:async';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../../core/helpers/session_time_helper.dart';
import '../../../../core/services/deep_link/session_navigator.dart';
import '../../../../core/utils/share_util/share_util.dart';
import '../../../main_tabs/experts/model/expert_session_list_model.dart';

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

class LiveOngoingSessionCard extends StatefulWidget {
  const LiveOngoingSessionCard({
    super.key,
    this.data,
    this.isFromOngoingScreen,
  });

  final Session? data;
  final bool? isFromOngoingScreen;

  @override
  State<LiveOngoingSessionCard> createState() => _LiveOngoingSessionCardState();
}

class _LiveOngoingSessionCardState extends State<LiveOngoingSessionCard> {
  Timer? joinTimer;
  Timer? fallbackTimer;
  @override
  void initState() {
    super.initState();
    _scheduleJoinCheck();
  }

  @override
  void didUpdateWidget(covariant LiveOngoingSessionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data?.dateTime != widget.data?.dateTime) {
      _scheduleJoinCheck();
    }
  }

  @override
  void dispose() {
    joinTimer?.cancel();
    fallbackTimer?.cancel(); // 🔴 NEW: Clean up fallback
    super.dispose();
  }

  void _scheduleJoinCheck() {
    joinTimer?.cancel();
    fallbackTimer?.cancel(); // 🔴 NEW: Cancel previous fallback

    final sessionDateTime = widget.data?.dateTime;

    if (sessionDateTime == null) {
      print('🔴 [JOIN TIMER] Session dateTime is NULL');
      return;
    }

    final joinTimeUtc = sessionDateTime.toUtc();
    final nowUtc = DateTime.now().toUtc();

    // Already joinable.
    if (!nowUtc.isBefore(joinTimeUtc)) {
      print('🟢 [JOIN TIMER] Session is already joinable');
      return;
    }

    final duration = joinTimeUtc.difference(nowUtc);

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('⏰ [JOIN TIMER]');
    print('📅 Session UTC : $joinTimeUtc');
    print('📱 Current UTC : $nowUtc');
    print('⏳ Enable in   : $duration');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    joinTimer = Timer(duration, () {
      if (!mounted) return;

      print('🟢 [JOIN TIMER] Session is now joinable');

      setState(() {});
    }); // 🔴 NEW: Fallback timeout (5 seconds max to show "Join" button)
    // This handles edge cases where the main timer might be delayed
    fallbackTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      print('⚠️ [FALLBACK TIMER] Forcing join button visibility after 5s');

      setState(() {
        // Force rebuild to ensure button is visible
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return const NoLiveSessionCard();
    }

    final doctorName = (widget.data?.expert?.name ?? "Unknown").capEachWord();

    final specialty = (widget.data?.expert?.profession?.title ?? "Specialist")
        .capEachWord();

    final sessionTitle = (widget.data?.title ?? "Session").capEachWord();

    final description = (widget.data?.description ?? "").cap;

    final imgUrl = widget.data?.expert?.image ?? '';
    final channelName = widget.data?.channelName ?? '';

    final hostTimeZone = widget.data?.timezone ?? '';

    final time = SessionTimeHelper.time(
      dateTime: widget.data?.dateTime?.toIso8601String(),
      hostTimezone: hostTimeZone,
    );

    final date = SessionTimeHelper.date(
      dateTime: widget.data?.dateTime?.toIso8601String(),
      hostTimezone: hostTimeZone,
    );

    final canJoinLive = _canJoinLive();

    return SizedBox(
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
                        style: TxtStyle.urbanistSemiB(
                          fs: 17,
                          w: 600,
                          color: c.foregroundSecondary,
                        ),
                      ),
                      Text(
                        specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TxtStyle.outfitSemiB(
                          fs: 13,
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

            Gap(12.h),

            /// Session title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    color: c.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sessionTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TxtStyle.outfitSemiB(
                      fs: 16,
                      w: 600,
                      color: c.foregroundPrimary,
                    ),
                  ),
                ),
              ],
            ),

            /// Description
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.outfit(fs: 14, color: c.strokePrimary),
            ),

            /// Push buttons to bottom
            widget.isFromOngoingScreen == true ? Gap(itemGap) : const Spacer(),

            /// Buttons
            Row(
              children: [
                /// Share
                Expanded(
                  child: CusGestureDetector(
                    onTap: () => ShareService.shareSession(widget.data!),
                    child: ContainerBordered(
                      hasBrdr: true,
                      brdrClr: c.primary,
                      rad: 30,
                      contClr: ctransp,
                      vp: 0,
                      h: actionBtnHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIcon(iconPath: IconsPath.share, height: 21),
                          Gap(itemGap),
                          Text(
                            Strings.share.cap,
                            style: TxtStyle.outfitSemiB(
                              fs: 13,
                              w: 600,
                              color: c.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Gap(itemGap),

                /// Join Live
                /// Join Live
                Expanded(
                  child: CusGestureDetector(
                    onTap: () async {
                      if (channelName.isEmpty) {
                        print('🔴 [JOIN LIVE] Channel name is empty');
                        return;
                      }

                      // ✅ Show loading while checking
                      Get.dialog(
                        const Center(child: LoadingPrimary()),
                        barrierDismissible: false,
                      );

                      try {
                        await SessionNavigator.openMeeting(
                          channelName: channelName,
                          sessionTitle: sessionTitle,
                          hostName: doctorName,
                        );
                      } catch (e) {
                        // ✅ Make sure dialog is closed on error
                        if (Get.isDialogOpen ?? false) {
                          Get.back();
                        }
                        print('🔴 Error joining: $e');
                      }
                    },
                    child: ContainerBordered(
                      contClr: canJoinLive
                          ? c.buttonPrimary
                          : c.buttonPrimary.withValues(alpha: 0.6),
                      rad: 30,
                      vp: 0,
                      h: actionBtnHeight,
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
                // End of Join Live button
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _canJoinLive() {
    final sessionDateTime = widget.data?.dateTime;
    final hostTimeZone = widget.data?.timezone;

    if (sessionDateTime == null) {
      print('🔴 [JOIN CHECK] Session dateTime is NULL');
      return false;
    }

    if (hostTimeZone == null || hostTimeZone.isEmpty) {
      print('🔴 [JOIN CHECK] Host timezone is NULL/EMPTY');
      return false;
    }

    final sessionUtc = sessionDateTime.toUtc();
    final nowUtc = DateTime.now().toUtc();

    final canJoin = !nowUtc.isBefore(sessionUtc);

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🕐 [JOIN CHECK]');
    print('📅 Session UTC : $sessionUtc');
    print('📱 Current UTC : $nowUtc');
    print('🌍 Host TZ     : $hostTimeZone');
    print('⏱️ Difference  : ${sessionUtc.difference(nowUtc)}');
    print('⏳ Can join?   : $canJoin');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return canJoin;
  }

  void _showJoinUnavailableMessage(BuildContext context) {
    Snack.showWarning(
      title: "Can't Join Now",
      "You can join this live session at the scheduled start time. "
      "The host may join up to 5 minutes earlier to prepare the session.",
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
