import '../../../../../app/helper_widgets_export.dart';
import '../../../bookmark/controller/bookmark_controller.dart';
import '../../mood_library/widgets/mood_library_comp.dart';
import '../controller/mood_insights_controller.dart';

class MoodInsightsScreen extends StatelessWidget {
  const MoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = Get.find<MoodInsightsController>();
    final bc = Get.find<BookmarkController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    final item = mic.passedItem; // ← single item
    final currentMood = mic.passedMoodType;
    final itemId = "${currentMood?.name}_${item?.title}";

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async => print("refreshed"),
      appBar: CommonAppBarContent(title: Strings.moodInsights),
      child: Column(
        children: [
          MoodIllustrationCard(imageUrl: Strings.fakeImageUrl),
          Gap(itemGap),

          if (item != null)
            Obx(
              () => MoodTypeInsightDesItem(
                id: item.id, // ← use item.id
                title: item.title,
                bullets: item.bullets,
                isBookmarked: bc.isBookmarked(item.id),
                onTapBookmark: () => bc.addBookmark(item), // ← pass item directly
                onTapExpertBtn: () => goToMainNavWithTab(4),
              ),
            ),
        ],
      ).get10cm,
    );
  }
}
