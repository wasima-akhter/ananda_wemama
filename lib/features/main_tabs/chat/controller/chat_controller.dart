import 'package:mama_app/core/services/socket/socket_events.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../model/chat_list_item_model.dart';

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

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    getChatList();
  }

  void clearAll() => searchController.clear();
  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ── State ────────────────────────────────────────────────────────────────

  final isLoading_ = true.obs; // ← start true, data hasn't arrived yet
  bool get isLoading => isLoading_.value;

  final realChatList = <ChatListItemModel>[].obs;

  // ── Called by SocketService when data arrives ────────────────────────────

  void updateChatList(List<ChatListItemModel> list) {
    realChatList.assignAll(list);
    isLoading_.value = false; // ← only stop loading when data actually arrives
  }

  // ── Emit ─────────────────────────────────────────────────────────────────

  final socket = Get.find<SocketService>();

  Future<void> getChatList() async {
    if (isLoading_.value && realChatList.isNotEmpty) return; // don't re-fetch if already loading
    isLoading_.value = true;
    try {
      socket.emit(SocketEvents.getChatList, {"receiverId": currentProfileId()});
    } catch (e) {
      print("Error fetching chat list: $e");
      isLoading_.value = false; // ← only false on error, not after emit
    }
  }

  void onTapHandWave() => Get.toNamed(RoutePaths.waveRequest);
}
