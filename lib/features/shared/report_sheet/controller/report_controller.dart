import 'package:image_picker/image_picker.dart';

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
  void onInit() {
    super.onInit();
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
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// Fetch the latest  data from API
  Future<void> getChatList() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      // final data = await ChatService().fetchChatList(

      // );

      // if (data != null) {

      // }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }

  void onTapAddPhotoCard() {
    pickSingleImageOrFile(ImageSource.gallery);
  }
}
