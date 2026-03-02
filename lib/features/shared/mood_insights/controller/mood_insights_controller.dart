import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/services/more/notification/notification_service.dart';
import '../model/mood_insights_model.dart';

class MoodInsightsController extends GetxController {
  final MoodType? passedMoodType;

  MoodInsightsController(this.passedMoodType);

  @override
  void onInit() {
    super.onInit();

    print("passedMoodType in MoodInsight: $passedMoodType");

    //
    loadNotifications();
  }

  final Map<MoodType, String> moodImages = {
    MoodType.calm: Strings.fakeImageUrl,
    MoodType.tired: Strings.fakeImageUrl,
    MoodType.anxious: Strings.fakeImageUrl,
    MoodType.stressed: Strings.fakeImageUrl,
  };

  final Map<MoodType, List<List<String>>> moodReadingItems = {
    MoodType.calm: [
      ["Take a few deep breaths and relax your shoulders."],
      ["Focus on a calming visualization."],
    ],
    MoodType.tired: [
      ["Pause and allow yourself to rest."],
      ["Hydrate and stretch lightly."],
      ["Pause and allow yourself to rest."],
      ["Hydrate and stretch lightly."],
    ],
    MoodType.anxious: [
      ["Pause and notice your thoughts without judgment."],
      ["Take a brief walk or grounding exercise."],
    ],
    MoodType.stressed: [
      ["Identify one thing you can control now."],
      ["Try a short mindfulness exercise."],
    ],
  };

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
