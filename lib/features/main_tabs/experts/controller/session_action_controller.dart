import '../../../../app/controller_export.dart';
import '../model/expert_session_list_model.dart';
import '../services/experts_service.dart';

class SessionActionController extends GetxController {
  // final writeQuesCtrl = TextEditingController();
  // final writeQuesFocusNode = FocusNode();

  RxBool isSendQuesLoading = false.obs;

  Future<bool> uploadSessionQues({
    required String expertId,
    required String sessionId,
    required String question,
  }) async {
    // ✅ PREMIUM CHECK BEFORE ALLOWING ACTION
    // final premium = PremiumAccessService.to;

    // if (!premium.isReady.value) {
    //   print('⏳ Premium service not ready');
    //   Snack.showWarning('Checking subscription status...');
    //   return false;
    // }

    // if (!premium.isPremiumUserNow) {
    //   print('🔒 User not premium — blocking question');
    //   Get.toNamed(RoutePaths.subscriptionUpgrade);
    //   return false;
    // }

    // ✅ User is premium — proceed with question
    if (isSendQuesLoading.value) return false;

    isSendQuesLoading.value = true;

    try {
      final response = await ExpertsService().uploadUpcomingSessionQues(
        expertId: expertId,
        question: question,
        sessionId: sessionId,
      );

      if (response == true) {
        // writeQuesCtrl.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        return true;
      }

      return false;
    } finally {
      isSendQuesLoading.value = false;
    }
  }

  final service = ExpertsService();

  final RxMap<String, bool> reminderStatus = <String, bool>{}.obs;
  final RxMap<String, bool> reminderLoading =
      <String, bool>{}.obs; // 👈 per-session, replaces isLoading

  bool isReminderSet(String sessionId) => reminderStatus[sessionId] ?? false;
  bool isReminderLoading(String sessionId) =>
      reminderLoading[sessionId] ?? false;

  /// Call this once, right after fetching the session list, to seed
  /// initial reminder state from whatever the backend returns.
  void seedReminderState(List<Session> sessions) {
    for (final s in sessions) {
      // adjust field name to match whatever your Session model / API
      // response actually calls this — e.g. s.hasReminder, s.isReminderSet
      reminderStatus[s.id] = s.reminderEnabled;
    }
  }

  Future<void> toggleReminder({required String sessionId}) async {
    // ✅ PREMIUM CHECK BEFORE ALLOWING REMINDER ACTION
    // final premium = PremiumAccessService.to;

    // if (!premium.isReady.value) {
    //   Snack.showWarning('Checking subscription status...');
    //   return;
    // }

    // if (!premium.isPremiumUserNow) {
    //   Get.toNamed(RoutePaths.subscriptionUpgrade);
    //   return;
    // }

    // ✅ User is premium — proceed with reminder toggle
    if (isReminderLoading(sessionId)) return; // per-session guard now

    reminderLoading[sessionId] = true;

    try {
      final alreadySet = isReminderSet(sessionId);

      final success = alreadySet
          ? await service.removeReminder(sessionId: sessionId)
          : await service.setReminder(sessionId: sessionId);

      if (success) {
        reminderStatus[sessionId] =
            !alreadySet; // 👈 triggers Obx rebuild for just this card
      }
    } catch (e) {
      print("Reminder error: $e");
    } finally {
      reminderLoading[sessionId] = false;
    }
  }

  @override
  void onClose() {
    disposeInputs();
    super.onClose();
  }

  void disposeInputs() {
    // writeQuesCtrl.dispose();
    // writeQuesFocusNode.dispose();
  }
}
