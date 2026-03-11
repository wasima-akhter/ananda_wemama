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
      child: Obx(() {
        if (bc.bookmarks.isEmpty) {
          return Center(
            child: Text(Strings.noBookmarks, style: TxtStyle.outfit(fs: 14, color: c.secondary)),
          );
        }

        return Column(
          children: bc.bookmarks
              .map(
                (item) => MoodTypeInsightDesItem(
                  id: item.id,
                  title: item.title,
                  bullets: item.bullets,
                  isBookmarked: true, // ← always true on bookmark page
                  onTapBookmark: () => bc.addBookmark(item), // ← tap removes it
                  onTapExpertBtn: () => goToMainNavWithTab(4),
                ).mB(itemGap),
              )
              .toList(),
        );
      }).getcm,
    );
  }
}
