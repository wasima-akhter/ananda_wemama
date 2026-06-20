import '../../../../app/helper_widgets_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';

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
                  GNav.pushNamed(RoutePaths.notification);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: c.secondary),
                    color: c.inputBackground,
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: c.inputBackground,
                    child: SvgIcon(
                      iconPath: IconsPath.notification,
                      height: 22,
                    ),
                  ),
                ),
              ),

              Gap(itemGap),
              Builder(
                builder: (context) {
                  final double avatarRadius = 22;
                  final double crownSize = 35;

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

                          // Crown
                          Positioned(
                            top: -(crownSize * 0.5),
                            right: -(crownSize * 0.5),
                            child: Transform.rotate(
                              angle: 0.3,
                              child: SvgIcon(
                                iconPath: IconsPath.crown,
                                height: crownSize,
                              ),
                            ),
                          ),
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
