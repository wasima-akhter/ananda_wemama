import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../mood/mood_library/widgets/mood_library_comp.dart';
import '../controller/bookmark_controller.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = Get.find<BookmarkController>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.bookmark),

      onRefresh: () async {},
      child: Obx(() {
        if (bc.bookmarks.isEmpty) {
          return Center(child: EmptyWidgetScrollable(title: Strings.noBookmarks));
        }

        return Column(
          children: [
            ...List.generate(bc.bookmarks.length, (index) {
              final item = bc.bookmarks.value[index];

              return Column(
                children: [
                  MoodIllustrationCard(imageUrl: item.imageUrl),

                  Gap(itemGap),

                  MoodTypeInsightDesItem(
                    id: item.id,
                    title: item.title,
                    bullets: item.bullets,
                    isBookmarked: true,
                    onTapBookmark: () => bc.toggleBookmark(item),
                    onTapExpertBtn: () => goToMainNavWithTab(4),
                  ),
                ],
              ).mB(itemGap);
            }),
          ],
        );
      }).getcm,
    );
  }
}
