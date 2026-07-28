import 'package:we_mama/features/main_nav/controller/main_nav_controller.dart';

import '../../../../app/helper_widgets_export.dart';

enum LiveExitReason {
  voluntary,
  kicked,
  ended,
  connectionLost,
  hostReconnecting,
}

class LiveSessionExitPopup extends StatelessWidget {
  final LiveExitReason reason;
  final VoidCallback? onRejoin; // only used for connectionLost
  final Function(bool cancelLeave)? onTapCancel; // only used for connectionLost
  final VoidCallback?
  onLeaveWhileWaiting; // 👈 NEW, only used for hostReconnecting

  const LiveSessionExitPopup({
    super.key,
    required this.reason,
    this.onRejoin,
    this.onTapCancel,
    this.onLeaveWhileWaiting,
  });

  @override
  Widget build(BuildContext context) {
    final config = _config();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: c.cardPrimary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: config.iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(config.icon, color: config.iconColor, size: 22.sp),
              ),
            ),

            Gap(12.h),

            Text(
              config.title,
              style: TxtStyle.outfitSemiB(fs: 15, w: 600, color: c.primary),
            ),

            Gap(6.h),

            Text(
              config.message,
              style: TxtStyle.urbanist(fs: 13, color: c.primary),
            ),

            Gap(20.h),

            Row(
              children: [
                // Left button
                Expanded(
                  child: CusGestureDetector(
                    onTap: config.leftAction,
                    child: ContainerBordered(
                      hasBrdr: true,
                      rad: 30,
                      vp: 8,
                      child: Text(
                        config.leftLabel,
                        textAlign: TextAlign.center,
                        style: TxtStyle.interSemiB(
                          fs: 13,
                          w: 600,
                          color: c.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                Gap(10.w),

                // Right button
                Expanded(
                  child: CusGestureDetector(
                    onTap: config.rightAction,
                    child: ContainerBordered(
                      rad: 30,
                      contClr: config.iconColor,
                      vp: 8,
                      child: Text(
                        config.rightLabel,
                        textAlign: TextAlign.center,
                        style: TxtStyle.interSemiB(
                          fs: 13,
                          w: 600,
                          color: white,
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

  _PopupConfig _config() {
    switch (reason) {
      case LiveExitReason.voluntary:
        return _PopupConfig(
          icon: Icons.logout_rounded,
          iconBg: grey200,
          iconColor: c.error,
          title: 'Are you sure you want to leave?',
          message: 'Hope you enjoyed it! You can browse more sessions anytime.',
          leftLabel: 'Cancel',
          leftAction: () => onTapCancel?.call(true), // ← true = cancel leave
          rightLabel: 'Leave',
          rightAction: () =>
              onTapCancel?.call(false), // ← false = confirm leave
        );

      case LiveExitReason.kicked:
        return _PopupConfig(
          icon: Icons.block_rounded,
          iconBg: const Color(0xFFFCEBEB),
          iconColor: const Color(0xFFA32D2D),
          title: 'Removed from session',
          message: 'The host has removed you from this live session.',
          leftLabel: 'Back',
          leftAction: () {
            Get.back();
          },
          rightLabel: 'Browse more',
          rightAction: () {
            Get.back();
            Get.offAllNamed(RoutePaths.ongoingSessions);
          },
        );

      case LiveExitReason.ended:
        return _PopupConfig(
          icon: Icons.live_tv_rounded,
          iconBg: const Color(0xFFFAEEDA),
          iconColor: const Color(0xFF854F0B),
          title: 'Live session has ended',
          message: 'The host has ended this session. Thanks for joining!',
          leftLabel: 'Back',
          leftAction: () {
            Get.back();
            Get.offAllNamed(RoutePaths.mainNav);
            MainNavController.to.goToTab(4);
          },
          rightLabel: 'Browse more',
          rightAction: () {
            Get.back();
            Get.offAllNamed(RoutePaths.ongoingSessions);
          },
        );

      case LiveExitReason.connectionLost:
        return _PopupConfig(
          icon: Icons.wifi_off_rounded,
          iconBg: const Color(0xFFFBEAF0),
          iconColor: const Color(0xFF993556),
          title: 'Connection lost',
          message:
              'You were disconnected unexpectedly. Check your connection and try again.',
          leftLabel: 'Rejoin',
          leftAction: () {
            Get.back();
            onRejoin?.call();
          },
          rightLabel: 'Back',
          rightAction: () {
            Get.back();
            Get.offAllNamed(RoutePaths.mainNav);
            MainNavController.to.goToTab(4);
          },
        );
      case LiveExitReason.hostReconnecting:
        return _PopupConfig(
          icon: Icons.sync_rounded,
          iconBg: const Color(0xFFE7EFFE),
          iconColor: c.primary,
          title: 'Host is reconnecting…',
          message:
              "We've lost the host's connection for a moment. Hang tight — the session may resume shortly.",
          leftLabel: 'Leave',

          // leftAction: () {
          //   Get.back();
          //   Get.offAllNamed(RoutePaths.mainNav);
          //   MainNavController.to.goToTab(4);
          // },
          leftAction: () {
            Get.back();
            onLeaveWhileWaiting
                ?.call(); // 👈 CHANGED — actually releases engine now
          },
          rightLabel: 'Wait',
          rightAction: () {
            Get.back();
          },
        );
    }
  }
}

class _PopupConfig {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String message;
  final String leftLabel;
  final String rightLabel;
  final VoidCallback leftAction;
  final VoidCallback rightAction;

  _PopupConfig({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftAction,
    required this.rightAction,
  });
}
