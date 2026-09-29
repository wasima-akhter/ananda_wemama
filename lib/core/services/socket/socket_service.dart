import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:we_mama/core/config/app_info.dart';
import 'package:we_mama/core/services/socket/socket_listener_registry.dart';

import '../../../app/service_export.dart';
import 'socket_events.dart';
import 'socket_status_controller.dart';

class SocketService extends GetxService {
  IO.Socket? _socket;

  Completer<void>? _connectCompleter;

  bool get isConnected => _socket?.connected ?? false;

  // ── onInit: nothing socket-related here — socket doesn't exist yet ─────────

  // ═══════════════════════════════════════════════════════════════════════════
  // CONNECT
  // ═══════════════════════════════════════════════════════════════════════════

  void _removeAllListeners() {
    final events = [
      SocketEvents.sendConversationRequest,
      SocketEvents.newConversationRequest,
      SocketEvents.newNotification,
      SocketEvents.conversationRequests,
      SocketEvents.conversationAccepted,
      SocketEvents.conversationRejected,
      SocketEvents.chatList,
      SocketEvents.messages,
      SocketEvents.newMessage,
    ];
    _socket!.off(SocketEvents.chatList);
    _socket!.off(SocketEvents.messages);
    _socket!.off(SocketEvents.newMessage);
    _socket!.off(SocketEvents.newNotification);
    _socket!.off(SocketEvents.newConversationRequest);
    _socket!.off(SocketEvents.sendConversationRequest);
    _socket!.off(SocketEvents.conversationRequests);
    _socket!.off(SocketEvents.conversationAccepted);
    _socket!.off(SocketEvents.conversationRejected);

    for (final event in events) {
      _socket?.off(event);
    }
  }

  Future<void> connectSocket() async {
    _connectCompleter = Completer<void>();

    try {
      if (_socket != null) {
        _removeAllListeners();
        _socket?.clearListeners();
        _socket?.disconnect();
        _socket?.dispose();
        _socket?.destroy();
        _socket = null;
      }

      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': getToken}) // ✅ picks up NEW user's token
            .disableAutoConnect()
            .enableForceNew()
            .build(),
      );

      _socket!.onConnect((_) {
        print("✅ Socket Connected: ${_socket!.id}");
        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.complete();
        }

        // ✅ broadcast on every connect (including reconnects)
        _onConnectedController.add(null);
      });

