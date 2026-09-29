import 'package:we_mama/core/components/ui/dialogs/popups.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../../../../core/utils/paginator/paginator.dart';
import '../../core/models/community_item_model.dart';
import '../../core/services/community_service.dart';

class CommunityController extends GetxController {
  static CommunityController get to => Get.find<CommunityController>();

  final service = CommunityService();

  // ── Paginators ──────────────────────────────────────────────────────────

  late final Paginator<CommunityItemModel> joinedPaginator;
  late final Paginator<CommunityItemModel> managedPaginator;

  // Convenience getters — keep old call sites working with minimal change
  RxList<CommunityItemModel> get joinedCommunityList => joinedPaginator.items;
  RxList<CommunityItemModel> get managedCommunityList => managedPaginator.items;

  RxBool get isJoinedCommunityLoading_ => joinedPaginator.isLoading;
  RxBool get isManagedCommunityLoading_ => managedPaginator.isLoading;

  bool get isJoinedCommunityLoading => joinedPaginator.isLoading.value;
  bool get isMyCommunityLoading => managedPaginator.isLoading.value;

  bool _joinedLoaded = false;
  bool _managedLoaded = false;

  Future<void> refreshMyCommunityList() async {
    _joinedLoaded = true;
    await joinedPaginator.loadInitial();
  }

  Future<void> refreshManagedCommunityList() async {
    _managedLoaded = true;
    await managedPaginator.loadInitial();
  }

  Future<void> refreshCurrentTab() async {
    if (selTab.value == CommunityTab.myCommunities) {
      if (!_joinedLoaded) {
        await refreshMyCommunityList();
      }
    } else {
      if (!_managedLoaded) {
        await refreshManagedCommunityList();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();

    joinedPaginator = Paginator<CommunityItemModel>(
      fetchPage: (page, limit) =>
          service.fetchJoinedCommunityListPaged(page: page, limit: limit),
    );

    managedPaginator = Paginator<CommunityItemModel>(
      fetchPage: (page, limit) =>
          service.fetchManagedCommunityListPaged(page: page, limit: limit),
    );

    if ((getToken ?? '').isEmpty) {
      print("CommunityController: no token, skipping initial fetch");
      return;
    }
  }

  final showSearchedTag = false.obs;
  final searchedTxt = ''.obs;
  final selTab = CommunityTab.myCommunities.obs;

  void changeTab(CommunityTab tab) {
    selTab.value = tab;
    refreshCurrentTab();
  }

  @override
  void onClose() {
    myCommunityScrlCtrl.dispose();
    manageCommunityScrlCtrl.dispose();

    joinedPaginator.dispose();
    managedPaginator.dispose();

    unFocusAll();
    super.onClose();
  }

  void clearAll() {}

  void unFocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  final ScrollController myCommunityScrlCtrl = ScrollController();
  final ScrollController manageCommunityScrlCtrl = ScrollController();

  // ── Managed communities ────────────────────────────────────────────────

  Future<void> getManagedCommunityList() => managedPaginator.loadInitial();
  Future<void> loadMoreManagedCommunity() => managedPaginator.loadMore();

  // ── Joined ("My") communities ─────────────────────────────────────────

  Future<void> getMyCommunityList() => joinedPaginator.loadInitial();
  Future<void> loadMoreMyCommunity() => joinedPaginator.loadMore();

  // ── Actions ───────────────────────────────────────────────────────────

  void onTapItemBtn({
    required MyCommunityBtnState btnState,
    required String communityItemId,
  }) {
    if (btnState == MyCommunityBtnState.join) {
      communityGuidlineDialog(
        isLoading: false,
        onTapAction: () async {
          Get.back();
          Get.toNamed(
            RoutePaths.communityDetail,
            arguments: {
              "btnState": MyCommunityBtnState.join,
              "communityItemId": communityItemId,
            },
          );
        },
      );
    } else if (btnState == MyCommunityBtnState.manage) {
      Get.toNamed(
        RoutePaths.communityDetail,
        arguments: {
          'btnState': MyCommunityBtnState.manage,
          "communityItemId": communityItemId,
        },
      );
    } else if (btnState == MyCommunityBtnState.visit) {
      Get.toNamed(
        RoutePaths.communityDetail,
        arguments: {
          'btnState': MyCommunityBtnState.visit,
          "communityItemId": communityItemId,
        },
      );
    }
  }

  void onTapItem({
    required MyCommunityBtnState btnState,
    required String communityItemId,
  }) {
    Get.toNamed(
      RoutePaths.communityDetail,
      arguments: {'btnState': btnState, "communityItemId": communityItemId},
    );
  }
}
