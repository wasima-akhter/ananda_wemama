import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
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
      appBar: CommonAppBarContent(title: Strings.moodInsights),
      child: Obx(() {
        if (mic.isLoading.value) {
          return const Center(child: LoadingPrimary());
        }

        final item = mic.item.value;

        if (item == null) {
          return const EmptyWidgetScrollable(title: "No Data Found");
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
                    description: item.description, // ✅ update BookmarkItem too if needed
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
