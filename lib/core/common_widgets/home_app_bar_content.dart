import '../../app/helper_widgets_export.dart';

class HomeAppBarContent extends StatelessWidget implements PreferredSizeWidget {
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? hasBackNavArrow;

  const HomeAppBarContent({super.key, this.suffix, this.onTapBack, this.hasBackNavArrow});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgClr,
      // padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      padding: EdgeInsets.only(top: itemGap * 6),

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
                    child: SvgIcon(iconPath: IconsPath.notification, height: 22.h, width: 25.w),
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
                    circledImageBgComponent(radius: 22),

                    Positioned(
                      top: -20,
                      right: -15,
                      child: SvgIcon(iconPath: IconsPath.crown, height: 40),
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
