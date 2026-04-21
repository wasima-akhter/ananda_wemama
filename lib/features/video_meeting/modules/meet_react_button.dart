import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import 'meet_bottom_action.dart';

class ReactButton extends StatelessWidget {
  final int count;
  final Future<void> Function(String emoji) sendReaction; // ← takes emoji
  const ReactButton({super.key, required this.count, required this.sendReaction});

  @override
  Widget build(BuildContext context) {
    final reactionList = [
      (ImagesPath.likeEmoji, 'LIKE'),
      (ImagesPath.heartEmoji, 'HEART'),
      (ImagesPath.careEmoji, 'CARE'),
      (ImagesPath.hahaEmoji, 'HAHA'),
      (ImagesPath.wowEmoji, 'WOW'),
      (ImagesPath.sadEmoji, 'SAD'),
      (ImagesPath.angryEmoji, 'ANGRY'),
    ];

    final overlayHeight = 18.sp + (8.h * 2) + 80.h;

    return CusFlexibleDropdown(
      items: const [],
      offset: Offset(0, -overlayHeight),
      customOverlay: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: c.scaffoldBackground,
          borderRadius: 30.brdrRad,
          boxShadow: boxShadowAllSides,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: reactionList
              .map(
                (item) => GestureDetector(
                  onTap: () => sendReaction(item.$2), // ← pass emoji type
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Image.asset(item.$1, height: 22.h),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      child: BottomAction(
        iconPath: IconsPath.likeHeartFilled,
        text: "React",
        // optionally show count
        // label: count > 0 ? '$count' : null,
      ),
    );
  }
}
