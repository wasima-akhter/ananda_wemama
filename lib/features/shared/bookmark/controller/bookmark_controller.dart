import 'package:get/get.dart';

import '../../../../core/services/more/notification/notification_service.dart';
import '../model/bookmark_model.dart';

class BookmarkController extends GetxController {
  final NotificationService _service = NotificationService();

  final notifications = <NotificationsDataModel>[].obs;
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
      final index = notifications.indexWhere((e) => e.id == notificationId);

      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isSeen: true);
      }
    }

    isupdateIsSeenLoading_.value = false;
  }
}
