import 'package:mama_app/core/common_widgets/network_image_widget.dart';
import 'package:mama_app/gen/assets.gen.dart';

import '../../app/helper_widgets_export.dart';
import '../helpers/string_helper.dart';

class MainNavProfileCard extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String? userImageUrl;
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? hasBackNavArrow;

  const MainNavProfileCard({
    super.key,
    required this.username,
    this.suffix,
    this.onTapBack,
    this.hasBackNavArrow,
    this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01; // responsive vertical gap

    return Container(
      color: bgClr,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Profile + Name
          Expanded(
            child: Row(
              children: [
                NetworkImageWidget(imageUrl: userImageUrl, radius: 20.r, isCircle: true),
                Gap(itemGap),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Strings.welcome, style: TxtStyle.inter(fs: 13, w: 600, color: c.primary)),
                    Text(
                      username.capEachWord(),
                      style: title_600_mClr_Outfit,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right: Notification Icon
          CusGestureDetector(
            onTap: () {
              // GNav.pushNamed(RoutePaths.notification);
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: bgClr,
              child: SvgIcon(iconPath: Assets.icons.notification, height: 25.h, width: 25.w),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h); // responsive height
}
