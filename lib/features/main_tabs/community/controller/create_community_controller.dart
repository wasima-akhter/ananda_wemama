import 'package:image_picker/image_picker.dart';
import 'package:mama_app/features/main_tabs/community/services/community_service.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/models/ui/common_data_models.dart';

class CreateCommunityController extends GetxController {
  late CreateCommunityArgModel? args;

  final nameCtrl = TextEditingController();
  final nameFocus = FocusNode();

  @override
  void onInit() {
    args = Get.arguments as CreateCommunityArgModel?;
    debugPrint('create community arg model : ${args?.communityImg}');
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
    isLoading_.value = true;

    try {
      final response = await CommunityService().createCommunity(
        communityImg: fileImage.value,
        communityName: nameCtrl.text,
      );

      if (response == true) {
        debugPrint('onTapCreate success : $response');
      } else {
        debugPrint('onTapCreate failed : $response');
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
