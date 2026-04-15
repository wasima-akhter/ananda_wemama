import 'package:image_picker/image_picker.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../model/all_comments_of_post_model.dart';
import '../services/community_detail_service.dart';

class PostDetailsController extends GetxController {
  var postAnonymously = false.obs; // 👈 toggle state

  final commentCtrl = TextEditingController();
  final commentFocus = FocusNode();

  final scrollController = ScrollController(); // ← add

  var postId = ''.obs;

  @override
  void onInit() async {
    final postId_ = Get.arguments;
    postId.value = (postId_ ?? '').toString();
    debugPrint('postId_: $postId_');
    await getCommentsList();
    super.onInit();
  }

  @override
  void onClose() {
    commentCtrl.dispose();
    commentFocus.dispose();
    scrollController.dispose(); // ← dispose
    super.onClose();
  }

  void clearAll() {
    commentCtrl.clear();
  }

  void unFocusAll() {
    commentFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final showChildren = false.obs;

  void onTapReply() {}

  void toggleAnonymous(bool value) {
    postAnonymously.value = value;
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

  /// Fetch the latest  data from API
  final isGetCommentsLoading = false.obs;
  final comments = <CommentModelOfPost>[].obs;

  ///
  Future<void> getCommentsList() async {
    if (isGetCommentsLoading.value) return; // Prevent duplicate calls
    isGetCommentsLoading.value = true;

    try {
      final data = await CommunityDetailService().fetchCommentsOfAPost(postId: postId.value);

      if (data != null) {
        comments.value = data.comments ?? [];
      }
    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      isGetCommentsLoading.value = false;

      unFocusAll();
    }
  }

  UIState get commentState => getUIStateList(isLoading: isGetCommentsLoading.value, list: comments);

  void onTapAddComment() {}
}
