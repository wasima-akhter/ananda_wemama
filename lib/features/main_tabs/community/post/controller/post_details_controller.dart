import 'package:image_picker/image_picker.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../../../../core/models/ui/common_data_models.dart';
import '../../core/models/all_comments_of_post_model.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../core/models/single_post_data.dart';
import '../../core/services/community_detail_service.dart';
import '../../detail/controller/community_detail_controller.dart';

class PostDetailsController extends GetxController {
  static PostDetailsController get to => Get.find();

  // ---------------------------------------------------------------------------
  // Controllers
  // ---------------------------------------------------------------------------

  final commentCtrl = TextEditingController();
  final commentFocus = FocusNode();
  final scrollController = ScrollController();

  // ---------------------------------------------------------------------------
  // Arguments
  // ---------------------------------------------------------------------------

  final postDetailArg = Rxn<PostDetailArgModel>();

  String get communityId => postDetailArg.value?.communityId ?? '';

  String get postId => postDetailArg.value?.postId ?? '';

  // ---------------------------------------------------------------------------
  // Post
  // ---------------------------------------------------------------------------

  final isGetSinglePostLoading = false.obs;
  final singlePost = Rxn<SinglePostModel>();

  // ---------------------------------------------------------------------------
  // Comments
  // ---------------------------------------------------------------------------

  final isGetCommentsLoading = false.obs;
  final comments = <CommentModelOfPost>[].obs;

  UIState get commentState =>
      getUIStateList(isLoading: isGetCommentsLoading.value, list: comments);

  // ---------------------------------------------------------------------------
  // Comment input / reply
  // ---------------------------------------------------------------------------

  final isAddCommentLoading = false.obs;

  final replyingToCommentId = RxnString();
  final replyingToUserName = ''.obs;

  // ---------------------------------------------------------------------------
  // Post creation / media
  // ---------------------------------------------------------------------------

  final postAnonymously = false.obs;
  final fileImage = Rxn<XFile>();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() async {
    super.onInit();

    final args = Get.arguments as PostDetailArgModel;

    postDetailArg.value = args;

    hasValidPostId.value = args.postId.trim().isNotEmpty;

    print(
      '[PostDetailsController] '
      'communityId: ${args.communityId}, '
      'postId: "${args.postId}", '
      'hasValidPostId: ${hasValidPostId.value}',
    );

    if (!hasValidPostId.value) {
      return;
    }

    await _loadInitialData();
  }

  final RxBool hasValidPostId = false.obs;

