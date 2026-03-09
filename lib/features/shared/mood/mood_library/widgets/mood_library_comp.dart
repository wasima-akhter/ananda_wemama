import '../../../../../app/helper_widgets_export.dart';

class MoodIllustrationCard extends StatelessWidget {
  final String imageUrl;

  const MoodIllustrationCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return NetworkImageWidget(
      imageUrl: imageUrl,
      width: double.infinity,
      height: S.h * 0.15,
      radius: 20,
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

class MoodTypeInsightDesItem extends StatelessWidget {
  final String id; // ← add
  final String title;
  final List<String> bullets;
  final VoidCallback? onTapExpertBtn;
  final VoidCallback? onTapBookmark;
  final bool isBookmarked; // ← add

  const MoodTypeInsightDesItem({
    super.key,
    required this.id,
    required this.title,
    required this.bullets,
    this.onTapExpertBtn,
    this.onTapBookmark,
    this.isBookmarked = false, // ← default false
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
          Row(
            children: [
              Expanded(
                child: SmallNavBtn(
                  text: Strings.goToExpertCategory.capEachWord(),
                  onTap: onTapExpertBtn,
                ),
              ),
              Gap(itemGap),
              CusGestureDetector(
                onTap: onTapBookmark,
                child: ContainerBordered(
                  contClr: c.primary,
                  rad: 18,
                  vp: 8,
                  hp: 12,
                  child: SvgIconColored(
                    iconPath:
                        isBookmarked // ← swap icon
                        ? IconsPath.bookmarkFilled
                        : IconsPath.bookmarkOutlined,
                    iconColor: white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).mB(itemGap);
  }
}
