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
      color: bgClr,
      // padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      padding: EdgeInsets.only(top: itemGap * 6, bottom: itemGap),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left:logo without text
          mamaLogoWithoutTxtImageSmall,

          // Right: Notification Icon
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
                    radius: 20.r,
                    backgroundColor: c.inputBackground,
                    child: SvgIcon(
                      iconPath: IconsPath.notification,
                      height: 22,
                    ),
                  ),
                ),
              ),

              Gap(itemGap),

              ///
              CusGestureDetector(
                onTap: () {
                  GNav.pushNamed(RoutePaths.profile);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() {
                      final image =
                          Get.find<ProfileController>()
                              .userProfileData
                              .value
                              ?.profileImage ??
                          '';

                      return circledNetworkImageBgComponent(
                        radius: 22,
                        imagePath: image,
                        enablePreview: false,
                        isUser: true,
                      );
                    }),

                    Transform.rotate(
                      angle: 0.2, // positive = tilt right
                      child: Transform.translate(
                        offset: const Offset(15, -22),
                        child: SvgIcon(iconPath: IconsPath.crown, height: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).getcm;
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h); // responsive height
}
