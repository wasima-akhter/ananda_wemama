import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/controller_export.dart';

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

  ScrollController get myCommunityScrlCtrl => ScrollController();
  ScrollController get suggCommunityScrlCtrl => ScrollController();

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

  void onTapItem() {
    Get.toNamed(RoutePaths.communitiyDetail);
  }

  void onTapItemBtn(bool isJoin) {
    if (isJoin) {
      // show popup
      // communityguidline.
      communityGuidlineDialog(
        isLoading: isLoading,
        onTapAction: () async {
          Get.back();
          Get.toNamed(RoutePaths.communitiyDetail);
        },
      );
    } else {
      Get.toNamed(RoutePaths.communitiyDetail);
    }
  }
}
