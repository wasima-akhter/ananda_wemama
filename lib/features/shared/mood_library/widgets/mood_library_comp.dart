import '../../../../app/helper_widgets_export.dart';

class MoodIllustrationCard extends StatelessWidget {
  final String imageUrl;

  const MoodIllustrationCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardPrimary.withOpacity(.6),
      rad: 20,
      mv: 2,
      h: 120.h,
      alignment: Alignment.center,
      child: NetworkImageWidget(imageUrl: imageUrl, height: S.w * 0.3, width: S.w * 0.3),
    );
  }
}

class MoodTypeReadingItem extends StatelessWidget {
  final String title;
  final List<String> bullets;
  final VoidCallback? onTapRead;

  const MoodTypeReadingItem({
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
          Text(
            title + "  siudcn sdiocsdi ciosd cosdnc oisdjcisdji sdcisd cisjd isdj",
            style: TxtStyle.outfitLarTitle,
          ),

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

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Icon(Icons.circle, size: 6.sp, color: c.primary),
        ),
        10.horizontalSpace,
        Expanded(child: Text(text, style: TxtStyle.outfitSmNor)),
      ],
    );
  }
}
