import 'package:mama_app/features/main_tabs/community/services/community_detail_service.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../model/community_item_detail_model.dart';
/*
class PostItemState {
  final int id;
  final isCommentLocked = false.obs;
  final isLiked = false.obs; // ← add
  final isPinned = false.obs; // ← add

  PostItemState({required this.id});
}

class CommunityDetailController extends GetxController {
  /// incoming params
  final MyCommunityBtnState initialBtnState;
  final String communityItemId;

  /// reactive state
  late final Rx<MyCommunityBtnState> args;
  late final RxBool isAlreadyMember_;

  CommunityDetailController(this.initialBtnState, this.communityItemId);

  bool get isAlreadyMember => isAlreadyMember_.value;

  ////
  final postCtrl = TextEditingController();
  final searchFocus = FocusNode();

  // replace getBtnTxt() local function with this
  String getBtnTxt() {
    switch (args.value) {
      case MyCommunityBtnState.join:
        return isAlreadyMember_.value ? Strings.joined : Strings.join;
      case MyCommunityBtnState.manage:
        return Strings.manage;
      case MyCommunityBtnState.visit:
        return Strings.joined;
    }
  }

  // in CommunityDetailController
  var posts = <PostItemState>[].obs;

  PostItemState? findPostById(String postId) {
    final id = int.tryParse(postId);
    if (id == null) return null;

    for (final p in posts) {
      if (p.id == id) return p;
    }
    return null;
  }

  void toggleLike(String postId) {
    final post = getPost(postId);
    post?.isLiked.toggle();
  }

  void togglePin(String postId) {
    final post = getPost(postId);
    post?.isPinned.toggle();
  }

  void toggleCommentLock(String postId) {
    final post = getPost(postId);
    post?.isCommentLocked.toggle();
  }

  String getPinBtnTxt(String postId) {
    final post = getPost(postId);
    return (post?.isPinned.value ?? false)
        ? Strings.unpinPost.capEachWord()
        : Strings.pinPost.capEachWord();
  }

  String getLockBtnTxt(String postId) {
    final post = getPost(postId);
    return (post?.isCommentLocked.value ?? false)
        ? Strings.unlockComment.capEachWord()
        : Strings.lockComment.capEachWord();
  }

  PostItemState? getPost(String postId) {
    final id = int.tryParse(postId);
    if (id == null) return null;

    try {
      return posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    /// ✅ initialize args FIRST
    args = initialBtnState.obs;

    print("args: ${args.value.name}");

    /// Example logic (adjust based on API later)
    isAlreadyMember_ = (initialBtnState != MyCommunityBtnState.join).obs;

    posts.value = List.generate(10, (index) => PostItemState(id: index));

    debugPrint("args: ${args.value.name}");
    debugPrint('communityItemId: $communityItemId');

    getCommunityDetail();

    super.onInit();
  }

  @override
  void onClose() {
    postCtrl.dispose();
    searchFocus.dispose();
    super.onClose();
  }

  void clearAll() {
    postCtrl.clear();
  }

  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final communityItemDetail = CommunityItemDetailModel().obs;

  /// Fetch the latest  data from API
  Future<void> getCommunityDetail() async {
    if (isLoading_.value) return  ; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      final data = await CommunityDetailService().fetchCommunityDetail(
        communityItemId: communityItemId,
      );

      if (data != null) {
        communityItemDetail.value = data;
        debugPrint('communityItemDetail: $communityItemDetail');

        // ✅ MAP API POSTS → LOCAL STATE

        posts.value = (data.allPost ?? []).map((e) {
          return PostItemState(id: int.parse(e.id ?? '0'))
            ..isLiked.value = e.isLiked ?? false
            ..isPinned.value = e.isPinned ?? false
            ..isCommentLocked.value = e.isPinned ?? false;
        }).toList();
      }
    } catch (e) {
      print("Error fetching Community Detail: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }


  //
  Future<void> postToggleLike() async {
    if (isLoading_.value) return ; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      final data = await CommunityDetailService().fetchCommunityDetail(
        communityItemId: communityItemId,
      );

      if (data != null) {
        communityItemDetail.value = data;
        debugPrint('communityItemDetail: $communityItemDetail');

        // ✅ MAP API POSTS → LOCAL STATE

        posts.value = (data.allPost ?? []).map((e) {
          return PostItemState(id: int.parse(e.id ?? '0'))
            ..isLiked.value = e.isLiked ?? false
            ..isPinned.value = e.isPinned ?? false
            ..isCommentLocked.value = e.isPinned ?? false;
        }).toList();
      }
    } catch (e) {
      print("Error fetching Community Detail: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }

  void onTapItem() {}

  void onTapItemBtn() {}
}
*/

class _PostFlags {
  final RxBool isLiked;
  final RxBool isPinned;
  final RxBool isCommentLocked;

  _PostFlags({required bool isLiked, required bool isPinned, required bool isCommentLocked})
    : isLiked = isLiked.obs,
      isPinned = isPinned.obs,
      isCommentLocked = isCommentLocked.obs;
}

class CommunityDetailController extends GetxController {
  final MyCommunityBtnState initialBtnState;
  final String communityItemId;

  late final Rx<MyCommunityBtnState> args;
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

  /// Always returns a _PostFlags — creates a default one if missing.
  /// This prevents Obx from tracking zero observables on first build.
  // Change _ensureFlags
  _PostFlags _ensureFlags(String postId) {
    return _postFlags.putIfAbsent(
      postId, // ✅ use raw string — no int.tryParse, no -1 collision
      () => _PostFlags(isLiked: false, isPinned: false, isCommentLocked: false),
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
  String getPinBtnTxt(String postId) =>
      pinFlag(postId).value ? Strings.unpinPost.capEachWord() : Strings.pinPost.capEachWord();

  String getLockBtnTxt(String postId) => commentLockFlag(postId).value
      ? Strings.unlockComment.capEachWord()
      : Strings.lockComment.capEachWord();

  String getBtnTxt() {
    switch (args.value) {
      case MyCommunityBtnState.join:
        return isAlreadyMember_.value ? Strings.joined : Strings.join;
      case MyCommunityBtnState.manage:
        return Strings.manage;
      case MyCommunityBtnState.visit:
        return Strings.joined;
    }
  }

  @override
  void onInit() {
    args = initialBtnState.obs;
    isAlreadyMember_ = (initialBtnState != MyCommunityBtnState.join).obs;

    debugPrint("args: ${args.value.name}");
    debugPrint('communityItemId: $communityItemId');

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

  Future<void> getCommunityDetail() async {
    if (isLoading_.value) return;
    isLoading_.value = true;

    try {
      final data = await CommunityDetailService().fetchCommunityDetail(
        communityItemId: communityItemId,
      );

      if (data != null) {
        communityItemDetail.value = data;

        // Update existing flags in-place so Obx widgets don't lose their subscription
        // Change getCommunityDetail — update in-place block
        for (final post in data.allPost ?? []) {
          final id = post.id;
          if (id == null || id.isEmpty) continue; // ✅ skip truly invalid posts

          final existing = _postFlags[id];
          if (existing != null) {
            existing.isLiked.value = post.isLiked ?? false;
            existing.isPinned.value = post.isPinned ?? false;
            existing.isCommentLocked.value = post.isCommentLocked ?? false;
          } else {
            _postFlags[id] = _PostFlags(
              isLiked: post.isLiked ?? false,
              isPinned: post.isPinned ?? false,
              isCommentLocked: post.isCommentLocked ?? false,
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching Community Detail: $e");
    } finally {
      isLoading_.value = false;
      unFocusAll();
    }
  }
}
