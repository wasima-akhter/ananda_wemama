import 'dart:async';

import 'package:mama_app/core/utils/extension/string_extension.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
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
  Worker? _tabWorker;
  /*
  @override
  void onInit() {
    super.onInit();

    final nav = Get.find<MainNavController>();

    _tabWorker = ever(nav.currentIndex, (index) {
      // chat tab index
      if (index == 1) {
        log("🔄 Chat tab opened");

        // getChatList(forceRefresh: true);
      }
    });

    // ✅ Auto-retry when socket reconnects

    if (Get.isRegistered<SocketStatusController>()) {
      ever(Get.find<SocketStatusController>().status, (status) {
        if (status == SocketStatus.connected) {
          log("🔌 Socket reconnected — refreshing chat list");
          getChatList(forceRefresh: true);
        }
      });
    }
  }

  @override
  void onClose() {
    _tabWorker?.dispose();

    searchController.dispose();
    searchFocus.dispose();

    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();

    // Force refresh every time screen opens
    getChatList(forceRefresh: true);
  }
*/
  bool _isFetchingChatList = false; // ✅ prevents overlapping calls
  @override
  void onInit() {
    super.onInit();

    final nav = Get.find<MainNavController>();

    _tabWorker = ever(nav.currentIndex, (index) {
      if (index == 1) {
        log("🔄 Chat tab opened");
        // ✅ Only fetch if list is empty — don't re-fetch on every tab switch
        if (realChatList.isEmpty) {
          getChatList(forceRefresh: true);
        }
      }
    });

    // ✅ Re-fetch on socket connect/reconnect
    _socketConnectedSub = socket.onConnected.listen((_) {
      log("🔌 Socket connected — fetching chat list");
      getChatList(forceRefresh: true);
    });
  }

  @override
  void onReady() {
    super.onReady();
    // ✅ Only if socket already connected AND list is empty
    // _socketConnectedSub handles it if socket connects later
    if (socket.isConnected && realChatList.isEmpty) {
      getChatList(forceRefresh: true);
    }
  }

  void clearAll() => searchController.clear();
  void unFocusAll() {
    searchFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void clearData() {
    realChatList.clear();
    searchedChatList.clear();
    isLoading_.value = false;
  }
  // ── State ────────────────────────────────────────────────────────────────

  final isLoading_ = true.obs; // ← start true, data hasn't arrived yet
  bool get isLoading => isLoading_.value;

  final realChatList = <ChatListItemModel>[].obs;

  // ── Called by SocketService when data arrives ────────────────────────────
  Completer<void>? _chatListCompleter;

  // ── Called by SocketService when data arrives ────────────────────────────

  void updateChatList(List<ChatListItemModel> list) {
    // Deduplicate by id — last occurrence wins (most recent data)
    final seen = <String>{};
    final deduped = list.reversed
        .where((e) => e.id != null && seen.add(e.id!))
        .toList()
        .reversed
        .toList();

    realChatList.assignAll(deduped);
    isLoading_.value = false;
    _isFetchingChatList = false; // ✅ unlock early on success

    if (!(_chatListCompleter?.isCompleted ?? true)) {
      _chatListCompleter?.complete();
    }
  }

  // ── Emit ─────────────────────────────────────────────────────────────────
  /*
  Future<void> getChatList({bool forceRefresh = true}) async {
    if (forceRefresh) {
      realChatList.clear();
    }

    isLoading_.value = true;

    _chatListCompleter = Completer<void>();

    try {
      socket.emit(SocketEvents.getChatList, {});

      await _chatListCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          log("⚠️ getChatList timeout — no socket response");
        },
      );
    } catch (e, stack) {
      log("❌ Error fetching chat list: $e");
      log("STACK: $stack");
    } finally {
      isLoading_.value = false;
    }
  }
*/
  StreamSubscription? _socketConnectedSub;

  Future<void> getChatList({bool forceRefresh = true}) async {
    // ✅ Guard against overlapping calls
    if (_isFetchingChatList) {
      log("⏭️ getChatList already in progress — skipping");
      return;
    }
    if (forceRefresh) realChatList.clear();

    // ✅ If not connected, wait up to 10s for connection instead of emitting into void
    if (!socket.isConnected) {
      log("⏳ getChatList — waiting for socket to connect...");
      try {
        await socket.onConnected.first.timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Socket never connected"),
        );
      } catch (e) {
        log("🚫 getChatList aborted — socket not available: $e");

        return;
      } finally {
        _isFetchingChatList = false; // 🔓 unlock
        isLoading_.value = false;
      }
    }

    isLoading_.value = true;
    _isFetchingChatList = true; // 🔒 lock
    _chatListCompleter = Completer<void>();

    try {
      socket.emit(SocketEvents.getChatList, {});

      await _chatListCompleter!.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => log("⚠️ getChatList — no response in 8s"),
      );
    } catch (e) {
      log("❌ getChatList error: $e");
    } finally {
      isLoading_.value = false;
    }
  }
  //

  void updateLastMessage({
    required String chatId,
    required String lastMessage,
    required DateTime time,
  }) {
    final index = realChatList.indexWhere((e) => e.id == chatId);
    if (index == -1) return;

    realChatList[index] = realChatList[index].copyWith(
      lastMessage: lastMessage,
      time: time,
    );

    // Move this chat to the top
    final updated = realChatList.removeAt(index);
    realChatList.insert(0, updated);
    realChatList.refresh();
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
      final data = await service.fetchSearchedChatList(
        searchTxt: searchController.text.trim(),
      );

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
  void updateChatBlockStatus({
    required String chatId,
    required bool isBlocked,
  }) {
    final index = realChatList.indexWhere((e) => e.id == chatId);

    if (index == -1) return;

    realChatList[index] = realChatList[index].copyWith(isBlocked: isBlocked);
    realChatList.refresh();

    final searchIndex = searchedChatList.indexWhere((e) => e.id == chatId);
    if (searchIndex != -1) {
      searchedChatList[searchIndex] = searchedChatList[searchIndex].copyWith(
        isBlocked: isBlocked,
      );

      searchedChatList.refresh();
    }
  }

  //
}
