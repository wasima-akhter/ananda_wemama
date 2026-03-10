import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';

class CommunityController extends GetxController {
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    myCommunityScrlCtrl.dispose(); // ← add
    suggCommunityScrlCtrl.dispose(); // ← add
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
  final ScrollController suggCommunityScrlCtrl = ScrollController();

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
