import 'package:image_picker/image_picker.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

import '../../../../../core/models/ui/common_data_models.dart';
import '../../core/services/community_service.dart';

class CreateCommunityController extends GetxController {
  late CreateCommunityArgModel? args;

  final nameCtrl = TextEditingController();
  final nameFocus = FocusNode();

  @override
  void onInit() {
    args = Get.arguments as CreateCommunityArgModel?;
    log('create community arg model : ${args?.communityImg}');
    super.onInit();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    nameFocus.dispose();
    super.onClose();
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
      imageQuality: 60,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (selectedImage != null) {
      fileImage.value = selectedImage;

      log("file.name: ${selectedImage.name}");
      log("file.path: ${selectedImage.path}");
    }
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  Future<void> onTapCreate() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    if (nameCtrl.text.trim().isEmpty) {
      "Name is required".showToast();
      return;
    }
    if (nameCtrl.text.trim().length < 3) {
      "Name must be of at least 3 characters".showToast();
      return;
    }

    if (fileImage.value == null) {
      "Community image is required".showToast();
      return;
    }

    isLoading_.value = true;

    try {
      final response = await CommunityService().createCommunity(
        communityImg: fileImage.value,
        communityName: nameCtrl.text,
      );

      if (response == true) {
        log('onTapCreate success : $response');

        "Created successfully. Awaiting Admin approval.".showToast();
      } else {
        log('onTapCreate failed : $response');
      }
    } catch (e) {
      log("Error onTapCreate community: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
      clearAll();
    }
  }
}
