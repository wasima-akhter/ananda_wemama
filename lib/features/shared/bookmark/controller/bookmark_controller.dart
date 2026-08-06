import 'package:get/get.dart';

import '../../../../core/enums/ui_enums.dart';
import '../../../../core/utils/extension/string_extension.dart';

class BookmarkItem {
  final String id;
  final String title;
  final String description; // ✅ was bullets
  final MoodType moodType;
  final String imageUrl;

  BookmarkItem({
    required this.id,
    required this.title,
    required this.description,
    required this.moodType,
    required this.imageUrl,
  });
}

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find<BookmarkController>();
  final bookmarks = <BookmarkItem>[].obs;

  bool isBookmarked(String id) => bookmarks.any((b) => b.id == id);

  void toggleBookmark(BookmarkItem item) {
    if (isBookmarked(item.id)) {
      bookmarks.removeWhere((b) => b.id == item.id);
      "Removed from bookmarks".showToast();
    } else {
      bookmarks.add(item);
      "Bookmarked!".showToast();
    }
  }
}
