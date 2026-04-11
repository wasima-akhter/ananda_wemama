import 'package:mama_app/core/components/ui/dialogs/popups.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';

class CommunityController extends GetxController with WidgetsBindingObserver {
  final isKeyboardOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
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
    myCommunityScrlCtrl.dispose(); // ← add
    suggCommunityScrlCtrl.dispose(); // ← add
    manageCommunityScrlCtrl.dispose(); // ← add
    communityScrlCtrl.dispose(); // ← add

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

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final ScrollController myCommunityScrlCtrl = ScrollController();
  final ScrollController manageCommunityScrlCtrl = ScrollController();
  final ScrollController suggCommunityScrlCtrl = ScrollController();
  final ScrollController communityScrlCtrl = ScrollController();

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

  void onTapItemBtn(MyCommunityBtnState btnState) {
    if (btnState == MyCommunityBtnState.join) {
      communityGuidlineDialog(
        isLoading: isLoading,
        onTapAction: () async {
          Get.back();
          Get.toNamed(
            RoutePaths.communityDetail,
            arguments: {
              'btnState': MyCommunityBtnState.join,
              'isAlreadyMember': true, // ← came via join button = now member
            },
          );
        },
      );
    } else if (btnState == MyCommunityBtnState.manage) {
      Get.toNamed(
        RoutePaths.communityDetail,
        arguments: {'btnState': MyCommunityBtnState.manage, 'isAlreadyMember': true},
      );
    } else if (btnState == MyCommunityBtnState.visit) {
      Get.toNamed(
        RoutePaths.communityDetail,
        arguments: {
          'btnState': MyCommunityBtnState.visit,
          'isAlreadyMember': false, // ← just visiting, not member
        },
      );
    }
  }

  // ← tapping the item row (not the button) = just viewing
  void onTapItem(MyCommunityBtnState btnState) {
    Get.toNamed(
      RoutePaths.communityDetail,
      arguments: {
        'btnState': btnState,
        'isAlreadyMember': false, // ← came via item tap = not joined yet
      },
    );
  }
}