  @override
  void onClose() {
    commentCtrl.dispose();
    commentFocus.dispose();
    scrollController.dispose();

    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Initial data
  // ---------------------------------------------------------------------------

  Future<void> _loadInitialData() async {
    await getSinglePost();
    await getCommentsList();
  }

  // ---------------------------------------------------------------------------
  // Single post
  // ---------------------------------------------------------------------------

  Future<void> getSinglePost() async {
    if (isGetSinglePostLoading.value || postId.isEmpty) return;

    isGetSinglePostLoading.value = true;

    try {
      final post = await CommunityDetailService().fetchSinglePost(
        postId: postId,
      );

      if (post != null) {
        singlePost.value = post;

        print(
          '[PostDetailsController] '
          'Single post fetched: ${post.id}',
        );
      }
    } catch (e) {
      print('Error fetching single post: $e');
    } finally {
      isGetSinglePostLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Comments
  // ---------------------------------------------------------------------------

  Future<void> getCommentsList() async {
    if (!hasValidPostId.value) {
      print('[PostDetailsController] Skipping comments: postId is empty');
      return;
    }

    if (isGetCommentsLoading.value || postId.isEmpty) return;

    isGetCommentsLoading.value = true;

    try {
      final data = await CommunityDetailService().fetchCommentsOfAPost(
        postId: postId,
      );

      if (data != null) {
        comments.assignAll(data.comments ?? []);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    } finally {
      isGetCommentsLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Add comment / reply
  // ---------------------------------------------------------------------------

  Future<void> onTapAddComment() async {
    if (isAddCommentLoading.value) return;

    final text = commentCtrl.text.trim();

    if (text.isEmpty || communityId.isEmpty || postId.isEmpty) {
      return;
    }

    isAddCommentLoading.value = true;
    unFocusAll();

    try {
      final isReply = replyingToCommentId.value != null;

      final success = await CommunityDetailService().addComment(
        communityItemId: communityId,
        postItemId: postId,
        parentCommentId: replyingToCommentId.value?.isEmpty == true
            ? null
            : replyingToCommentId.value,
        content: text,
        commentorName: currentProfileName(),
      );

      if (!success) return;

      if (isReply) {
        _addReplyLocally(text);
      } else {
        _addCommentLocally(text);

        // Keep existing behavior:
        // refresh from server to get the real comment ID.
        await getCommentsList();
      }

      _increasePostCommentCount();

      comments.refresh();

      clearReplyState();
    } catch (e) {
      print('Error adding comment: $e');
    } finally {
      isAddCommentLoading.value = false;
      clearAll();
    }
  }

  void _addCommentLocally(String text) {
    final now = DateTime.now();

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
  }

  void _addReplyLocally(String text) {
    final parentIndex = comments.indexWhere(
      (comment) => comment.id == replyingToCommentId.value,
    );

    if (parentIndex == -1) return;

    final parent = comments[parentIndex];

    final replies = List<ReplyModelOfPost>.from(parent.replies ?? []);

    replies.add(
      ReplyModelOfPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        createdAt: DateTime.now(),
        creator: Creator(
          id: '',
          name: currentProfileName(),
          profileImage: currentUserImage(),
        ),
      ),
    );

    comments[parentIndex] = CommentModelOfPost(
      id: parent.id,
      creator: parent.creator,
      content: parent.content,
      createdAt: parent.createdAt,
      replies: replies,
    );
  }

  // ---------------------------------------------------------------------------
  // Comment count
  // ---------------------------------------------------------------------------

  void _increasePostCommentCount() {
    final post = singlePost.value;

    if (post != null) {
      post.totalComment = (post.totalComment ?? 0) + 1;
      singlePost.refresh();
    }

    _syncCommunityPostCommentCount(increase: true);
  }

  void _syncCommunityPostCommentCount({required bool increase}) {
    if (!Get.isRegistered<CommunityDetailController>()) {
      return;
    }

    final communityCtrl = CommunityDetailController.to;

    if (communityCtrl.communityItemId != communityId) {
      return;
    }

    final posts = communityCtrl.communityItemDetail.value.allPost;

    if (posts == null) return;

    final index = posts.indexWhere((post) => post.id == postId);

    if (index == -1) return;

    final post = posts[index];

    post.totalComment = (post.totalComment ?? 0) + (increase ? 1 : -1);

    if ((post.totalComment ?? 0) < 0) {
      post.totalComment = 0;
    }

    communityCtrl.communityItemDetail.refresh();
  }

  // ---------------------------------------------------------------------------
  // Reply state
  // ---------------------------------------------------------------------------

  void startReply(CommentModelOfPost comment) {
    replyingToCommentId.value = comment.id;
    replyingToUserName.value = comment.creator?.name ?? '';

    commentFocus.requestFocus();
  }

  void clearReplyState() {
    replyingToCommentId.value = null;
    replyingToUserName.value = '';
  }

  // ---------------------------------------------------------------------------
  // Input
  // ---------------------------------------------------------------------------

  void clearAll() {
    commentCtrl.clear();
  }

  void unFocusAll() {
    commentFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ---------------------------------------------------------------------------
  // Anonymous post
  // ---------------------------------------------------------------------------

  void toggleAnonymous(bool value) {
    postAnonymously.value = value;
  }

  // ---------------------------------------------------------------------------
  // Image
  // ---------------------------------------------------------------------------

  Future<void> pickSingleImage(ImageSource source) async {
    final picker = ImagePicker();

    final selectedImage = await picker.pickImage(
      imageQuality: 60,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (selectedImage == null) return;

    fileImage.value = selectedImage;

    print('file.name: ${selectedImage.name}');
    print('file.path: ${selectedImage.path}');
  }
}
