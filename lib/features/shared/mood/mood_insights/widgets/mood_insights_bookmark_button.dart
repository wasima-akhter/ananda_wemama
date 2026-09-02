import '../../../../../app/helper_widgets_export.dart';
import '../../../bookmark/controller/bookmark_controller.dart';
import '../../mood_library/controller/mood_library_controller.dart';
import '../controller/mood_insights_controller.dart';

class MoodInsightsBookmarkButton extends StatelessWidget {
  const MoodInsightsBookmarkButton({super.key});

  static void toggle(dynamic item) {
    final bc = BookmarkController.to;
    final mic = MoodInsightsController.to;
    final mlc = MoodLibraryController.to;

    bc.toggleBookmark(
      BookmarkItem(
        id: item.id,
        title: item.title,
        description: item.description,
        moodType: mic.passedMoodType,
        imageUrl: mlc.getMoodImage(mic.passedMoodType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mic = MoodInsightsController.to;
    final bc = BookmarkController.to;

    return Obx(() {
      final item = mic.item.value!;
      return GestureDetector(
        onTap: () => toggle(item),

        child: ContainerBordered(
          contClr: c.primary,
          rad: 18,
          vp: 8,
          hp: 12,

          child: SvgIconColored(
            iconPath: bc.isBookmarked(item.id)
                ? IconsPath.bookmarkFilled
                : IconsPath.bookmarkOutlined,

            iconColor: white,
          ),
        ),
      );
    });
  }
}
