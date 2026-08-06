import '../../../../../app/helper_widgets_export.dart';
import '../../../bookmark/controller/bookmark_controller.dart';
import '../../mood_library/controller/mood_library_controller.dart';
import '../../mood_library/widgets/mood_library_comp.dart';
import '../controller/mood_insights_controller.dart';
import 'mood_insights_bookmark_button.dart';

class MoodInsightsContent extends StatelessWidget {
  const MoodInsightsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = MoodInsightsController.to;
    final mlc = MoodLibraryController.to;

    final item = mic.item.value!;

    return MoodTypeInsightDesItem(
      id: item.id,
      title: item.title,
      description: item.description,
      isBookmarked: BookmarkController.to.isBookmarked(item.id),

      onTapBookmark: () {
        MoodInsightsBookmarkButton.toggle(item);
      },

      onTapExpertBtn: () {
        goToMainNavWithTab(4);
      },
    );
    /*
     Column(
      children: [
        MoodIllustrationCard(imageUrl: mlc.getMoodImage(mic.passedMoodType)),

        Gap(itemGap),

        SizedBox(
          height: S.h * 0.6,
          child: MoodTypeInsightDesItem(
            id: item.id,
            title: item.title,
            description: item.description,
            isBookmarked: BookmarkController.to.isBookmarked(item.id),

            onTapBookmark: () {
              MoodInsightsBookmarkButton.toggle(item);
            },

            onTapExpertBtn: () {
              goToMainNavWithTab(4);
            },
          ),
        ),

        // Gap(S.viewPaddingBottom + 50),
      ],
    ).get10cm;
*/
  }
}
