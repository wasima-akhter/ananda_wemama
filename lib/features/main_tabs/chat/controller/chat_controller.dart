import '../../../../app/controller_export.dart';

class FakeChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;

  FakeChatModel({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    required this.id,
  });
}

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  var fakeChatList = [
    FakeChatModel(
      id: "1",
      name: "Alice",
      lastMessage: "Hey, how are you?",
      time: "2h ago",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeChatModel(
      id: "2",
      name: "Bob",
      lastMessage: "See you later!",
      time: "4min ago",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeChatModel(
      id: "3",
      name: "Charlie",
      lastMessage: "Thanks for your help!",
      time: "yesterday",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeChatModel(
      id: "4",
      name: "Diana",
      lastMessage: "Let's meet tomorrow.",
      time: "22 Jan 2026",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeChatModel(
      id: "5",
      name: "Eve",
      lastMessage: "Happy birthday!",
      time: "1 Jan 2026",
      imageUrl: Strings.fakeImageUrl,
    ),
  ];
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
}
