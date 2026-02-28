import '../../../app/helper_widgets_export.dart';

class NavbarItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final double width;
  final double height;
  final int currenIndex;

  const NavbarItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.width,
    required this.height,
    required this.currenIndex,
  });

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    double value = count / 1000;
    String formatted = value.toStringAsFixed(1);
    if (formatted.endsWith('.0')) formatted = formatted.substring(0, formatted.length - 2);
    return '${formatted}k';
  }

  @override
  Widget build(BuildContext context) {
    final isNotificationTab_ = currenIndex == 1;
    // if (isSelected) {
    // Selected item with icon + label
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgIconColored(iconPath: iconPath, iconColor: isSelected ? c.primary : c.textPrimary),
        Text(
          label,
          style: TxtStyle.inter(fs: 11, w: 500, color: isSelected ? c.primary : c.textPrimary),
        ),
      ],
    );
    // }
  }
}

    // // Icon-only items (with badge for notifications/emails)
    // final roleId = '1';
    // final isAdmin = roleId.toString() == '1';

    // // Determine if this tab should show a badge
    // // Notification tab (index 1) → always show badge for all users
    // // Email tab (index 2) → only show badge for admin
    // final isNotificationTab = currenIndex == 1;
    // final isEmailTab = isAdmin && currenIndex == 2;
    // final shouldShowBadge = isNotificationTab || isEmailTab;

    // if (!shouldShowBadge) {
    //   // No badge needed (e.g., Settings tab or Email tab for non-admin)
    //   return Container(
    //     width: width + 10,
    //     height: height + 10,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(shape: BoxShape.circle, color: ctransp),
    //     child: SvgIconColored(
    //       iconPath: iconPath,
    //       iconColor: c.primary,
    //       width: width,
    //       height: height,
    //     ),
    //   ).pOnly(right: 15, top: currenIndex == 1 ? 3 : 0);
    // }

    // // Show badge with loading state
    // return Consumer<UnreadCountService>(
    //   builder: (context, ucSer, child) {
    //     return FutureBuilder(
    //       future: ucSer.shouldAutoFetch ? ucSer.fetchUnreadCounts() : null,
    //       builder: (context, asyncSnapshot) {
    //         // Get the appropriate count based on tab type
    //         int count = 0;
    //         if (isNotificationTab) {
    //           count = ucSer.notificationCount ?? 0;
    //         } else if (isEmailTab) {
    //           count = ucSer.emailCount ?? 0;
    //         }

    //         final showBadge = count > 0;
    //         final formattedCount = _formatCount(count);
    //         final isLoading = asyncSnapshot.connectionState == ConnectionState.waiting;

    //         return Stack(
    //           clipBehavior: Clip.none,
    //           children: [
    //             Container(
    //               width: width + 10,
    //               height: height + 10,
    //               alignment: Alignment.center,
    //               decoration: BoxDecoration(shape: BoxShape.circle, color: ctransp),
    //               child: SvgIconColored(
    //                 iconPath: iconPath,
    //                 iconColor: cc.primaryColor,
    //                 width: width,
    //                 height: height,
    //               ),
    //             ).pOnly(right: 15, top: currenIndex == 1 ? 3 : 0),
    //             if (showBadge || isLoading)
    //               Positioned(
    //                 right: 7,
    //                 top: 0,
    //                 child: CountBadge(
    //                   isLoading: isLoading,
    //                   mainCount: count,
    //                   formattedCount: formattedCount,
    //                 ),
    //               ),
    //           ],
    //         );
    //       },
    //     );
//       },
//     );
//   }
// }
