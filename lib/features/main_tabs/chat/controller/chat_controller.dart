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

  // ─────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final realChatList = <ChatListItemModel>[].obs;

  // ─────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────

  // ── List management ───────────────────────────────────────────────────────
  void updateChatList(List<ChatListItemModel> list) {
    if (isLoading_.value) return;
    isLoading_.value = true;
    realChatList.assignAll(list);
    isLoading_.value = false;
  }

  final socket = Get.find<SocketService>();
  Future<void> getChatList() async {
    if (isLoading_.value) return;
    isLoading_.value = true;
    try {
      getChatListEmit(currentProfileId());
    } catch (e) {
      print("Error fetching chat list: $e");
    } finally {
      isLoading_.value = false;
      unFocusAll();
    }
  }

  void getChatListEmit(String userOwnId) {
    socket.emit(SocketEvents.getChatList, {"receiverId": userOwnId});
  }

  void onTapHandWave() => Get.toNamed(RoutePaths.waveRequest);
}
