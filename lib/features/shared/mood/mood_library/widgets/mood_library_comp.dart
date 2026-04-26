import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/media/all_autoheight_webview.dart';

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
  final String description;
  final VoidCallback? onTapRead;

  const MoodTypeReadingItem({
    super.key,
    required this.title,
    required this.description,
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
          // ✅ Preview only — 2 lines of plain text
          // Preview card (no WebView spun up at all)
          AllAutoheightWebview(
            htmlContent: description,
            previewOnly: true,
            previewMaxLines: 2,
            padding: EdgeInsets.symmetric(horizontal: 4),
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

class MoodTypeInsightDesItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final VoidCallback? onTapExpertBtn;
  final VoidCallback? onTapBookmark;
  final bool isBookmarked;

  const MoodTypeInsightDesItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    this.onTapExpertBtn,
    this.onTapBookmark,
    this.isBookmarked = false,
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
          // Full view with custom background + padding
          AllAutoheightWebview(
            htmlContent: description,
            backgroundColor: c.cardOngoing,
            padding: EdgeInsets.symmetric(horizontal: 4),
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
                    iconPath: isBookmarked ? IconsPath.bookmarkFilled : IconsPath.bookmarkOutlined,
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
