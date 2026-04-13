import 'package:image_picker/image_picker.dart';
import 'package:mama_app/features/main_tabs/community/services/community_detail_service.dart';

import '../../../../app/controller_export.dart';

class PostInCommunityController extends GetxController {
  final contentCtrl = TextEditingController();
  final contentFocus = FocusNode();

  var postAnonymously = false.obs; // 👈 toggle state

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    contentCtrl.dispose();
    contentFocus.dispose();
    super.onClose();
  }

  void toggleAnonymous(bool value) {
    postAnonymously.value = value;
  }

  void clearAll() {
    contentCtrl.clear();
    fileImage.value = null;
  }

  void unFocusAll() {
    contentFocus.unfocus();
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

  RxBool isCreatePostLoading = false.obs;
  Future<void> uploadSessionQues({required String communityItemId}) async {
    if (isCreatePostLoading.value) return;

    isCreatePostLoading.value = true;

    try {
      final response = await CommunityDetailService().createNewPost(
        communityItemId: communityItemId,
        content: contentCtrl.text.trim(),
        isAnonymous: postAnonymously.value,
      );
      if (response == true) {
        debugPrint('quest sent successfully!');
        Get.back();
      } else {
        debugPrint('quest sent failed!');
      }
    } catch (e) {
      debugPrint('upload ques of Session error: $e');
    } finally {
      isCreatePostLoading.value = false;
      clearAll();
      unFocusAll();
    }
  }
}
