import '../../../../../app/controller_export.dart';
import '../../../../../core/components/ui/dialogs/popups.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../../../../core/models/ui/common_data_models.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../core/services/community_detail_service.dart';
import '../../feed/controller/community_controller.dart';
import '../../post/controller/post_action_controller.dart';
import '../../search/controller/community_search_controller.dart';

/*
class CommunityDetailController extends GetxController {
  static CommunityDetailController get to => Get.find();

  final MyCommunityBtnState initialBtnState;
  final String communityItemId;

  late final Rx<MyCommunityBtnState> btnState;
  late final RxBool isAlreadyMember_;

  CommunityDetailController(this.initialBtnState, this.communityItemId);

  bool get isAlreadyMember => isAlreadyMember_.value;

  // ------------------------------------------------------------
  // CONTROLLERS
  // ------------------------------------------------------------

  final postCtrl = TextEditingController();
  final searchFocus = FocusNode();

  // ------------------------------------------------------------
  // COMMUNITY STATE
  // ------------------------------------------------------------

  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final communityItemDetail = CommunityItemDetailModel().obs;

  // ------------------------------------------------------------
  // COMMUNITY BUTTON STATE
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // LIFECYCLE
  // ------------------------------------------------------------

  @override
  void onInit() {
    btnState = initialBtnState.obs;

    print("initialBtnState: ${btnState.value.name}");

    isAlreadyMember_ = (initialBtnState != MyCommunityBtnState.join).obs;

    print('communityItemId: $communityItemId');

    getCommunityDetail();

    super.onInit();
  }

  @override
  void onClose() {
    postCtrl.dispose();
    searchFocus.dispose();

    super.onClose();
  }

  // ------------------------------------------------------------
  // COMMON HELPERS
  // ------------------------------------------------------------

  void clearAll() {
    postCtrl.clear();
  }

  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ------------------------------------------------------------
  // GET COMMUNITY DETAIL
  // ------------------------------------------------------------

  Future<void> getCommunityDetail({String? communityIdForRefresh}) async {
    if (isLoading_.value) return;

    isLoading_.value = true;

    try {
      final data = await CommunityDetailService().fetchCommunityDetail(
        communityItemId: communityIdForRefresh ?? communityItemId,
      );

      if (data != null) {
        communityItemDetail.value = data;

        // Post-specific state is maintained separately.
        //
        // This allows PostItemWidget and PostDetailsScreen
        // to use the same post action state.
        PostActionController.to.initializeFromPosts(data.allPost ?? []);

        for (final post in data.allPost ?? []) {
          print('post id: ${post.id}');
        }
      }
    } catch (e) {
      print("Error fetching Community Detail: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }

  // ------------------------------------------------------------
  // JOIN COMMUNITY
  // ------------------------------------------------------------

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
      print('Community Join error: $e');

      return false;
    } finally {
      isJoinLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // REFRESH
  // ------------------------------------------------------------

  Future<void> onRefresh() async {
    await getCommunityDetail();
  }

  // ------------------------------------------------------------
  // POST ACTION BRIDGE
  // ------------------------------------------------------------
  //
  // These methods intentionally remain here as small bridges.
  //
  // Why?
  // Existing CommunityDetail screen code may already call:
  //
  //   cc.toggleLikeApi(...)
  //   cc.togglePinApi(...)
  //   cc.toggleLockApi(...)
  //   cc.deletePostApi(...)
  //
  // Keeping these methods prevents unnecessary changes elsewhere
  // while the actual post logic lives inside PostActionController.
  //
  // ------------------------------------------------------------

  Future<void> toggleLikeApi(String postId, String likerName) async {
    await PostActionController.to.toggleLikeApi(
      postId: postId,
      likerName: likerName,
      communityId: communityItemId,
      communityDetail: communityItemDetail,
    );
  }

  Future<void> togglePinApi(String postId) async {
    await PostActionController.to.togglePinApi(postId: postId);
  }

  Future<void> toggleLockApi(String postId) async {
    await PostActionController.to.toggleLockApi(postId: postId);
  }

  Future<void> deletePostApi(String postId) async {
    await PostActionController.to.deletePostApi(postId: postId);
  }

  Future<void> onTapReportContent({required String postId}) async {
    await PostActionController.to.onTapReportContent(postId: postId);
  }
}
*/

class CommunityDetailController extends GetxController {
  static CommunityDetailController get to => Get.find();

  final MyCommunityBtnState initialBtnState;
  final String communityItemId;

  late final Rx<MyCommunityBtnState> btnState;
  late final RxBool isAlreadyMember_;

  CommunityDetailController(this.initialBtnState, this.communityItemId);

  bool get isAlreadyMember => isAlreadyMember_.value;

  // ------------------------------------------------------------
  // CONTROLLERS
  // ------------------------------------------------------------

  final postCtrl = TextEditingController();
  final searchFocus = FocusNode();

  // ------------------------------------------------------------
  // COMMUNITY STATE
  // ------------------------------------------------------------

  final isLoading_ = false.obs;

  bool get isLoading => isLoading_.value;

  final communityItemDetail = CommunityItemDetailModel().obs;

  Community get communityData =>
      communityItemDetail.value.community ?? Community();

  List<AllPost> get posts => communityItemDetail.value.allPost ?? <AllPost>[];

  // ------------------------------------------------------------
  // COMMUNITY DATA HELPERS
  // ------------------------------------------------------------

  String get communityName => communityData.name ?? '';

  String get communityImage => communityData.image ?? '';

  int get totalMembers => communityData.totalMember ?? 0;

  String get totalMembersText =>
      '${Strings.members.capEachWord()} $totalMembers';

