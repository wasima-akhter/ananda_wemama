import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_service.dart';

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
  // ─────────────────────────────────────────────
  // Search
  // ─────────────────────────────────────────────

  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    super.onClose();
  }

  void clearAll() => searchController.clear();

  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ─────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final fakeChatList = <FakeChatModel>[
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

  // ─────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────
  final socket = Get.find<SocketService>();
  Future<void> getChatList() async {
    if (isLoading_.value) return;
    isLoading_.value = true;

    try {
      // TODO: replace with real API call
      // final data = await ChatService().fetchChatList();
      // if (data != null) { ... }

      var messages = [].obs;

      @override
      void onInit() {
        super.onInit();

        socket.on("receive_message", (data) {
          print("📩 New Message: $data");
          messages.add(data);
        });
      }
    } finally {
      isLoading_.value = false;
      unFocusAll();
    }
  }

  void sendMessage(String message, String receiverId) {
    socket.emit("send_message", {"message": message, "receiverId": receiverId});
  }

  void onTapHandWave() => Get.toNamed(RoutePaths.waveRequest);
}
