import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/webview/all_autoheight_webview.dart';
import '../../../../../core/components/ui/webview/simple_webview_widget.dart';
import '../../mood_insights/controller/mood_insights_controller.dart';
import '../controller/mood_library_controller.dart';

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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CusGestureDetector(
                  onTap: onTapRead,
                  child: SizedBox(
                    // width: double.infinity,
                    child: ContainerBordered(
                      contClr: c.buttonPrimary,
                      rad: 30,
                      hp: 40,
                      vp: 8,
                      child: Text(
                        Strings.read.cap,
                        style: TxtStyle.inter(
                          fs: 13,
                          w: 600,
                          color: c.textOnPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 10),

      // child: SingleChildScrollView(
      //   key: ValueKey(id),
      //   child: HtmlWidget(
      //     key: ValueKey('$id-html'),
      //     description,
      //     textStyle: TxtStyle.outfitSmNor500.copyWith(
      //       color: c.foregroundSecondary,
      //     ),
      //     onTapUrl: (url) async {
      //       final uri = Uri.tryParse(url);
      //       if (uri != null)
      //         await launchUrl(uri, mode: LaunchMode.externalApplication);
      //       return true;
      //     },
      //   ),
      // ),
      child: SimpleWebViewWidget(
        title: title,
        headerHtml: moodIllustrationHtml(
          MoodLibraryController.to.getMoodImage(
            MoodInsightsController.to.passedMoodType,
          ),
        ),
        htmlContent: description,
        // backgroundColor: c.cardOngoing,
        textColor: c.foregroundSecondary,
      ),

      /*
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(title, style: TxtStyle.outfitLarTitle),
          // Gap(itemGap),
          // Full view with custom background + padding
          Expanded(
            child: SizedBox.expand(
              child: SimpleWebViewWidget(
                title: title,
                htmlContent: description,
                backgroundColor: c.cardOngoing,
                textColor: c.foregroundSecondary,
              ),
            ),
          ),
          // 8.verticalSpace,

          // Row(
          //   children: [
          //     Expanded(
          //       child: SmallNavBtn(
          //         text: Strings.goToExpertCategory.capEachWord(),
          //         onTap: onTapExpertBtn,
          //       ),
          //     ),
          //     Gap(itemGap),
          //     CusGestureDetector(
          //       onTap: onTapBookmark,
          //       child: ContainerBordered(
          //         contClr: c.primary,
          //         rad: 18,
          //         vp: 8,
          //         hp: 12,
          //         child: SvgIconColored(
          //           iconPath: isBookmarked
          //               ? IconsPath.bookmarkFilled
          //               : IconsPath.bookmarkOutlined,
          //           iconColor: white,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
         */
    ).mB(itemGap);
  }
}
