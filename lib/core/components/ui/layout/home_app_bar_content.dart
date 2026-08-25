import '../../../../app/helper_widgets_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../../features/shared/subscription/subscription_access/premium_gate.dart';
import '../../../services/push_notification/controller/notification_count_controller.dart';

class HomeAppBarContent extends StatelessWidget implements PreferredSizeWidget {
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? hasBackNavArrow;

  const HomeAppBarContent({
    super.key,
    this.suffix,
    this.onTapBack,
    this.hasBackNavArrow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgClrNew,
      padding: EdgeInsets.only(top: itemGap * 5, bottom: itemGap),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //color: Colors.amber,
            child: mamaLogoWithoutTxtImageSmall,
          ),

          Row(
            children: [
              CusGestureDetector(
                onTap: () {
                  NotificationCountController.to.onNotificationScreenOpened();
                  Get.toNamed(RoutePaths.notification);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: c.secondary),
                    color: c.inputBackground,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: c.inputBackground,
                        child: SvgIcon(
                          iconPath: IconsPath.notification,
                          height: 22,
                        ),
                      ),

                      // ✅ NEW — bell badge
                      Obx(() {
                        final count =
                            NotificationCountController.to.newCount.value;
                        if (count == 0) return const SizedBox.shrink();

                        return Positioned(
                          top: -8,
                          right: -6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: count > 9 ? 5.w : 4.w,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16.w,
                              minHeight: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: c.error,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: c.inputBackground,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                count > 99 ? '99+' : '$count',
                                style: TxtStyle.poppinsSemiB(
                                  color: Colors.white,
                                  fs: 8,
                                  w: 600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              Gap(itemGap),

              // Crown
              HomeCrown(),
            ],
          ),
        ],
      ),
    ).getcm;
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}

class HomeCrown extends StatelessWidget {
  const HomeCrown({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final double avatarRadius = 22;
        final double crownSize = (ScreenSize.isSmallWidth ? 40 : 30);

        return CusGestureDetector(
          onTap: () {
            Get.toNamed(RoutePaths.profile);
          },
          child: SizedBox(
            width: avatarRadius * 2,
            height: avatarRadius * 2,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Avatar
                Positioned.fill(
                  child: Obx(() {
                    final image =
                        Get.find<ProfileController>()
                            .userProfileData
                            .value
                            ?.profileImage ??
                        '';

                    return circledNetworkImageBgComponent(
                      radius: avatarRadius,
                      imagePath: image,
                      enablePreview: false,
                      isUser: true,
                    );
                  }),
                ),

                // Crown — premium subscribers only
                // Obx(() {
                //   final isPremium = PremiumAccessService.to.isPremiumUser.value;

                //   if (!isPremium) return const SizedBox.shrink();

                //   return Positioned(
                //     top: -(crownSize * (ScreenSize.isSmallWidth ? 0.45 : 0.6)),
                //     right:
                //         -(crownSize * (ScreenSize.isSmallWidth ? 0.45 : 0.7)),
                //     child: Transform.rotate(
                //       angle: 0.3,
                //       child: SvgIcon(
                //         iconPath: IconsPath.crown,
                //         height: crownSize,
                //       ),
                //     ),
                //   );
                // }),
                PremiumGate(
                  child: Positioned(
                    top: -(crownSize * (ScreenSize.isSmallWidth ? 0.45 : 0.6)),
                    right:
                        -(crownSize * (ScreenSize.isSmallWidth ? 0.45 : 0.7)),
                    child: Transform.rotate(
                      angle: 0.3,
                      child: SvgIcon(
                        iconPath: IconsPath.crown,
                        height: crownSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
