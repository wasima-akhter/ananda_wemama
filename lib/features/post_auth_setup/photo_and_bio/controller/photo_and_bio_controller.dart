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

    final XFile? selectedImage = await picker.pickImage( imageQuality: 60,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    GNav.pop();

    if (selectedImage != null) {
      fileImage.value = selectedImage;

      print("file.name: ${selectedImage.name}");
      print("file.path: ${selectedImage.path}");
    }
  }
  /////

  Future<void> onTapContinuePhotoBio(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;

    unfocusAll();
    isLoading_.value = true;

    Get.toNamed(RoutePaths.lifeStyleAndInterests);

    isLoading_.value = false;
  }

  @override
  void onClose() {
    bioDesCtrl.dispose();
    bioDesFocus.dispose();
    super.onClose();
  }
}
