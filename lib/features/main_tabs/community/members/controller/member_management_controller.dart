import '../../../../../app/helper_widgets_export.dart';

class MemberManagementController extends GetxController {
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

  void clearAll() {}

  void unFocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // API loading state
  var isUnblockLoading = false.obs;
  Future<void> onTapBlocked() async {
    if (isUnblockLoading.value) return; // Prevent duplicate calls
    isUnblockLoading.value = true;

    try {
      // final data = await ChatService().fetchChatList(

      // );

      // if (data != null) {

      // }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isUnblockLoading.value = false;

      unFocusAll();
    }
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// Fetch the latest  data from API
  Future<void> getBlockedUserList() async {
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