      _socket!.onConnectError((err) {
        print("❌ Socket error: $err");
        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.completeError(err);
        }
      });

      // ✅ NEW — fires whenever the transport drops, for any reason:
      // network loss, server restart, app backgrounded, etc.
      _socket!.onDisconnect((reason) {
        print("🔌 Socket Disconnected: $reason");

        if (_intentionalDisconnect) {
          _intentionalDisconnect = false; // reset for next time
          return; // don't tell listeners to reconnect — this was on purpose
        }

        _onDisconnectedController.add(null);
      });

      _registerListeners(); // registers fresh on the new socket instance

      _socket!.connect();

      return _connectCompleter!.future;
    } catch (e) {
      print("Socket connect crashed: $e");
      if (!(_connectCompleter?.isCompleted ?? true)) {
        _connectCompleter?.complete();
      }
    }
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // LISTENERS — registered once per connectSocket() call
  // ═══════════════════════════════════════════════════════════════════════════

  void _registerListeners() {
    //
    //
    _registerRetryListeners(); //

    // ---- here was the onn anf off event listeners

    if (_socket != null) {
      SocketListenerRegistry(_socket!).registerAll();
    }

    ////
    ///
    ///
    ///
    //
    //
    // ```

    // ---

    // **The flow now:**
    // ```
    // User taps Accept
    //   → onTapAction() stores _pendingConversationId, emits socket
    //     → Socket fires conversation_accepted
    //       → SocketService sets wrc.isSuccessAccept = true
    //         → ever() triggers _onAcceptSuccess()
    //           → removes from list + shows dialogs ✅

    // User taps Reject
    //   → onTapAction() stores _pendingConversationId, emits socket
    //     → Socket fires conversation_rejected
    //       → SocketService sets wrc.isSuccessReject = true
    //         → ever() triggers _onRejectSuccess()
    //           → removes from list silently ✅
    //   //
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMIT
  // ═══════════════════════════════════════════════════════════════════════════

  void emit(String event, dynamic data) {
    print("token now: $getToken");
    if (!isConnected) {
      print("⚠️ Emit skipped — socket not connected → $event");
      return;
    }
    _socket!.emit(event, data);
    print("📤 Emit: $event → $data");
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LISTENER WRAPPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Internal — always called after _socket is assigned.
  void _on(String event, Function(Map<String, dynamic>) callback) {
    _socket!.on(event, (data) {
      try {
        callback(_parse(data));
        print("📥 Listen: [$event] $data");
      } catch (e, stack) {
        print("❌ Callback error [$event]: $e\n$stack");
      }
    });
  }

  /// Public — for one-off listeners added externally (e.g. from a controller).
  /// Only safe to call after connectSocket().
  void on(String event, Function(Map<String, dynamic>) callback) {
    if (_socket == null) {
      print("⚠️ on('$event') — socket not ready, call connectSocket() first");
      return;
    }
    _on(event, callback);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════════════════════

  void off(String event) {
    _socket?.off(event);
    print("🧹 Removed listener: $event");
  }

  @override
  void onClose() {
    _retryTimer?.cancel();
    _onConnectedController.close(); // ✅ missing
    _onDisconnectedController.close(); // ✅ NEW
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
    super.onClose();
  }

  bool _intentionalDisconnect = false;

  void disconnectSocket() {
    _intentionalDisconnect = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    _retryCount = 0; // ✅ reset so retry logic starts clean for new user
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null; // ✅ critical — forces full rebuild on next connect
    print("🔴 Socket manually disconnected");
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // PARSER
  // ═══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> _parse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return Map<String, dynamic>.from(data as Map);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTO-RETRY — added without touching any existing logic
  // ═══════════════════════════════════════════════════════════════════════════

  static const int _maxRetries = 8;
  static const Duration _baseDelay = Duration(seconds: 2);

  int _retryCount = 0;
  Timer? _retryTimer;
  // ✅ Add this — single source of truth for socket readiness
  final _onConnectedController = StreamController<void>.broadcast();
  Stream<void> get onConnected => _onConnectedController.stream;

  // ✅ NEW — single source of truth for disconnects
  final _onDisconnectedController = StreamController<void>.broadcast();
  Stream<void> get onDisconnected => _onDisconnectedController.stream;

  /// Called once inside _registerListeners() — hooks into socket lifecycle.
  // At the top of _registerRetryListeners()
  void _registerRetryListeners() {
    _socket!.onConnect((_) {
      _retryCount = 0;
      _retryTimer?.cancel();
      _retryTimer = null;
      print("🔁 Retry state reset — socket healthy");
      print("✅ Socket Connected: ${_socket!.id}");

      if (!(_connectCompleter?.isCompleted ?? true)) {
        _connectCompleter?.complete();
      }

      // ✅ Broadcast to all listeners
      _onConnectedController.add(null);

      // ✅ NEW
      if (Get.isRegistered<SocketStatusController>()) {
        SocketStatusController.to.setConnected();
      }
    });

    _socket!.onDisconnect((reason) {
      print("🔌 Disconnected — reason: $reason");
      print("🔌 Socket disconnected — scheduling retry...");

      _scheduleRetry();
    });

    _socket!.onConnectError((_) {
      print("❌ Connect error — scheduling retry...");
      _scheduleRetry();
    });
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();

    if (_retryCount >= _maxRetries) {
      print("🚫 Max retries ($_maxRetries) reached. Giving up.");

      // ✅ NEW
      if (Get.isRegistered<SocketStatusController>()) {
        SocketStatusController.to.setFailed();
      }
      return;
    }

    final delay = Duration(
      seconds: (_baseDelay.inSeconds * (1 << _retryCount)).clamp(2, 60),
    );

    _retryCount++;

    // ✅ NEW
    if (Get.isRegistered<SocketStatusController>()) {
      SocketStatusController.to.setReconnecting(_retryCount);
    }

    print("⏳ Retry #$_retryCount in ${delay.inSeconds}s...");

    _retryTimer = Timer(delay, () async {
      if (!isConnected) {
        print("🔄 Attempting reconnect #$_retryCount...");
        try {
          // ✅ Reuse existing socket if still alive
          // if (_socket != null) {
          //   _socket!.connect(); // just reconnect, no listener rebuild
          // }
          if (_socket != null) {
            _socket!.io.options?['auth'] = {'token': getToken};

            print("🔐 Reconnect token: $getToken");

            _socket!.connect();
          } else {
            await connectSocket(); // full rebuild only if socket was destroyed
          }
        } catch (e) {
          print("❌ Reconnect #$_retryCount failed: $e");
        }
      }
    });
  }
  //

  // ═══════════════════════════════════════════════════════════════════════════
  // ENSURE CONNECTED — attempt a reconnect before giving up on an emit
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isEnsuringConnection = false;

  /// Returns true if already connected, or becomes connected within [timeout].
  /// Returns false if the attempt times out — caller decides what to tell
  /// the user in that case.
  Future<bool> ensureConnected({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (isConnected) return true;

    // Avoid overlapping attempts if called again while one's in flight
    // (e.g. user double-taps wave).
    if (_isEnsuringConnection) {
      return isConnected;
    }
    _isEnsuringConnection = true;

    print("🔄 Not connected — attempting reconnect before emit...");

    final completer = Completer<bool>();
    final sub = onConnected.listen((_) {
      if (!completer.isCompleted) completer.complete(true);
    });

    try {
      if (_socket != null) {
        // Existing socket, just dropped — nudge it, refreshing the token
        // in case it changed since the last connect.
        _socket!.io.options?['auth'] = {'token': getToken};
        _socket!.connect();
      } else {
        // Never connected this session — do a full build.
        // ignore: unawaited_futures
        connectSocket();
      }

      return await completer.future.timeout(timeout, onTimeout: () => false);
    } finally {
      await sub.cancel();
      _isEnsuringConnection = false;
    }
  }

  //
}

/*


{"statusCode":200,"success":true,"message":"You have retrieved all conversation requests.","data":[{"_id":"69c3b1238adbc682371dbea3","participants":[{"_id":"69ae9cb708dc2ab1a71ac76e","name":"soubir","profileImage":"uploads/profile-image/profile-avatar-1773811023684.jpeg"},{"_id":"69b661d6abc1103705aa7704","name":"abc","profileImage":"uploads/profile-image/screenshot-2026-03-17-094619-1773741134511.png"}],"status":"Pending","createdAt":"2026-03-25T09:55:47.826Z","updatedAt":"2026-03-25T09:55:47.826Z","__v":0}]}
*/
