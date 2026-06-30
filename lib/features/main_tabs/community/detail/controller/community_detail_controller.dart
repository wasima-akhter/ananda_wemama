import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../../../../core/helpers/widgets_helper.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../core/services/community_detail_service.dart';
import '../../feed/controller/community_controller.dart';
import '../../search/controller/community_search_controller.dart';

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
       isdeleteLoading = false.obs; // ✅ FIXED
}

class CommunityDetailController extends GetxController {
  static CommunityDetailController get to => Get.find();
  final MyCommunityBtnState initialBtnState;
  final String communityItemId;

  late final Rx<MyCommunityBtnState> btnState;
  late final RxBool isAlreadyMember_;

  CommunityDetailController(this.initialBtnState, this.communityItemId);

  bool get isAlreadyMember => isAlreadyMember_.value;

  final postCtrl = TextEditingController();
  final searchFocus = FocusNode();

  // Keyed by post id — populated before widgets build
  final Map<String, _PostFlags> _postFlags = {};

  // ── Public flag accessors (always returns a valid RxBool) ──
  RxBool likeFlag(String postId) => _ensureFlags(postId).isLiked;
  RxBool pinFlag(String postId) => _ensureFlags(postId).isPinned;
  RxBool commentLockFlag(String postId) => _ensureFlags(postId).isCommentLocked;
  RxBool deleteLockFlag(String postId) => _ensureFlags(postId).isCommentDeleted;

  RxBool deleteLoadingFlag(String postId) =>
      _ensureFlags(postId).isdeleteLoading;

  /// Always returns a _PostFlags — creates a default one if missing.
  /// This prevents Obx from tracking zero observables on first build.
  // Change _ensureFlags
  // _PostFlags _ensureFlags(String postId) {
  //   return _postFlags.putIfAbsent(
  //     postId, // ✅ use raw string — no int.tryParse, no -1 collision
  //     () => _PostFlags(isLiked: false, isPinned: false, isCommentLocked: false),
  //   );
  // }

