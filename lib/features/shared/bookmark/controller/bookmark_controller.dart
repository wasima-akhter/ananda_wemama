import 'package:get/get.dart';

import '../../../../core/services/more/notification/notification_service.dart';
import '../../../../core/utils/extension/string_extension.dart';

class BookmarkModel {
  final String id;
  final String title;
  final List<String> bullets;

  BookmarkModel({required this.id, required this.title, required this.bullets});
}

class BookmarkController extends GetxController {
  final bookmarks = <BookmarkModel>[].obs; // ← start empty, filled by real data

  bool isBookmarked(String id) => bookmarks.any((b) => b.id == id);

  void addBookmark(BookmarkModel item) {
    if (!isBookmarked(item.id)) {
      bookmarks.add(item);
      "Bookmarked!".showToast(); // ← replace with your toast util
    } else {
      bookmarks.removeWhere((b) => b.id == item.id);
      "Removed from bookmarks".showToast();
    }
  }

  final NotificationService _service = NotificationService();

  // final notifications = <NotificationsDataModel>[].obs;

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading_.value = true;

    // final data = await _service.fetchNotifications();
    // notifications.assignAll(data);

    isLoading_.value = false;
  }

  final isupdateIsSeenLoading_ = false.obs;
  bool get isupdateIsSeenLoading => isupdateIsSeenLoading_.value;

  Future<void> updateIsSeen({required String notificationId}) async {
    isupdateIsSeenLoading_.value = true;

    final isSuccess = await _service.updateIsSeen(notificationId: notificationId);

    if (isSuccess) {
      // 🔥 Update local list
    }

    isupdateIsSeenLoading_.value = false;
  }
}
