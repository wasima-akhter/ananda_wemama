import 'package:image_picker/image_picker.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/models/ui/common_data_models.dart';
import '../../core/services/community_service.dart';
import '../../detail/controller/community_detail_controller.dart';

class ManageCommunityController extends GetxController {
  late CreateCommunityArgModel? args;

  final nameCtrl = TextEditingController();
  final nameFocus = FocusNode();

  // Add this observable
  var existingImageUrl = ''.obs;
  var communityId = ''.obs;

  @override
  void onInit() {
    args = Get.arguments as CreateCommunityArgModel?;
    nameCtrl.text = args?.communityName ?? '';
    communityId.value = args?.communityId ?? '';
    existingImageUrl.value = args?.communityImg ?? ''; // ← was the broken line
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

  Future<void> onTapEdit() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      final response = await CommunityService().updateCommunity(
        communityId: communityId.value,
        communityImg: fileImage.value,
        communityName: nameCtrl.text,
      );

      if (response == true) {
        print('onTapEdit success : $response');

        await CommunityDetailController.to.getCommunityDetail(
          communityIdForRefresh: communityId.value,
        );
      } else {
        print('onTapEdit failed : $response');
      }
    } catch (e) {
      print("Error onTapEdit community: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }
}
