import 'package:image_picker/image_picker.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/utils/extension/string_extension.dart';
import '../../core/services/community_detail_service.dart';
import '../../detail/controller/community_detail_controller.dart';

class CreatePostController extends GetxController {
  final String communityItemId;

  CreatePostController(this.communityItemId);

  final contentCtrl = TextEditingController();
  final contentFocus = FocusNode();

  var postAnonymously = false.obs; // 👈 toggle state

  @override
  void onInit() {
    print(' communityItemId :$communityItemId ');
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
  Future<void> createNewPost() async {
    if (isCreatePostLoading.value) return;

    if (contentCtrl.text.isEmpty) {
      Strings.writeSomething.showToast();
      return;
    }

    isCreatePostLoading.value = true;

    try {
      final response = await CommunityDetailService().createNewPost(
        communityItemId: communityItemId,
        content: contentCtrl.text.trim(),
        isAnonymous: postAnonymously.value,
      );
      if (response == true) {
        print('Post created successfully!');
        Get.back();

        if (Get.isRegistered<CommunityDetailController>()) {
          await CommunityDetailController.to.onRefresh();
        }
      } else {
        print('Post created failed!');
      }
    } catch (e) {
      print('Post created  error: $e');
    } finally {
      if (!isClosed) {
        isCreatePostLoading.value = false;
        clearAll();
        unFocusAll();
      }
    }
  }
}