  _PostFlags _ensureFlags(String postId) {
    if (!_postFlags.containsKey(postId)) {
      log("⚠️ Missing flags for postId: $postId");
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

  // Change flagsOf
  _PostFlags? flagsOf(String postId) {
    return _postFlags[postId]; // ✅ direct string lookup
  }

  // ── Toggles ──
  void toggleLike(String postId) => likeFlag(postId).toggle();
  void togglePin(String postId) => pinFlag(postId).toggle();
  void toggleCommentLock(String postId) => commentLockFlag(postId).toggle();

  // ── Label helpers ──
  String getPinBtnTxt(String postId) => pinFlag(postId).value
      ? Strings.unpinPost.capEachWord()
      : Strings.pinPost.capEachWord();

  String getLockBtnTxt(String postId) => commentLockFlag(postId).value
      ? Strings.unlockComment.capEachWord()
      : Strings.lockComment.capEachWord();

  String getBtnTxt() {
    switch (btnState.value) {
      case MyCommunityBtnState.join:
        return Strings.join;
      case MyCommunityBtnState.manage:
        return Strings.manage;
      case MyCommunityBtnState.visit:
        return Strings.joined;
    }
  }

  @override
  void onInit() {
    btnState = initialBtnState.obs;

    log("initialBtnState: ${btnState.value.name}");
    isAlreadyMember_ = (initialBtnState != MyCommunityBtnState.join).obs;

    log('communityItemId: $communityItemId');

    getCommunityDetail();
    super.onInit();
  }

  @override
  void onClose() {
    postCtrl.dispose();
    searchFocus.dispose();
    super.onClose();
  }

  void clearAll() => postCtrl.clear();
  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ── API state ──
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final communityItemDetail = CommunityItemDetailModel().obs;

  Future<void> getCommunityDetail({String? communityIdForRefresh}) async {
    if (isLoading_.value) return;
    isLoading_.value = true;

    _postFlags.clear();

    try {
      final data = await CommunityDetailService().fetchCommunityDetail(
        communityItemId: communityIdForRefresh ?? communityItemId,
      );

      if (data != null) {
        communityItemDetail.value = data;

        // Update existing flags in-place so Obx widgets don't lose their subscription
        // Change getCommunityDetail — update in-place block
        // for (final post in data.allPost ?? []) {
        //   final id = post.id;
        //   if (id == null || id.isEmpty) continue; // ✅ skip truly invalid posts

        //   final existing = _postFlags[id];
        //   if (existing != null) {
        //     existing.isLiked.value = post.isLiked ?? false;
        //     existing.isPinned.value = post.isPinned ?? false;
        //     existing.isCommentLocked.value = post.isCommentLocked ?? false;
        //   } else {
        //     _postFlags[id] = _PostFlags(
        //       isLiked: post.isLiked ?? false,
        //       isPinned: post.isPinned ?? false,
        //       isCommentLocked: post.isCommentLocked ?? false,
        //     );
        //   }
        // }

        for (AllPost post in data.allPost ?? []) {
          final id = post.id;

          log('post id: $id');
          if (id == null || id.isEmpty) continue;

          _postFlags[id] = _PostFlags(
            isLiked: post.isLiked ?? false,
            isPinned: post.isPinned ?? false,
            isCommentLocked: post.isCommentLocked ?? false,
            isCommentDeleted: false,
          );
        }
        // 2. THEN update observable
        communityItemDetail.value = data;

        // 👉 If you see true but UI not showing → UI issue
        // 👉 If you see false → API mapping issue
        for (final e in _postFlags.entries) {
          log("POST ${e.key} -> pinned: ${e.value.isPinned.value}");
        }
      }
    } catch (e) {
      log("Error fetching Community Detail: $e");
    } finally {
      isLoading_.value = false;
      unFocusAll();
    }
  }

  /// like ------------------------------------->
  Future<void> toggleLikeApi(String postId, String likerName) async {
    final flags = _ensureFlags(postId);

    if (flags.isLikeLoading.value) return;

    final oldValue = flags.isLiked.value;

    // ✅ optimistic update
    flags.isLiked.toggle();
    flags.isLikeLoading.value = true;

    final success = await CommunityDetailService().postTogglelike(
      communityItemId: communityItemId,
      postItemId: postId,
      likerName: likerName,
    );

    if (!success) {
      // ❌ rollback
      flags.isLiked.value = oldValue;
    }

    flags.isLikeLoading.value = false;
  }

  Future<void> togglePinApi(String postId) async {
    final flags = _ensureFlags(postId);

    if (flags.isPinLoading.value) return;

    final oldValue = flags.isPinned.value;

    flags.isPinned.toggle();
    flags.isPinLoading.value = true;

    final success = await CommunityDetailService().pinPost(postItemId: postId);

    if (!success) {
      flags.isPinned.value = oldValue;
    }

    flags.isPinLoading.value = false;
  }

  Future<void> toggleLockApi(String postId) async {
    final flags = _ensureFlags(postId);

    if (flags.isLockLoading.value) return;

    final oldValue = flags.isCommentLocked.value;

    flags.isCommentLocked.toggle();
    flags.isLockLoading.value = true;

    final success = await CommunityDetailService().lockCommentOfPost(
      postItemId: postId,
    );

    if (!success) {
      flags.isCommentLocked.value = oldValue;
    }

    flags.isLockLoading.value = false;
  }

  // delete from backend and remove post from UI
  Future<void> deletePostApi(String postId) async {
    final flags = _ensureFlags(postId);

    if (flags.isdeleteLoading.value) return;

    flags.isdeleteLoading.value = true;

    try {
      final success = await CommunityDetailService().deletePost(
        postItemId: postId,
      );

      if (success) {
        // ✅ mark as deleted → UI will react
        flags.isCommentDeleted.value = true;

        // optional cleanup later (not immediate)
        Future.delayed(const Duration(seconds: 1), () {
          _postFlags.remove(postId);
        });
      } else {
        log("Delete failed");
      }
    } catch (e) {
      log("Delete error: $e");
    } finally {
      flags.isdeleteLoading.value = false;
    }
  }

  // ------------------> JOIN the group

  // ── API state ──
  var isJoinLoading = false.obs;
  Future<bool> joinCommunity({required String communityItemId}) async {
    if (isJoinLoading.value) return false;

    isJoinLoading.value = true;

    try {
      final success = await CommunityDetailService().joinCommunity(
        communityItemId: communityItemId,
      );

      if (success) {
        btnState.value = MyCommunityBtnState.visit;
        await Get.find<CommunitySearchController>().getSuggestedCommunityList();
        await Get.find<CommunityController>().getMyCommunityList();

        return true;
      }

      return false;
    } catch (e) {
      log('Community Join error: $e');
      return false;
    } finally {
      isJoinLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await getCommunityDetail();
  }

  //----------------------------------

  Future<void> onTapReportContent({required String postId}) async {
    await showReportBottomSheet(isUserReport: false, postId: postId);
    Get.back(); // report user dropdown collapse
  }
}
