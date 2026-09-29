import 'dart:async';

import 'package:we_mama/core/utils/extension/string_extension.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../model/chat_list_item_model.dart';
import '../service/chat_service.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find<ChatController>();
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  final chatScrollCtrl = ScrollController();
  Worker? _tabWorker;

  bool _isFetchingChatList = false;

  // ── Reconnect management ─────────────────────────────────────────────────
  StreamSubscription? _socketConnectedSub;
  StreamSubscription? _socketDisconnectedSub;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  static const _maxReconnectDelay = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();

    final nav = Get.find<MainNavController>();

    _tabWorker = ever(nav.currentIndex, (index) {
      if (index == 1) {
        print("🔄 Chat tab opened");
        if (realChatList.isEmpty) {
          getChatList(forceRefresh: true);
        }
        // ✅ Also use tab focus as a nudge to reconnect if we're dead
        if (!socket.isConnected) {
          _scheduleReconnect(immediate: true);
        }
      }
    });

    // ✅ On connect: refresh data + reset backoff
    _socketConnectedSub = socket.onConnected.listen((_) {
      print("🔌 Socket connected — fetching chat list");
      _reconnectAttempt = 0;
      _reconnectTimer?.cancel();
      getChatList(forceRefresh: true);
    });

    // ✅ On disconnect: actively try to reconnect instead of just waiting
    _socketDisconnectedSub = socket.onDisconnected.listen((_) {
      print("🔌 Socket disconnected — scheduling reconnect");
      _scheduleReconnect();
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (socket.isConnected && realChatList.isEmpty) {
      getChatList(forceRefresh: true);
    } else if (!socket.isConnected) {
      _scheduleReconnect(immediate: true);
    }
  }

  @override
  void onClose() {
    _tabWorker?.dispose();
    _socketConnectedSub?.cancel();
    _socketDisconnectedSub?.cancel();
    _reconnectTimer?.cancel();

    searchController.dispose();
    searchFocus.dispose();

    super.onClose();
  }

  /// Attempts to reconnect with exponential backoff (capped).
  /// `immediate: true` skips the delay for the first attempt (e.g. app
  /// coming to foreground / tab tapped).
  void _scheduleReconnect({bool immediate = false}) {
    if (socket.isConnected) return;

    _reconnectTimer?.cancel();

    final delay = immediate
        ? Duration.zero
        : Duration(
            seconds: (2 << _reconnectAttempt).clamp(
              1,
              _maxReconnectDelay.inSeconds,
            ),
          );

    _reconnectTimer = Timer(delay, () async {
      if (socket.isConnected) return; // already recovered

      print("🔁 Attempting socket reconnect (try ${_reconnectAttempt + 1})");
      _reconnectAttempt++;

      try {
        socket.disconnectSocket(); // clean slate before retry
        await socket.connectSocket();
      } catch (e) {
        print("❌ Reconnect attempt failed: $e");
      }

      // If still not connected after this attempt, queue the next one
      if (!socket.isConnected) {
        _scheduleReconnect();
      }
    });
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

  final isLoading_ = true.obs;
  bool get isLoading => isLoading_.value;

  final realChatList = <ChatListItemModel>[].obs;

  Completer<void>? _chatListCompleter;

  void updateChatList(List<ChatListItemModel> list) {
    final seen = <String>{};
    final deduped = list.reversed
        .where((e) => seen.add(e.id))
        .toList()
        .reversed
        .toList();

    realChatList.assignAll(deduped);
    isLoading_.value = false;
    _isFetchingChatList = false;

    if (!(_chatListCompleter?.isCompleted ?? true)) {
      _chatListCompleter?.complete();
    }
  }

  // ── Emit ─────────────────────────────────────────────────────────────────

  Future<void> getChatList({bool forceRefresh = true}) async {
    if (_isFetchingChatList) {
      print("⏭️ getChatList already in progress — skipping");
      return;
    }
    if (forceRefresh) realChatList.clear();

    // ✅ Not connected? Kick off reconnect (not just wait) then give it a window.
    if (!socket.isConnected) {
      print("⏳ getChatList — socket down, triggering reconnect + waiting...");
      _scheduleReconnect(immediate: true);

      try {
        await socket.onConnected.first.timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Socket never connected"),
        );
      } catch (e) {
        print("🚫 getChatList aborted — socket not available: $e");
        // ✅ Don't just give up silently — backoff loop from
        // _scheduleReconnect keeps trying in the background, and will
        // call getChatList again via the onConnected listener once it
        // succeeds. So no further action needed here.
        return;
      } finally {
        isLoading_.value = false;
      }
    }

    isLoading_.value = true;
    _isFetchingChatList = true;
    _chatListCompleter = Completer<void>();

    try {
      socket.emit(SocketEvents.getChatList, {});

      await _chatListCompleter!.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => print("⚠️ getChatList — no response in 8s"),
      );
    } catch (e) {
      print("❌ getChatList error: $e");
    } finally {
      isLoading_.value = false;
      _isFetchingChatList = false; // ✅ was missing here — this was also a
      // latent bug: on timeout/error the lock
      // only got released in updateChatList's
      // success path, so a timed-out call
      // would permanently block all future
      // getChatList() calls until success.
    }
  }

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

    final updated = realChatList.removeAt(index);
    realChatList.insert(0, updated);
    realChatList.refresh();
  }

  final socket = Get.find<SocketService>();

  final showSearchedTag = false.obs;
  final searchedTxt = ''.obs;
  final isSearchLoading_ = false.obs;

  final service = ChatService();
  final searchedChatList = <ChatListItemModel>[].obs;

  Future<void> getSearchedChatList() async {
    print('hit search');
    if (isSearchLoading_.value) return;

    if (searchController.text.trim().isEmpty) {
      Strings.writeSomething.showToast();
      showSearchedTag.value = false;
      return;
    }

    isSearchLoading_.value = true;
    searchedChatList.value = [];

    try {
      final data = await service.fetchSearchedChatList(
        searchTxt: searchController.text.trim(),
      );

      if (data.isNotEmpty) {
        print('get Searched ChatList : $data');
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
}
