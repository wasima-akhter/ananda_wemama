import 'package:image_picker/image_picker.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../../../../core/models/ui/common_data_models.dart';
import '../../core/models/all_comments_of_post_model.dart';
import '../../core/models/community_item_detail_model.dart' hide Creator;
import '../../core/services/community_detail_service.dart';
import '../../detail/controller/community_detail_controller.dart';

class PostDetailsController extends GetxController {
  static PostDetailsController get to => Get.find();
  var postAnonymously = false.obs; // 👈 toggle state

  final commentCtrl = TextEditingController();
  final commentFocus = FocusNode();

  final scrollController = ScrollController(); // ← add

  final postDetailArg = Rxn<PostDetailArgModel>();

  final isResolvingPost = false.obs;
  final resolveFailed = false.obs;

  @override
  void onInit() async {
    final args = Get.arguments as PostDetailArgModel;

    if (args.isIdOnly) {
      await _resolveFromIds(
        communityId: args.communityData.id ?? '',
        postId: args.postItem.id ?? '',
      );
    } else {
      postDetailArg.value =
          args; // came fully populated from CommunityDetailsScreen
    }

    log('postId_: ${postDetailArg.value?.postItem.id}');
    await getCommentsList();
    super.onInit();
  }

  Future<void> _resolveFromIds({
    required String communityId,
    required String postId,
  }) async {
    if (communityId.isEmpty || postId.isEmpty) {
      resolveFailed.value = true;
      return;
    }

    isResolvingPost.value = true;
    try {
      final community = await CommunityDetailService().fetchCommunityDetail(
        communityItemId: communityId,
      );

      final post = community?.allPost?.firstWhereOrNull(
        (p) => p.id == postId,
      ); // package:collection

      if (community == null || post == null) {
        log('⚠️ post $postId not found in community $communityId');
        resolveFailed.value = true;
        return;
      }

      postDetailArg.value = PostDetailArgModel(
        communityData: Community(
          id: community.community?.id,
          name: community.community?.name,
        ),
        postItem: post,
      );

      // Prime CommunityDetailController's cache too, so like/pin flags &
      // btnState are correct if the user backs out into the full community screen.
      if (Get.isRegistered<CommunityDetailController>()) {
        final cc = CommunityDetailController.to;
        if (cc.communityItemId == communityId) {
          cc.communityItemDetail.value = community;
        }
      }
    } catch (e) {
      log('Error resolving post from ids: $e');
      resolveFailed.value = true;
    } finally {
      isResolvingPost.value = false;
    }
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

  void onTapReply() {}

  void toggleAnonymous(bool value) {
    postAnonymously.value = value;
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

  /// Fetch the latest  data from API
  final isGetCommentsLoading = false.obs;
  final comments = <CommentModelOfPost>[].obs;

  ///
  Future<void> getCommentsList() async {
    if (isGetCommentsLoading.value) return; // Prevent duplicate calls
    isGetCommentsLoading.value = true;

    try {
      final data = await CommunityDetailService().fetchCommentsOfAPost(
        postId: postDetailArg.value?.postItem.id ?? '',
      );

      if (data != null) {
        comments.value = data.comments ?? [];
      }
    } catch (e) {
      log("Error fetching comments: $e");
    } finally {
      isGetCommentsLoading.value = false;
    }
  }

  UIState get commentState =>
      getUIStateList(isLoading: isGetCommentsLoading.value, list: comments);

  final replyingToCommentId = RxnString();
  final replyingToUserName = ''.obs;

  //
  final isAddCommentLoading = false.obs;

  Future<void> onTapAddComment() async {
    if (isAddCommentLoading.value) return;

    final text = commentCtrl.text.trim();
    if (text.isEmpty) return;

    isAddCommentLoading.value = true;
    unFocusAll();

    try {
      final isReply = replyingToCommentId.value != null;

      final success = await CommunityDetailService().addComment(
        communityItemId: postDetailArg.value?.communityData.id ?? '',
        postItemId: postDetailArg.value?.postItem.id ?? '',
        parentCommentId: (replyingToCommentId.value ?? '').isEmpty
            ? null
            : replyingToCommentId.value,
        content: text,
        commentorName: currentProfileName(),
      );

      if (success == true) {
        final now = DateTime.now();

        if (isReply) {
          // ✅ ADD CHILD COMMENT
          final parentIndex = comments.indexWhere(
            (e) => e.id == replyingToCommentId.value,
          );

          if (parentIndex != -1) {
            final parent = comments[parentIndex];

            final updatedReplies = List<ReplyModelOfPost>.from(
              parent.replies ?? [],
            );

            updatedReplies.add(
              ReplyModelOfPost(
                id: now.millisecondsSinceEpoch.toString(), // temp id
                content: text,
                createdAt: now,
                creator: Creator(
                  name: currentProfileName(),
                  profileImage: currentUserImage(), // if available
                ),
              ),
            );

            comments[parentIndex] = CommentModelOfPost(
              id: parent.id,
              creator: parent.creator,
              content: parent.content,
              createdAt: parent.createdAt,
              replies: updatedReplies,
            );

            updateParentCommentCount(increase: true);
          }
        } else {
          // ✅ ADD PARENT COMMENT
          comments.insert(
            0,
            CommentModelOfPost(
              id: now.millisecondsSinceEpoch.toString(),
              content: text,
              createdAt: now,
              creator: Creator(
                name: currentProfileName(),
                profileImage: currentUserImage(),
              ),
              replies: [],
            ),
          );

          updateParentCommentCount(increase: true);

          // ✅ Refresh from server to get real IDs
          await getCommentsList();
        }

        // 🔥 IMPORTANT: force UI update
        comments.refresh();

        // reset reply state
        replyingToCommentId.value = null;
        replyingToUserName.value = '';
      }
    } catch (e) {
      log("Error adding comment: $e");
    } finally {
      isAddCommentLoading.value = false;
      clearAll();
    }
  }

  void updateParentCommentCount({required bool increase}) {
    final communityCtrl = CommunityDetailController.to;

    final postId = postDetailArg.value?.postItem.id;

    if (postId == null) return;

    final index = communityCtrl.communityItemDetail.value.allPost?.indexWhere(
      (e) => e.id == postId,
    );

    if (index == null || index == -1) return;

    final post = communityCtrl.communityItemDetail.value.allPost![index];

    post.totalComment = (post.totalComment ?? 0) + (increase ? 1 : -1);

    if ((post.totalComment ?? 0) < 0) {
      post.totalComment = 0;
    }

    communityCtrl.communityItemDetail.refresh();
  }
}
