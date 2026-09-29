import 'package:image_picker/image_picker.dart';
import 'package:we_mama/app/helper_widgets_export.dart';

import '../../../../../core/models/ui/common_data_models.dart';
import '../../core/services/community_service.dart';

class CreateCommunityController extends GetxController {
  late CreateCommunityArgModel? args;

  final nameCtrl = TextEditingController();
  final nameFocus = FocusNode();

  @override
  void onInit() {
    args = Get.arguments as CreateCommunityArgModel?;
    print('create community arg model : ${args?.communityImg}');
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

      print("file.name: ${selectedImage.name}");
      print("file.path: ${selectedImage.path}");
    }
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  Future<void> onTapCreate() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    if (nameCtrl.text.trim().isEmpty) {
      Snack.showWarning("Name is required");
      return;
    }
    if (nameCtrl.text.trim().length < 3) {
      Snack.showWarning("Name must be of at least 3 characters");

      return;
    }

    if (fileImage.value == null) {
      Snack.showWarning("Community image is required");
      return;
    }

    isLoading_.value = true;

    try {
      final response = await CommunityService().createCommunity(
        communityImg: fileImage.value,
        communityName: nameCtrl.text,
      );

      if (response == true) {
        print('onTapCreate success : $response');

        Snack.showSuccess("Created successfully. Awaiting Admin approval.");
      } else {
        print('onTapCreate failed : $response');
      }
    } catch (e) {
      print("Error onTapCreate community: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
      clearAll();
    }
  }
}
