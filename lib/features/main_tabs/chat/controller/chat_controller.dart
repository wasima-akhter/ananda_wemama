import 'dart:async';

import 'package:mama_app/core/services/socket/socket_events.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../model/chat_list_item_model.dart';
import '../service/chat_service.dart';

class FakeChatModel {
  final String id;
  final String name;
  final bool isblocked;
  final String lastMessage;
  final String time;
  final String imageUrl;

  FakeChatModel({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    required this.id,
    required this.isblocked,
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
  Completer<void>? _chatListCompleter;

  // ── Called by SocketService when data arrives ────────────────────────────

  void updateChatList(List<ChatListItemModel> list) {
    realChatList.assignAll(list);
    isLoading_.value = false;

    // ✅ Complete the pending refresh/load completer
    if (!(_chatListCompleter?.isCompleted ?? true)) {
      _chatListCompleter?.complete();
    }
  }

  // ── Emit ─────────────────────────────────────────────────────────────────

  Future<void> getChatList() async {
    // Only show full loading spinner when list is empty
    if (realChatList.isEmpty) {
      isLoading_.value = true;
    }

    // ✅ Create a new completer so callers can await the socket response
    _chatListCompleter = Completer<void>();

    try {
      socket.emit(SocketEvents.getChatList, {"receiverId": currentProfileId()});

      // Wait for updateChatList() to complete the completer (with timeout)
      await _chatListCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          log("⚠️ getChatList timeout — no socket response");
        },
      );
    } catch (e) {
      log("Error fetching chat list: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  // ── Emit ─────────────────────────────────────────────────────────────────

  final socket = Get.find<SocketService>();

  /// --------------  Search Chat List -----//
  final showSearchedTag = false.obs;
  final searchedTxt = ''.obs;

  final isSearchLoading_ = false.obs; // ← start true, data hasn't arrived yet

  final service = ChatService();
  final searchedChatList = <ChatListItemModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getSearchedChatList() async {
    log('hit search');
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
        log('get Searched ChatList : $data');
        searchedChatList.value = data;
      }
    } catch (e) {
      log("Error fetching Searched ChatList : $e");
    } finally {
      isSearchLoading_.value = false;
      unFocusAll();
      clearAll();
    }
  }

  void onTapHandWave() => Get.toNamed(RoutePaths.waveRequest);

  // -------------update
  void updateChatBlockStatus({required String chatId, required bool isBlocked}) {
    final index = realChatList.indexWhere((e) => e.id == chatId);

    if (index == -1) return;

    realChatList[index] = realChatList[index].copyWith(isBlocked: isBlocked);
    realChatList.refresh();

    final searchIndex = searchedChatList.indexWhere((e) => e.id == chatId);
    if (searchIndex != -1) {
      searchedChatList[searchIndex] = searchedChatList[searchIndex].copyWith(isBlocked: isBlocked);

      searchedChatList.refresh();
    }
  }
}
