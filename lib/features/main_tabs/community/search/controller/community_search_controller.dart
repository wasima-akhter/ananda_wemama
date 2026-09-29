import 'package:we_mama/core/components/ui/dialogs/popups.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../../../../core/utils/paginator/paginator.dart';
import '../../core/controllers_shared/community_action_controller.dart';
import '../../core/models/community_item_model.dart';
import '../../core/services/community_service.dart';
import '../../feed/controller/community_controller.dart';

class CommunitySearchController extends GetxController
    with WidgetsBindingObserver {
  static CommunitySearchController get to => Get.find();
  // ─────────────────────────────────────────────
  // Paginators
  // ─────────────────────────────────────────────

  late final Paginator<CommunityItemModel> suggestedPaginator;
  late final Paginator<CommunityItemModel> searchedPaginator;

  RxList<CommunityItemModel> get suggestedCommunityList =>
      suggestedPaginator.items;

  RxList<CommunityItemModel> get searchedCommunityList =>
      searchedPaginator.items;

  RxBool get isSuggestedCommunityLoading_ => suggestedPaginator.isLoading;
  RxBool get isSearchedCommunityLoading_ => searchedPaginator.isLoading;

  bool get isSuggestedCommunityLoading => suggestedPaginator.isLoading.value;

  bool get isSearchedCommunityLoading => searchedPaginator.isLoading.value;

  // ─────────────────────────────────────────────
  // UI / state
  // ─────────────────────────────────────────────

  final isKeyboardOpen = false.obs;

  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  final showSearchedTag = false.obs;
  final searchedTxt = ''.obs;

  final selTab = CommunityTab.myCommunities.obs;

  void changeTab(CommunityTab tab) => selTab.value = tab;

  final ScrollController suggCommunityScrlCtrl = ScrollController();
  final ScrollController searchedCommCtrl = ScrollController();

  final actionCtrl = Get.find<CommunityActionController>();

  // ─────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    if ((getToken ?? '').isEmpty) {
      print("CommunitySearchController: no token, skipping fetch");
      return;
    }

    suggestedPaginator = Paginator<CommunityItemModel>(
      // limit: 1,
      fetchPage: (page, limit) =>
          service.fetchSuggestedCommunityListPaged(page: page, limit: limit),
    );

    searchedPaginator = Paginator<CommunityItemModel>(
      fetchPage: (page, limit) => service.fetchSearchedCommunityListPaged(
        searchTxt: searchController.text.trim(),
        page: page,
        limit: limit,
      ),
    );

    // getSuggestedCommunityList();
  }

  // ─────────────────────────────────────────────
  // Fetch APIs (Paginator-based)
  // ─────────────────────────────────────────────

  Future<void> getSuggestedCommunityList() => suggestedPaginator.loadInitial();

  Future<void> loadMoreSuggested() => suggestedPaginator.loadMore();

  Future<void> getSearchedCommunityList() async {
    searchedTxt.value = searchController.text.trim();

    if (searchedTxt.value.isEmpty) {
      showSearchedTag.value = false;
      return;
    }
    _resetSearchedPaginator();
    await searchedPaginator.loadInitial();
    showSearchedTag.value = true;
  }

  void _resetSearchedPaginator() {
    searchedPaginator.items.clear();
  }

  Future<void> loadMoreSearched() => searchedPaginator.loadMore();

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardOpen.value = bottomInset > 0;
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();

    suggCommunityScrlCtrl.dispose();
    searchedCommCtrl.dispose();

    suggestedPaginator.dispose();
    searchedPaginator.dispose();

    WidgetsBinding.instance.removeObserver(this);

    unFocusAll();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────

  void clearAll() => searchController.clear();

  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void resetSearchState() {
    showSearchedTag.value = false;
    searchedTxt.value = '';

    searchController.clear();
    searchedCommunityList.clear();

    unFocusAll();
  }

  //
  final service = CommunityService();

  void onTapItemBtn({
    required MyCommunityBtnState btnState,
    required String communityItemId,
  }) {
    if (btnState == MyCommunityBtnState.join) {
      communityGuidlineDialog(
        isLoading: actionCtrl.isJoinLoading.value,
        onTapAction: () async {
          Get.back();

          final success = await actionCtrl.joinCommunity(communityItemId);

          if (success) {
            Get.toNamed(
              RoutePaths.communityDetail,
              arguments: {
                "btnState": MyCommunityBtnState.visit,
                "communityItemId": communityItemId,
              },
            );

            searchedCommunityList.removeWhere(
              (item) => item.id == communityItemId,
            );
            suggestedCommunityList.removeWhere(
              (item) => item.id == communityItemId,
            );
            if (Get.isRegistered<CommunityController>()) {
              CommunityController.to.getMyCommunityList();
            }
          }
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

  // ← tapping the item row (not the button) = just viewing
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
