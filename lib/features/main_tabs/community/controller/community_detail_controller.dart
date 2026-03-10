import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';

class PostItemState {
  final int id;
  final isCommentLocked = false.obs;
  final isLiked = false.obs; // ← add
  final isPinned = false.obs; // ← add

  PostItemState({required this.id});
}

class CommunityDetailController extends GetxController {
  final Rx<MyCommunityBtnState> args;

  late final RxBool isAlreadyMember_; // ← observable

  CommunityDetailController(MyCommunityBtnState initialArgs, bool isAlreadyMember)
    : args = initialArgs.obs {
    isAlreadyMember_ = isAlreadyMember.obs; // ← init in constructor body
  }

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

  void toggleLike(int postId) {
    posts.firstWhere((p) => p.id == postId).isLiked.toggle();
  }

  void togglePin(int postId) {
    posts.firstWhere((p) => p.id == postId).isPinned.toggle();
  }

  String getPinBtnTxt(int postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    return post.isPinned.value ? Strings.unpinPost.capEachWord() : Strings.pinPost.capEachWord();
  }

  @override
  void onInit() {
    // initialize with fake data
    posts.value = List.generate(10, (index) => PostItemState(id: index));
    print("args: ${args.value.name}");
    super.onInit();
  }

  void toggleCommentLock(int postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    post.isCommentLocked.toggle();
  }

  String getLockBtnTxt(int postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    return post.isCommentLocked.value
        ? Strings.unlockComment.capEachWord()
        : Strings.lockComment.capEachWord();
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

  /// Fetch the latest  data from API
  Future<void> getChatList() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      // final data = await ChatService().fetchChatList(

      // );

      // if (data != null) {

      // }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }

  void onTapItem() {}

  void onTapItemBtn() {}
}
