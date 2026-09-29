import '../../../../../app/controller_export.dart';
import '../../../../../core/helpers/widgets_helper.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../core/services/community_detail_service.dart';

class _PostFlags {
  final RxBool isLiked;
  final RxBool isPinned;
  final RxBool isCommentLocked;
  final RxBool isCommentDeleted;

  final RxBool isLikeLoading;
  final RxBool isPinLoading;
  final RxBool isLockLoading;
  final RxBool isdeleteLoading;

  _PostFlags({
    required bool isLiked,
    required bool isPinned,
    required bool isCommentLocked,
    required bool isCommentDeleted,
  }) : isLiked = isLiked.obs,
       isPinned = isPinned.obs,
       isCommentLocked = isCommentLocked.obs,
       isCommentDeleted = isCommentDeleted.obs,
       isLikeLoading = false.obs,
       isPinLoading = false.obs,
       isLockLoading = false.obs,
       isdeleteLoading = false.obs;
}

class PostActionController extends GetxController {
  static PostActionController get to => Get.find();

  final Map<String, _PostFlags> _postFlags = {};

  // ------------------------------------------------------------
  // FLAGS
  // ------------------------------------------------------------

  _PostFlags _ensureFlags(String postId) {
    if (!_postFlags.containsKey(postId)) {
      print('[PostActionController] Creating flags for post: $postId');
    }

    return _postFlags.putIfAbsent(
      postId,
      () => _PostFlags(
        isLiked: false,
        isPinned: false,
        isCommentLocked: false,
        isCommentDeleted: false,
      ),
    );
  }

  _PostFlags? flagsOf(String postId) {
    return _postFlags[postId];
  }

  RxBool likeFlag(String postId) {
    return _ensureFlags(postId).isLiked;
  }

  RxBool pinFlag(String postId) {
    return _ensureFlags(postId).isPinned;
  }

  RxBool commentLockFlag(String postId) {
    return _ensureFlags(postId).isCommentLocked;
  }

  RxBool deleteLockFlag(String postId) {
    return _ensureFlags(postId).isCommentDeleted;
  }

  RxBool deleteLoadingFlag(String postId) {
    return _ensureFlags(postId).isdeleteLoading;
  }

  // ------------------------------------------------------------
  // INITIALIZE FLAGS FROM COMMUNITY POSTS
  // ------------------------------------------------------------

  void initializeFromPosts(List<AllPost> posts) {
    _postFlags.clear();

    for (final post in posts) {
      final id = post.id;

      if (id == null || id.isEmpty) continue;

      _postFlags[id] = _PostFlags(
        isLiked: post.isLiked ?? false,
        isPinned: post.isPinned ?? false,
        isCommentLocked: post.isCommentLocked ?? false,
        isCommentDeleted: false,
      );

      print(
        '[PostActionController] '
        'POST $id -> '
        'liked: ${post.isLiked}, '
        'pinned: ${post.isPinned}, '
        'locked: ${post.isCommentLocked}',
      );
    }
  }

  // ------------------------------------------------------------
  // LOCAL TOGGLES
  // ------------------------------------------------------------

  void toggleLike(String postId) {
    likeFlag(postId).toggle();
  }

  void togglePin(String postId) {
    pinFlag(postId).toggle();
  }

  void toggleCommentLock(String postId) {
    commentLockFlag(postId).toggle();
  }

  // ------------------------------------------------------------
  // LABEL HELPERS
  // ------------------------------------------------------------

  String getPinBtnTxt(String postId) {
    return pinFlag(postId).value
        ? Strings.unpinPost.capEachWord()
        : Strings.pinPost.capEachWord();
  }

  String getLockBtnTxt(String postId) {
    return commentLockFlag(postId).value
        ? Strings.unlockComment.capEachWord()
        : Strings.lockComment.capEachWord();
  }

  // ------------------------------------------------------------
  // LIKE
  // ------------------------------------------------------------

