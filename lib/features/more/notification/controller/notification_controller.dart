import 'package:we_mama/app/service_export.dart';

import '../../../../core/utils/paginator/paginator.dart';
import '../model/notifications_model.dart';
import '../service/notification_service.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  final NotificationService _service = NotificationService();

  late final Paginator<NotificationItemModel> paginator;

  RxList<NotificationItemModel> get notifications => paginator.items;

  RxBool get isLoading_ => paginator.isLoading;
  bool get isLoading => paginator.isLoading.value;

  RxBool get isLoadingMore => paginator.isLoadingMore;

  final isupdateIsSeenLoading_ = false.obs;
  bool get isupdateIsSeenLoading => isupdateIsSeenLoading_.value;

  @override
  void onInit() {
    super.onInit();

    paginator = Paginator<NotificationItemModel>(
      fetchPage: (page, limit) =>
          _service.fetchNotificationsPaged(page: page, limit: limit),
    );
  }

  Future<void> getNotifications() async {
    await paginator.loadInitial();
  }

  Future<void> loadMoreNotifications() async {
    await paginator.loadMore();
  }

  void addNotification(dynamic data) {
    paginator.items.insert(0, NotificationItemModel.fromJson(data));
  }

  Future<void> updateIsSeen({required String notificationId}) async {
    isupdateIsSeenLoading_.value = true;

    try {
      final isSuccess = await _service.updateIsSeen(
        notificationId: notificationId,
      );

      if (isSuccess) {
        final index = notifications.indexWhere((e) => e.id == notificationId);

        if (index != -1) {
          notifications[index] = notifications[index].copyWith(isSeen: true);
        }

        "Notification marked as seen".showToast();
      }
    } catch (e) {
      print("Error updateIsSeen: $e");
    } finally {
      isupdateIsSeenLoading_.value = false;
    }
  }

  @override
  void onClose() {
    paginator.dispose();
    super.onClose();
  }
}
