import 'package:image_picker/image_picker.dart';
import 'package:we_mama/features/shared/report_sheet/service/report_service.dart';

import '../../../../app/controller_export.dart';

class ReportController extends GetxController {
  final noteCtrl = TextEditingController();

  final noteFocus = FocusNode();

  /// Selected reason (reactive)
  final RxString selectedReason = ''.obs;

  //
  final RxList<String> reportReasons = <String>[
    Strings.harassment,
    Strings.bullying,
    Strings.medicalMisinformation,
    Strings.spam,
    Strings.inappropriateContent,
    Strings.hateSpeech,
    Strings.privacyViolation,
    Strings.other,
  ].obs;

  void selectReason(String reason) {
    selectedReason.value = reason;

    print("Selected reason: $reason");
  }

  @override
  void onClose() {
    noteCtrl.dispose();
    noteFocus.dispose();
    super.onClose();
  }

  void unFocusAll() {
    noteFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  var pickedImageOrFile = Rxn<XFile>(); // for image

  /// Pick single image (camera/gallery) or any type of file
  Future<void> pickSingleImageOrFile(ImageSource source) async {
    // Pick image from camera/gallery

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      imageQuality: 60,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (image != null) {
      pickedImageOrFile.value = image;
      print("Picked image: ${image.path}");
    }
    return;
  }

  void clearAll() {
    noteCtrl.clear();
    noteFocus.unfocus();
    pickedImageOrFile.value = null;
    selectedReason.value = '';
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// Fetch the latest  data from API
  Future<void> report({
    required bool isUserReport,
    String? userId,
    String? postId,
  }) async {
    // ------------------------------------------------------------
    // VALIDATION
    // ------------------------------------------------------------

    final reason = selectedReason.value.trim();
    final note = noteCtrl.text.trim();

    if (reason.isEmpty) {
      Snack.showWarning('Please select a report reason.');
      return;
    }

    if (note.isEmpty) {
      Snack.showWarning('Please enter a note.');
      return;
    }

    // ------------------------------------------------------------
    // PREVENT DUPLICATE REQUEST
    // ------------------------------------------------------------
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    final id_ = isUserReport ? userId : postId;

    try {
      final data = await ReportService().reportUserOrContent(
        id_: id_ ?? '',
        isUserReport: isUserReport,
        name: selectedReason.value,
        note: noteCtrl.text.trim(),
        reportImage: pickedImageOrFile.value,
      );

      if (data != null) {
        print('report success: ${data.report}');
      }
    } catch (e) {
      print("Error reportUserOrContent: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
      clearAll();
      Get.back(); // report sheet collapse
    }
  }

  void onTapAddPhotoCard() {
    pickSingleImageOrFile(ImageSource.gallery);
  }
}
