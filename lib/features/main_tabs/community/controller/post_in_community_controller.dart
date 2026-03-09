import 'package:image_picker/image_picker.dart';

import '../../../../app/controller_export.dart';

class PostInCommunityController extends GetxController {
  final nameCtrl = TextEditingController();
  final nameFocus = FocusNode();

  var postAnonymously = false.obs; // 👈 toggle state

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    nameFocus.dispose();
    super.onClose();
  }

  void toggleAnonymous(bool value) {
    postAnonymously.value = value;
  }

  void clearAll() {
    nameCtrl.clear();
    fileImage.value = null;
  }

  void unFocusAll() {
    nameFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  var fileImage = Rxn<XFile>();

  Future<void> pickSingleImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? selectedImage = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (selectedImage != null) {
      fileImage.value = selectedImage;

      print("file.name: ${selectedImage.name}");
      print("file.path: ${selectedImage.path}");
    }
  }

  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  Future<void> getChatList() async {
    if (isLoading_.value) return;

    isLoading_.value = true;

    try {} catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;
      unFocusAll();
    }
  }
}