  Future<void> toggleLikeApi({
    required String postId,
    required String likerName,
    String? communityId,
    Rx<CommunityItemDetailModel>? communityDetail,
  }) async {
    final flags = _ensureFlags(postId);

    if (flags.isLikeLoading.value) return;

    final oldLiked = flags.isLiked.value;

    int oldLikeCount = 0;
    int? postIndex;

    if (communityDetail != null) {
      postIndex = communityDetail.value.allPost?.indexWhere(
        (post) => post.id == postId,
      );

      if (postIndex != null && postIndex != -1) {
        oldLikeCount = communityDetail.value.allPost![postIndex].totalLike ?? 0;
      }
    }

    // Optimistic update.
    flags.isLiked.toggle();

    if (communityDetail != null && postIndex != null && postIndex != -1) {
      communityDetail.value.allPost![postIndex].totalLike = flags.isLiked.value
          ? oldLikeCount + 1
          : oldLikeCount - 1;

      communityDetail.refresh();
    }

    flags.isLikeLoading.value = true;

    try {
      final success = await CommunityDetailService().postTogglelike(
        communityItemId: communityId ?? '',
        postItemId: postId,
        likerName: likerName,
      );

      if (!success) {
        flags.isLiked.value = oldLiked;

        if (communityDetail != null && postIndex != null && postIndex != -1) {
          communityDetail.value.allPost![postIndex].totalLike = oldLikeCount;

          communityDetail.refresh();
        }
      }
    } catch (e) {
      print('[PostActionController] Like error: $e');

      flags.isLiked.value = oldLiked;

      if (communityDetail != null && postIndex != null && postIndex != -1) {
        communityDetail.value.allPost![postIndex].totalLike = oldLikeCount;

        communityDetail.refresh();
      }
    } finally {
      flags.isLikeLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // PIN
  // ------------------------------------------------------------

  Future<void> togglePinApi({required String postId}) async {
    final flags = _ensureFlags(postId);

    if (flags.isPinLoading.value) return;

    final oldValue = flags.isPinned.value;

    flags.isPinned.toggle();
    flags.isPinLoading.value = true;

    try {
      final success = await CommunityDetailService().pinPost(
        postItemId: postId,
      );

      if (!success) {
        flags.isPinned.value = oldValue;
      }
    } catch (e) {
      print('[PostActionController] Pin error: $e');
      flags.isPinned.value = oldValue;
    } finally {
      flags.isPinLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // LOCK COMMENT
  // ------------------------------------------------------------

  Future<void> toggleLockApi({required String postId}) async {
    final flags = _ensureFlags(postId);

    if (flags.isLockLoading.value) return;

    final oldValue = flags.isCommentLocked.value;

    flags.isCommentLocked.toggle();
    flags.isLockLoading.value = true;

    try {
      final success = await CommunityDetailService().lockCommentOfPost(
        postItemId: postId,
      );

      if (!success) {
        flags.isCommentLocked.value = oldValue;
      }
    } catch (e) {
      print('[PostActionController] Lock error: $e');
      flags.isCommentLocked.value = oldValue;
    } finally {
      flags.isLockLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------

  Future<void> deletePostApi({required String postId}) async {
    final flags = _ensureFlags(postId);

    if (flags.isdeleteLoading.value) return;

    flags.isdeleteLoading.value = true;

    try {
      final success = await CommunityDetailService().deletePost(
        postItemId: postId,
      );

      if (success) {
        flags.isCommentDeleted.value = true;

        Future.delayed(const Duration(seconds: 1), () {
          _postFlags.remove(postId);
        });
      } else {
        print('[PostActionController] Delete failed: $postId');
      }
    } catch (e) {
      print('[PostActionController] Delete error: $e');
    } finally {
      flags.isdeleteLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // REPORT
  // ------------------------------------------------------------

  Future<void> onTapReportContent({required String postId}) async {
    await showReportBottomSheet(isUserReport: false, postId: postId);

    Get.back();
  }

  // ------------------------------------------------------------
  // CLEAR
  // ------------------------------------------------------------

  void clearFlags() {
    _postFlags.clear();
  }
}