  String get communityId => communityData.id ?? '';

  // ------------------------------------------------------------
  // COMMUNITY BUTTON STATE
  // ------------------------------------------------------------

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

  bool get showCommunityGuidelineButton =>
      btnState.value == MyCommunityBtnState.join ||
      btnState.value == MyCommunityBtnState.visit;

  bool get isJoinButton => btnState.value == MyCommunityBtnState.join;

  bool get isManageButton => btnState.value == MyCommunityBtnState.manage;

  bool get isVisitButton => btnState.value == MyCommunityBtnState.visit;

  // ------------------------------------------------------------
  // LIFECYCLE
  // ------------------------------------------------------------

  @override
  void onInit() {
    btnState = initialBtnState.obs;

    print('initialBtnState: ${btnState.value.name}');

    isAlreadyMember_ = (initialBtnState != MyCommunityBtnState.join).obs;

    print('communityItemId: $communityItemId');

    getCommunityDetail();

    super.onInit();
  }

  @override
  void onClose() {
    postCtrl.dispose();
    searchFocus.dispose();

    super.onClose();
  }

  // ------------------------------------------------------------
  // COMMON HELPERS
  // ------------------------------------------------------------

  void clearAll() {
    postCtrl.clear();
  }

  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ------------------------------------------------------------
  // GET COMMUNITY DETAIL
  // ------------------------------------------------------------
  final state = UIState.loading.obs;
  final errorMessage = ''.obs;
  Future<void> getCommunityDetail({String? communityIdForRefresh}) async {
    if (isLoading_.value) return;

    isLoading_.value = true;
    state.value = UIState.loading;
    errorMessage.value = '';

    try {
      final data = await CommunityDetailService().fetchCommunityDetail(
        communityItemId: communityIdForRefresh ?? communityItemId,
      );

      if (data != null) {
        communityItemDetail.value = data;

        PostActionController.to.initializeFromPosts(data.allPost ?? []);

        for (final post in data.allPost ?? []) {
          print('post id: ${post.id}');
        }

        state.value = UIState.data;
      } else {
        state.value = UIState.empty;
      }
    } catch (e, s) {
      print('Error fetching Community Detail: $e, stackTrace: $s');

      errorMessage.value = 'Failed to load community details.';
      state.value = UIState.error;
    } finally {
      isLoading_.value = false;
      unFocusAll();
    }
  }
  // ------------------------------------------------------------
  // REFRESH
  // ------------------------------------------------------------

  Future<void> onRefresh() async {
    await getCommunityDetail();
  }

  // ------------------------------------------------------------
  // COMMUNITY GUIDELINE
  // ------------------------------------------------------------

  void onTapCommunityInfo() {
    if (!showCommunityGuidelineButton) return;

    communityGuidlineDialog(
      isLoading: false,
      onTapAction: () async {},
      hasButton: false,
    );
  }

  // ------------------------------------------------------------
  // MANAGE COMMUNITY
  // ------------------------------------------------------------

  void onTapManageCommunity() {
    if (!isManageButton) return;

    Get.toNamed(
      RoutePaths.manageCommunity,
      arguments: CreateCommunityArgModel(
        communityImg: communityImage,
        communityName: communityName,
        communityId: communityId,
        isEdit: true,
      ),
    );
  }

  // ------------------------------------------------------------
  // COMMUNITY JOIN / MANAGE BUTTON
  // ------------------------------------------------------------

  void onTapJoinButton() {
    if (isManageButton) {
      onTapManageCommunity();
      return;
    }

    if (isJoinButton) {
      _showJoinGuideline();
    }
  }

  void _showJoinGuideline() {
    communityGuidlineDialog(
      isLoading: isJoinLoading.value,
      onTapAction: () async {
        Get.back();

        final success = await joinCommunity(communityItemId: communityId);

        if (success) {
          Get.toNamed(
            RoutePaths.communityDetail,
            arguments: {
              'btnState': MyCommunityBtnState.visit,
              'communityItemId': communityId,
            },
          );
        }
      },
    );
  }

  // ------------------------------------------------------------
  // JOIN COMMUNITY
  // ------------------------------------------------------------

  final isJoinLoading = false.obs;

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
      print('Community Join error: $e');

      return false;
    } finally {
      isJoinLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // CREATE POST / WRITE SOMETHING
  // ------------------------------------------------------------

  void onTapWriteSomething() {
    Get.toNamed(RoutePaths.postInCommunity, arguments: communityId);
  }

  // ------------------------------------------------------------
  // UI STATE
  // ------------------------------------------------------------

  UIState get detailUIState => getUIStateDetail(isLoading: isLoading_.value);

  UIState get postsUIState =>
      getUIStateList(isLoading: isLoading_.value, list: posts);

  // ------------------------------------------------------------
  // POST ACTION BRIDGE
  // ------------------------------------------------------------

  Future<void> toggleLikeApi(String postId, String likerName) async {
    await PostActionController.to.toggleLikeApi(
      postId: postId,
      likerName: likerName,
      communityId: communityItemId,
      communityDetail: communityItemDetail,
    );
  }

  Future<void> togglePinApi(String postId) async {
    await PostActionController.to.togglePinApi(postId: postId);
  }

  Future<void> toggleLockApi(String postId) async {
    await PostActionController.to.toggleLockApi(postId: postId);
  }

  Future<void> deletePostApi(String postId) async {
    await PostActionController.to.deletePostApi(postId: postId);
  }

  Future<void> onTapReportContent({required String postId}) async {
    await PostActionController.to.onTapReportContent(postId: postId);
  }
}
