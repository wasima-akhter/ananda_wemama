import '../../../../app/helper_widgets_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../../features/shared/subscription/subscription_access/premium_access_service.dart';
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
      padding: EdgeInsets.only(top: itemGap * 6, bottom: itemGap),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mamaLogoWithoutTxtImageSmall,

          Row(
            children: [
              CusGestureDetector(
                onTap: () {
                  NotificationCountController.to.onNotificationScreenOpened();
                  GNav.pushNamed(RoutePaths.notification);
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
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            decoration: BoxDecoration(
                              color: c.error,
                              shape: count > 9
                                  ? BoxShape.rectangle
                                  : BoxShape.circle,
                              borderRadius: count > 9
                                  ? BorderRadius.circular(8)
                                  : null,
                              border: Border.all(
                                color: c.inputBackground,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              textAlign: TextAlign.center,
                              style: TxtStyle.poppinsSemiB(
                                color: Colors.white,
                                fs: 11,
                                w: 600,
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
              Builder(
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
                          Obx(() {
                            final isPremium =
                                PremiumAccessService.to.isPremiumUser.value;

                            if (!isPremium) return const SizedBox.shrink();

                            return Positioned(
                              top:
                                  -(crownSize *
                                      (ScreenSize.isSmallWidth ? 0.45 : 0.6)),
                              right:
                                  -(crownSize *
                                      (ScreenSize.isSmallWidth ? 0.45 : 0.7)),
                              child: Transform.rotate(
                                angle: 0.3,
                                child: SvgIcon(
                                  iconPath: IconsPath.crown,
                                  height: crownSize,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ).getcm;
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
