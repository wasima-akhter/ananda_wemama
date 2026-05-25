import '../../../../app/controller_export.dart';
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
    if (isSendQuesLoading.value) return false;

    isSendQuesLoading.value = true;

    try {
      final response = await ExpertsService().uploadUpcomingSessionQues(
        expertId: expertId,
        question: question,
        sessionId: sessionId,
      );

      if (response == true) {
        Get.back();
        // writeQuesCtrl.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        return true;
      }

      return false;
    } finally {
      isSendQuesLoading.value = false;
    }
  }

  void disposeInputs() {
    // writeQuesCtrl.dispose();
    // writeQuesFocusNode.dispose();
  }

  @override
  void onClose() {
    disposeInputs();
    super.onClose();
  }
}
