import '../../../../../app/helper_widgets_export.dart';
import '../../../bookmark/controller/bookmark_controller.dart';
import '../../mood_library/controller/mood_library_controller.dart';
import '../../mood_library/widgets/mood_library_comp.dart';
import '../controller/mood_insights_controller.dart';

class MoodInsightsScreen extends StatelessWidget {
  const MoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = Get.find<MoodInsightsController>();
    final bc = Get.find<BookmarkController>();
    final mlc = Get.find<MoodLibraryController>(); // 👈 ADD THIS

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.moodInsights,
        onTapBack: mic.handleBack,
      ),
      child: Obx(() {
        if (mic.isLoading.value) {
          return const Center(child: LoadingPrimary());
        }

        final item = mic.item.value;

        // if (item == null) {
        //   return const EmptyWidgetScrollable(title: "No Data Found");

        // }
        if (item == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // reuse your existing empty/sad illustration if you have one
                  Image.asset(
                    ImagesPath.emptyList,
                    fit: BoxFit.contain,
                    height: S.w * 0.2,
                  ),
                  Gap(itemGap * 2),
                  Text(
                    "No insights available\nfor ${mic.passedMoodType.name} mood",
                    textAlign: TextAlign.center,
                    style: TxtStyle.interSemiB(
                      fs: 16,
                      w: 600,
                      color: c.primary,
                    ),
                  ),
                  Gap(itemGap),
                  Text(
                    "New content is added regularly. Check back soon!",
                    textAlign: TextAlign.center,
                    style: TxtStyle.inter(
                      fs: 13,
                      color: c.primary.withOpacity(0.6),
                    ),
                  ),
                  Gap(itemGap * 2),
                  CustomBtnWTxt(
                    isLoading: false,
                    btnTxt: "Browse Mood Library",
                    btnColor: c.primary,
                    txtClr: white,
                    rad: 12,
                    onTap: mic.handleBack, // ✅ back goes to library
                  ),
                ],
              ),
            ),
          );
        }
        final imageUrl = mlc.getMoodImage(mic.passedMoodType); // 👈 HERE

        return Column(
          children: [
            MoodIllustrationCard(imageUrl: imageUrl),

            Gap(itemGap),

            MoodTypeInsightDesItem(
              id: item.id,
              title: item.title,
              description: item.description, // ✅ was bullets
              isBookmarked: bc.isBookmarked(item.id),
              onTapBookmark: () {
                bc.toggleBookmark(
                  BookmarkItem(
                    id: item.id,
                    title: item.title,
                    description:
                        item.description, // ✅ update BookmarkItem too if needed
                    moodType: mic.passedMoodType,
                    imageUrl: mlc.getMoodImage(mic.passedMoodType),
                  ),
                );
              },
              onTapExpertBtn: () => goToMainNavWithTab(4),
            ),
          ],
        ).get10cm;
      }),
    );
  }
}
