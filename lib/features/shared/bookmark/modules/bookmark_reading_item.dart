import '../../../../app/helper_widgets_export.dart';
import '../../mood/mood_library/widgets/mood_library_comp.dart';

class MoodBookMarkReadingItem extends StatelessWidget {
  final String title;
  final List<String> bullets;
  final VoidCallback? onTapRead;

  const MoodBookMarkReadingItem({
    super.key,
    required this.title,
    required this.bullets,
    this.onTapRead,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardOngoing,
      rad: 24,
      hp: 14,
      vp: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TxtStyle.outfitLarTitle),

          Gap(itemGap),

          ...bullets.map(
            (text) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: BulletPoint(text: text.capEachWord()),
            ),
          ),

          16.verticalSpace,

          Center(
            child: SmallNavBtn(text: Strings.read.cap, onTap: onTapRead),
          ),
        ],
      ),
    ).mB(itemGap);
  }
}
