import 'package:mama_app/core/components/ui/dialogs/popups.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../model/community_item_model.dart';
import '../services/community_service.dart';

class CommunityController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    getMyCommunityList();
    getManagedCommunityList();
  }

  final showSearchedTag = false.obs; // ← to control showing searched tag
  final searchedTxt = ''.obs; //

  final selTab = CommunityTab.myCommunities.obs;

  void changeTab(CommunityTab tab) {
    selTab.value = tab;
  }

  @override
  void onClose() {
    myCommunityScrlCtrl.dispose();
    manageCommunityScrlCtrl.dispose();

    unFocusAll();
    super.onClose();
  }

  void clearAll() {}

  void unFocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  final ScrollController myCommunityScrlCtrl = ScrollController();
  final ScrollController manageCommunityScrlCtrl = ScrollController();

  //
  final service = CommunityService();

  // API loading state
  var isManagedCommunityLoading_ = false.obs;
  bool get isMyCommunityLoading => isManagedCommunityLoading_.value;

  final managedCommunityList = <CommunityItemModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getManagedCommunityList() async {
    if (isManagedCommunityLoading_.value) return; // Prevent duplicate calls
    isManagedCommunityLoading_.value = true;

    try {
      final data = await service.fetchManagedCommunityList();

      log('getMyCommunityList   : $data');
      managedCommunityList.value = data;
    } catch (e) {
      log("Error my community: $e");
    } finally {
      isManagedCommunityLoading_.value = false;

      unFocusAll();
    }
  }

  // API loading state
  var isJoinedCommunityLoading_ = false.obs;
  bool get isJoinedCommunityLoading => isJoinedCommunityLoading_.value;

  final joinedCommunityList = <CommunityItemModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getMyCommunityList() async {
    if (isJoinedCommunityLoading_.value) return; // Prevent duplicate calls
    isJoinedCommunityLoading_.value = true;

    try {
      final data = await service.fetchJoinedCommunityList();

      log('get Joined CommunityList   : $data');
      joinedCommunityList.value = data;
    } catch (e) {
      log("Error Joined community: $e");
    } finally {
      isJoinedCommunityLoading_.value = false;

      unFocusAll();
    }
  }

  void onTapItemBtn({required MyCommunityBtnState btnState, required String communityItemId}) {
    if (btnState == MyCommunityBtnState.join) {
      communityGuidlineDialog(
        isLoading: false,
        onTapAction: () async {
          Get.back();
          Get.toNamed(
            RoutePaths.communityDetail,
            arguments: {"btnState": MyCommunityBtnState.join, "communityItemId": communityItemId},
          );
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
