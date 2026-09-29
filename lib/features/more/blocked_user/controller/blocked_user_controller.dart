import 'package:we_mama/features/more/blocked_user/model/blocked_user_model.dart';

import '../../../../app/helper_widgets_export.dart';
import '../service/blocked_user_service.dart';

class BlockedUserController extends GetxController {
  var fakeBlockedUser = [
    FakeBlockedUserModel(
      id: "1",
      name: "Alice",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeBlockedUserModel(id: "2", name: "Bob", imageUrl: Strings.fakeImageUrl),
    FakeBlockedUserModel(
      id: "3",
      name: "Charlie",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeBlockedUserModel(
      id: "4",
      name: "Diana",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeBlockedUserModel(id: "5", name: "Eve", imageUrl: Strings.fakeImageUrl),
  ];

  @override
  void onInit() {
    getBlockedUserList();
    super.onInit();
  }

  void clearAll() {}

  void unFocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // API loading state
  var isUnblockLoading = false.obs;
  Future<void> onTapBlocked({required String userId}) async {
    if (isUnblockLoading.value) return;
    isUnblockLoading.value = true;
    try {
      await BlockedUserService().unblockUser(userId: userId);
      blockedUserList.removeWhere(
        (e) => e.id == userId,
      ); // ✅ remove from list on success
    } catch (e) {
      print("Error unblocking user: $e");
    } finally {
      isUnblockLoading.value = false;
    }
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final blockedUserList = <BlockedUserDataModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getBlockedUserList() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      final data = await BlockedUserService().fetchBlockedUsers();

      if (data.isNotEmpty) {
        blockedUserList.value = data;
      }
    } catch (e) {
      print("Error fetchBlockedUsers: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }
}

class FakeBlockedUserModel {
  final String id;
  final String name;
  final String imageUrl;

  FakeBlockedUserModel({
    required this.name,
    required this.imageUrl,
    required this.id,
  });
}
