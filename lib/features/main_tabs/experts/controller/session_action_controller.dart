import '../../../../app/controller_export.dart';
import '../services/experts_service.dart';

class SessionActionController extends GetxController {
  final writeQuesCtrl = TextEditingController();
  final writeQuesFocusNode = FocusNode();

  RxBool isSendQuesLoading = false.obs;

  Future<void> uploadSessionQues({
    required String expertId,
    required String sessionId,
  }) async {
    if (isSendQuesLoading.value) return;

    isSendQuesLoading.value = true;

    try {
      final response = await ExpertsService().uploadUpcomingSessionQues(
        expertId: expertId,
        question: writeQuesCtrl.text,
        sessionId: sessionId,
      );

      if (response == true) {
        Get.back();
        writeQuesCtrl.clear();
      }
    } finally {
      isSendQuesLoading.value = false;
    }
  }

  void disposeInputs() {
    writeQuesCtrl.dispose();
    writeQuesFocusNode.dispose();
  }

  @override
  void onClose() {
    disposeInputs();
    super.onClose();
  }
}
