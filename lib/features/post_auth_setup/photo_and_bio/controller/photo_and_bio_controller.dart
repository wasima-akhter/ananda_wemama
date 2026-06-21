import 'package:image_picker/image_picker.dart';

import '../../../../app/controller_export.dart';

class PhotoAndBioController extends GetxController {
  // 🔹 Text Controller (only for name input field)
  final bioDesCtrl = TextEditingController();

  var fileImage = Rxn<XFile>();

  // Focus Node (only needed for actual text field)
  final bioDesFocus = FocusNode();

  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  //
  final bioText = ''.obs;
  late Worker _bioWorker;
  final bioError = ''.obs;

  @override
  void onInit() {
    super.onInit();

    bioDesCtrl.addListener(() {
      bioError.value = validateBioDescription(bioDesCtrl.text.trim()) ?? '';
    });
  }

  /// 🔹 Unfocus all fields
  void unfocusAll() {
    bioDesFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Clear all inputs
  void clearAll() {
    bioDesCtrl.clear();

    fileImage.value = null;

    unfocusAll();
  }

  Future<void> pickSingleImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? selectedImage = await picker.pickImage(
      imageQuality: 60,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    GNav.pop();

    if (selectedImage != null) {
      fileImage.value = selectedImage;

      log("file.name: ${selectedImage.name}");
      log("file.path: ${selectedImage.path}");
    }
  }
  /////

  Future<void> onTapContinuePhoto(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;

    /// 🔴 Image validation
    if (fileImage.value == null) {
      Snack.showWarning(title: "Required", "Please select a photo");
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    Get.toNamed(RoutePaths.addBio);

    isLoading_.value = false;
  }

  bool validateSelections() {
    final validation = validateBioDescription(bioDesCtrl.text.trim());

    bioError.value = validation ?? '';

    return validation == null;
  }

  Future<void> onTapContinueBio(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;

    if (!validateSelections()) {
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    Get.toNamed(RoutePaths.finishSettingProfile);

    isLoading_.value = false;
  }

  @override
  void onClose() {
    _bioWorker.dispose();

    bioDesCtrl.dispose();
    bioDesFocus.dispose();

    unfocusAll();

    super.onClose();
  }
}
