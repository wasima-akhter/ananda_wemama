import 'package:we_mama/core/components/ui/loaders/empty_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../../mood/mood_insights/controller/mood_insights_controller.dart';
import '../../mood/mood_library/controller/mood_library_controller.dart';
import '../../mood/mood_library/widgets/mood_library_comp.dart';
import '../controller/bookmark_controller.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = Get.find<BookmarkController>();

    final mlc = MoodLibraryController.to;

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.bookmark),

      onRefresh: () async {},
      child: Obx(() {
        if (bc.bookmarks.isEmpty) {
          return EmptyNoSearchWidgetScrollable(title: Strings.noBookmarks);
        }

        final currentMood = mlc.selectedMood.value;

        return Container(
          child: Column(
            children: [
              ...bc.bookmarks.map((item) {
                return MoodTypeReadingItem(
                  title: item.title,
                  description: item.description,
                  onTapRead: () {
                    if (Get.isRegistered<MoodInsightsController>()) {
                      Get.delete<MoodInsightsController>();
                    }

                    Get.toNamed(
                      RoutePaths.moodInsight,

                      arguments: MoodInsightArgs(
                        moodType: currentMood,
                        itemId: item.id,
                        fromHome: true, // 👈 flag so back goes to moodLibrary
                      ),
                    );
                  },
                ).mB(itemGap);
              }),
            ],
          ),
        );
      }).getcm,
    );
  }
}
