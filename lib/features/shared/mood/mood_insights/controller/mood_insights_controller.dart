import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../../../../core/services/more/notification/notification_service.dart';
import '../../mood_library/controller/mood_library_controller.dart';
import '../model/mood_insights_model.dart';

class MoodInsightsController extends GetxController {
  final MoodType? passedMoodType;
  final MoodReadingItem? passedItem; // ← add

  MoodInsightsController(this.passedMoodType, this.passedItem);
  @override
  void onInit() {
    super.onInit();

    print("passedMoodType in MoodInsight: $passedMoodType");

    //
    loadNotifications();
  }

  final NotificationService _service = NotificationService();

  final notifications = <NotificationsDataModel>[].obs;
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

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
