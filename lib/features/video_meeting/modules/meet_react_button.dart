import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/cus_flexible_dropdown.dart';
import 'meet_bottom_action.dart';

class ReactButton extends StatelessWidget {
  const ReactButton({super.key});

  @override
  Widget build(BuildContext context) {
    final overlayKey = GlobalKey();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Height = emoji text(18.sp) + vertical padding(8.h * 2) + decoration insets
        final overlayHeight = 18.sp + (8.h * 2) + 80.h;

        final reactionList = [
          ImagesPath.likeEmoji,
          ImagesPath.heartEmoji,
          ImagesPath.careEmoji,
          ImagesPath.hahaEmoji,
          ImagesPath.wowEmoji,
          ImagesPath.sadEmoji,
          ImagesPath.angryEmoji,
        ];

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
                    (emoji) => GestureDetector(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Image.asset(emoji, height: 22.h),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          child: BottomAction(iconPath: IconsPath.likeHeartFilled, text: "React"),
        );
      },
    );
  }
}
