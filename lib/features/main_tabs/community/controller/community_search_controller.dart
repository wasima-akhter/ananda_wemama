import 'package:mama_app/core/components/ui/dialogs/popups.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../model/community_item_model.dart';
import '../services/community_service.dart';
import 'community_action_controller.dart';

class CommunitySearchController extends GetxController with WidgetsBindingObserver {
  final isKeyboardOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    getSuggestedCommunityList();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardOpen.value = bottomInset > 0;
  }

  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  final showSearchedTag = false.obs; // ← to control showing searched tag
  final searchedTxt = ''.obs; //

  final selTab = CommunityTab.myCommunities.obs;

  void changeTab(CommunityTab tab) {
    selTab.value = tab;
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    suggCommunityScrlCtrl.dispose(); // ← add
    searchedCommCtrl.dispose(); // ← add

    WidgetsBinding.instance.removeObserver(this);
    unFocusAll();
    super.onClose();
  }

  void clearAll() {
    searchController.clear();
  }

  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  final ScrollController suggCommunityScrlCtrl = ScrollController();
  final ScrollController searchedCommCtrl = ScrollController();

  //
  final service = CommunityService();

  // API loading state
  var isSuggestedCommunityLoading_ = false.obs;
  bool get isSuggestedCommunityLoading => isSuggestedCommunityLoading_.value;

  final suggestedCommunityList = <CommunityItemModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getSuggestedCommunityList() async {
    if (isSuggestedCommunityLoading_.value) return; // Prevent duplicate calls
    isSuggestedCommunityLoading_.value = true;

    try {
      final data = await service.fetchSuggestedCommunityList();

      log('get suggested CommunityList   : $data');
      suggestedCommunityList.value = data;
    } catch (e) {
      log("Error suggested community: $e");
    } finally {
      isSuggestedCommunityLoading_.value = false;

      unFocusAll();
    }
  }

  // API loading state
  var isSearchedCommunityLoading_ = false.obs;
  bool get isSearchedCommunityLoading => isSearchedCommunityLoading_.value;

  final searchedCommunityList = <CommunityItemModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getSearchedCommunityList() async {
    if (isSearchedCommunityLoading_.value) return; // Prevent duplicate calls

    if (searchController.text.isEmpty) return;
    isSearchedCommunityLoading_.value = true;

    try {
      final data = await service.fetchSearchedCommunityList(
        searchTxt: searchController.text.trim(),
      );

      log('get searched CommunityList   : $data');
      searchedCommunityList.value = data;
    } catch (e) {
      log("Error searched community: $e");
    } finally {
      isSearchedCommunityLoading_.value = false;

      unFocusAll();
    }
  }

  //--------------------->
  final actionCtrl = Get.find<CommunityActionController>();

  void onTapItemBtn({required MyCommunityBtnState btnState, required String communityItemId}) {
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

            searchedCommunityList.removeWhere((item) => item.id == communityItemId);
          }
        },
      );
    } else if (btnState == MyCommunityBtnState.manage) {
      Get.toNamed(
        RoutePaths.communityDetail,
        arguments: {'btnState': MyCommunityBtnState.manage, "communityItemId": communityItemId},
      );
    } else if (btnState == MyCommunityBtnState.visit) {
      Get.toNamed(
        RoutePaths.communityDetail,
        arguments: {'btnState': MyCommunityBtnState.visit, "communityItemId": communityItemId},
      );
    }
  }

  // ← tapping the item row (not the button) = just viewing
  void onTapItem({required MyCommunityBtnState btnState, required String communityItemId}) {
    Get.toNamed(
      RoutePaths.communityDetail,
      arguments: {'btnState': btnState, "communityItemId": communityItemId},
    );
  }
}
