import 'package:mama_app/core/services/socket/socket_events.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../model/chat_list_item_model.dart';
import '../service/chat_service.dart';

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

  final chatScrollCtrl = ScrollController();

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

  /// --------------  Search Chat List -----//
  final showSearchedTag = false.obs;
  final searchedTxt = ''.obs;

  final isSearchLoading_ = false.obs; // ← start true, data hasn't arrived yet

  final service = ChatService();
  final searchedChatList = <ChatListItemModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getSearchedChatList() async {
    debugPrint('hit search');
    if (isSearchLoading_.value) return; // Prevent duplicate calls

    if (searchController.text.trim().isEmpty) {
      Strings.writeSomething.showToast();
      return;
    }

    isSearchLoading_.value = true;
    searchedChatList.value = [];

    try {
      final data = await service.fetchSearchedChatList(searchTxt: searchController.text.trim());

      if (data.isNotEmpty) {
        debugPrint('get Searched ChatList : $data');
        searchedChatList.value = data;
      }
    } catch (e) {
      print("Error fetching Searched ChatList : $e");
    } finally {
      isSearchLoading_.value = false;
      unFocusAll();
      clearAll();
    }
  }

  void onTapHandWave() => Get.toNamed(RoutePaths.waveRequest);
}
