import 'dart:async';

import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/core/config/app_info.dart';
import 'package:mama_app/features/main_tabs/chat/controller/chat_controller.dart';
import 'package:mama_app/features/main_tabs/match/controller/match_controller.dart';
import 'package:mama_app/features/shared/wave_request/controller/wave_request_controller.dart';
import 'package:mama_app/features/shared/wave_request/model/new_wave_req_list_item_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../app/service_export.dart';
import '../../../features/main_tabs/chat/controller/chat_inbox_controller.dart';
import '../../../features/main_tabs/chat/model/chat_inbox_msg_item_model.dart';
import '../../../features/main_tabs/chat/model/chat_list_item_model.dart';
import '../../../features/more/notification/controller/notification_controller.dart';
import '../../../features/more/notification/model/notifications_model.dart';
import '../../helpers/methods_helper.dart';
import '../../helpers/widgets_helper.dart';
import '../../utils/extension/context_extension.dart';
import 'socket_events.dart';
import 'socket_response_handler .dart';
import 'socket_status_controller.dart';

class SocketService extends GetxService {
  IO.Socket? _socket;

  Completer<void>? _connectCompleter;

  bool get isConnected => _socket?.connected ?? false;

  // ── onInit: nothing socket-related here — socket doesn't exist yet ─────────

  // ═══════════════════════════════════════════════════════════════════════════
  // CONNECT
  // ═══════════════════════════════════════════════════════════════════════════

  /*
  Future<void> connectSocket() async {
    // Reset completer
    _connectCompleter = Completer<void>();

    try {
      // cleanup old socket
      if (_socket != null) {
        _socket!.clearListeners();
        _socket!.disconnect();
        _socket!.destroy();
        _socket = null;
      }

      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': getToken})
            .disableAutoConnect()
            .build(),
      );

      try {
        _socket!.onConnect((_) {
          log("✅ Socket Connected: ${_socket!.id}");

          if (!(_connectCompleter?.isCompleted ?? true)) {
            _connectCompleter?.complete();
          }
        });
      } catch (e) {
        log("onConnect error ignored: $e");
      }

      _socket!.onConnectError((err) {
        log("❌ Socket error: $err");

        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.completeError(err);
        }
      });

      _registerListeners();

      _socket!.connect();

      // 👇 WAIT here until connected
      return _connectCompleter!.future;
    } catch (e) {
      log("Socket connect crashed (ignored): $e");

      // 👉 prevent app crash / interruption
      if (!(_connectCompleter?.isCompleted ?? true)) {
        _connectCompleter?.complete();
      }
    }
  }
  */

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
        log("✅ Socket Connected: ${_socket!.id}");
        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.complete();
        }
      });

      _socket!.onConnectError((err) {
        log("❌ Socket error: $err");
        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.completeError(err);
        }
      });

      _registerListeners(); // registers fresh on the new socket instance

      _socket!.connect();

      return _connectCompleter!.future;
    } catch (e) {
      log("Socket connect crashed: $e");
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

    // ── send_conversation_request ─────────────────────────────────────────────
    _off(SocketEvents.sendConversationRequest);
    _off(SocketEvents.sendConversationRequest);
    _on(SocketEvents.sendConversationRequest, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.sendConversationRequest,
      );
      // No snackbar — MatchController.showWaveSentDialog() handles UI
    });

    // ── new_conversation_request ──────────────────────────────────────────────
    _off(SocketEvents.newConversationRequest);
    _on(SocketEvents.newConversationRequest, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.newConversationRequest,
      );
      if (!res.isSuccess) return;

      // final currentProfileId = Get.find<ProfileController>().userProfileData.value?.id ?? '';

      // ── Determine role via message (reliable, backend-controlled) ────────────
      // Sender  → "You have requested..."
      // Receiver → "You have received..."
      final isSender = res.message.toLowerCase().contains('requested');
      final isReceiver = res.message.toLowerCase().contains('received');

      log(
        '🧪 newConversationRequest | currentId: ${currentProfileId()} '
        '| isSender: $isSender | isReceiver: $isReceiver | msg: ${res.message}',
      );

      // if (isSender) {
      //   // ✅ Flag for MatchController (sender only)
      //   if (Get.isRegistered<MatchController>()) {
      //     Get.find<MatchController>().isSuccessSentReq.value = true;
      //   }
      //   return; // sender gets no snackbar — MatchController shows Wave Sent dialog
      // }

      // In socket_service.dart — inside the newConversationRequest handler

      if (isSender) {
        if (Get.isRegistered<MatchController>()) {
          final mc = Get.find<MatchController>();
          mc.isSuccessSentReq.value = true;
          mc.onWaveConfirmed(true); // ← signals the completer
        }
        return;
      }

      if (isReceiver) {
        Get.snackbar(
          'New Request 💬',
          res.message,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // ── Fallback: message was neither, use participant index as last resort ───
      final participants =
          (res.dataAsMap?['participants'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      log('🧪 fallback participants: $participants');

      if (participants.length >= 2 && participants[1] == currentProfileId()) {
        Get.snackbar(
          'New Request 💬',
          res.message,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
    // ── new_notification ──────────────────────────────────────────────────────
    // _on(SocketEvents.newNotification, (data) {
    //   final res = SocketResponseHandler.handle(data, eventName: SocketEvents.newNotification);
    //   if (!res.isSuccess) return;

    //   final notificationData = res.dataAsMap;
    //   if (notificationData == null) return;

    //   // Always push to notification list
    //   if (Get.isRegistered<NotificationController>()) {
    //     Get.find<NotificationController>().addNotification(notificationData);
    //   }

    //   // Suppress snackbar for SENT_WAVE — already shown via conversation_request
    //   final type = notificationData['type'] as String? ?? '';
    //   if (type == 'SENT_WAVE') return;

    //   Get.snackbar(
    //     notificationData['title'] ?? 'Notification',
    //     notificationData['description'] ?? '',
    //     // 🎨 background (optional)
    //     backgroundColor: c.primary.withOpacity(0.1),
    //     // ❌ default texts disabled
    //     titleText: buildTitle(notificationData['title']),
    //     messageText: buildMessage(notificationData['description']),
    //     snackPosition: SnackPosition.TOP,
    //   );
    // });
    _off(SocketEvents.newNotification);
    _on(SocketEvents.newNotification, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.newNotification,
      );
      if (!res.isSuccess) return;

      final notificationData = res.dataAsMap;
      if (notificationData == null) return;

      // ─────────────────────────────
      // 🔹 Push to notification list
      // ─────────────────────────────
      if (Get.isRegistered<NotificationController>()) {
        // ✅ NotificationItemModel.fromJson expects:
        // _id, toId, toModel, title, description, type,
        // referenceId, referenceModel, isSeen, createdAt, updatedAt, __v
        final notification = NotificationItemModel.fromJson(notificationData);
        Get.find<NotificationController>().addNotification(notification);
      }

      // ─────────────────────────────
      // 🔹 Suppress snackbar for SENT_WAVE
      // ─────────────────────────────
      final type = notificationData['type'] as String? ?? '';
      if (type == 'SENT_WAVE') return;

      Get.snackbar(
        notificationData['title'] ?? 'Notification',
        notificationData['description'] ?? '',
        backgroundColor: c.primary.withOpacity(0.1),
        titleText: buildTitle(notificationData['title']),
        messageText: buildMessage(notificationData['description']),
        snackPosition: SnackPosition.TOP,
      );
    });
    // ── conversation_requests (list) ──────────────────────────────────────────
    _off(SocketEvents.conversationRequests);
    _on(SocketEvents.conversationRequests, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.conversationRequests,
      );
      if (!res.isSuccess) return;

      final list = (res.dataAsList ?? [])
          .map((e) => NewWaveListItemModel.fromJson(e))
          .toList();

      debugPrint("list of wave list : ${list.length}");
      debugPrint("list of wave res.dataAsList  : ${res.dataAsList?.length}");

      if (Get.isRegistered<WaveRequestController>()) {
        Get.find<WaveRequestController>().updateWaveList(list);
      }
    });

    // ── conversation_accepted ─────────────────────────────────────────────────
    _off(SocketEvents.conversationAccepted);
    _on(SocketEvents.conversationAccepted, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.conversationAccepted,
      );
      if (!res.isSuccess) return;

      final conversationId = res.dataAsMap?['_id'] as String? ?? '';

      // ── Parse populated participants ──────────────────────────────────────────
      final participantsList = res.dataAsMap?['participants'] as List? ?? [];
      final participants = participantsList
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final myId = currentProfileId();

      // ── Role detection via message ────────────────────────────────────────────
      // Acceptor  → "Your new conversation request accepted."  (YOU accepted)
      // Requester → backend sends different message to the wave sender
      final msg = res.message.toLowerCase();
      final isAcceptor =
          msg.contains('you have accepted') ||
          msg.contains('your new conversation request accepted');

      // ── Peer = the one who is NOT me ─────────────────────────────────────────
      final peer = participants.firstWhereOrNull((p) => p['_id'] != myId);
      final peerName = peer?['name'] as String? ?? '';
      final peerImageUrl = peer?['profileImage'] as String? ?? '';

      log(
        '🧪 conversationAccepted | myId: $myId | isAcceptor: $isAcceptor'
        ' | peer: $peerName | msg: ${res.message}',
      );

      if (Get.isRegistered<WaveRequestController>()) {
        final wrc = Get.find<WaveRequestController>();

        // Always hydrate peer info — both sides may need it
        wrc.peerName.value = peerName;
        wrc.peerImageUrl.value = peerImageUrl;

        if (isAcceptor) {
          // Triggers ever(isSuccessAccept) → _onAcceptSuccess()
          wrc.isSuccessAccept.value = true;
        }
      }

      // 🔔 Notify the wave SENDER that their request was accepted
      // if (!isAcceptor) {
      //   Get.snackbar('Wave Accepted! 🎉', res.message, snackPosition: SnackPosition.TOP);
      // }
    });

    // ── conversation_rejected ─────────────────────────────────────────────────
    _off(SocketEvents.conversationRejected);
    _on(SocketEvents.conversationRejected, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.conversationRejected,
      );
      if (!res.isSuccess) return;

      final msg = res.message.toLowerCase();
      final isRejector =
          msg.contains('you have rejected') || msg.contains('declined');

      log(
        '🧪 conversationRejected | isRejector: $isRejector | msg: ${res.message}',
      );

      if (isRejector && Get.isRegistered<WaveRequestController>()) {
        // Triggers ever(isSuccessReject) → _onRejectSuccess()
        Get.find<WaveRequestController>().isSuccessReject.value = true;
        Get.snackbar(
          'Wave Rejected! ',
          res.message,
          snackPosition: SnackPosition.TOP,
        );
      }

      // 🔕 No snackbar to wave sender — bad UX to explicitly notify rejection
    });

    // ── chat_list (list) ──────────────────────────────────────────

    _off(SocketEvents.chatList);
    _on(SocketEvents.chatList, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.chatList,
      );
      if (!res.isSuccess) return;

      final list = (res.dataAsList ?? [])
          .map((e) => ChatListItemModel.fromJson(e))
          .toList();

      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().updateChatList(list);
      }
    });
    // ── chat_inbox_msg_list (list) ──────────────────────────────────────────
    _on(SocketEvents.messages, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.messages,
      );
      if (!res.isSuccess) return;

      final itemData = ChatInboxMessageItemModel.fromJson(res.dataAsMap ?? {});

      if (Get.isRegistered<ChatInboxController>()) {
        Get.find<ChatInboxController>().updateChatInboxMsgItem(itemData);
      }
    });

    //
    // ── chat_new_message listen ──────────────────────────────────────────
    _on(SocketEvents.newMessage, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.newMessage,
      );
      if (!res.isSuccess) return;

      final msgData = Message.fromJson(res.dataAsMap ?? {});

      if (Get.isRegistered<ChatInboxController>()) {
        Get.find<ChatInboxController>().addMessage(msgData); // ✅ correct
      }

      //
      // ✅ Update chat list for incoming messages too
      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().updateLastMessage(
          chatId: msgData.conversationId ?? '',
          lastMessage: msgData.text ?? '',
          time: msgData.createdAt ?? DateTime.now(),
        );
      }
    });
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
    log("token now: $getToken");
    if (!isConnected) {
      log("⚠️ Emit skipped — socket not connected → $event");
      return;
    }
    _socket!.emit(event, data);
    log("📤 Emit: $event → $data");
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LISTENER WRAPPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Internal — always called after _socket is assigned.
  void _on(String event, Function(Map<String, dynamic>) callback) {
    _socket!.on(event, (data) {
      try {
        callback(_parse(data));
        log("📥 Listen: [$event] $data");
      } catch (e, stack) {
        log("❌ Callback error [$event]: $e\n$stack");
      }
    });
  }

  /// Internal — removes a listener before re-registering, prevents stacking.
  void _off(String event) {
    _socket?.off(event);
    log("🧹 Removed listener: $event");
  }

  /// Public — for one-off listeners added externally (e.g. from a controller).
  /// Only safe to call after connectSocket().
  void on(String event, Function(Map<String, dynamic>) callback) {
    if (_socket == null) {
      log("⚠️ on('$event') — socket not ready, call connectSocket() first");
      return;
    }
    _on(event, callback);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════════════════════

  void off(String event) {
    _socket?.off(event);
    log("🧹 Removed listener: $event");
  }

  @override
  void onClose() {
    _retryTimer?.cancel();
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
    super.onClose();
  }

  void disconnectSocket() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _retryCount = 0; // ✅ reset so retry logic starts clean for new user
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null; // ✅ critical — forces full rebuild on next connect
    log("🔴 Socket manually disconnected");
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

  /// Called once inside _registerListeners() — hooks into socket lifecycle.
  // At the top of _registerRetryListeners()
  void _registerRetryListeners() {
    _socket!.onConnect((_) {
      _retryCount = 0;
      _retryTimer?.cancel();
      _retryTimer = null;
      log("🔁 Retry state reset — socket healthy");

      // ✅ NEW
      if (Get.isRegistered<SocketStatusController>()) {
        SocketStatusController.to.setConnected();
      }
    });

    _socket!.onDisconnect((_) {
      log("🔌 Socket disconnected — scheduling retry...");
      _scheduleRetry();
    });

    _socket!.onConnectError((_) {
      log("❌ Connect error — scheduling retry...");
      _scheduleRetry();
    });
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();

    if (_retryCount >= _maxRetries) {
      log("🚫 Max retries ($_maxRetries) reached. Giving up.");

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

    log("⏳ Retry #$_retryCount in ${delay.inSeconds}s...");

    _retryTimer = Timer(delay, () async {
      if (!isConnected) {
        log("🔄 Attempting reconnect #$_retryCount...");
        try {
          // ✅ Reuse existing socket if still alive
          // if (_socket != null) {
          //   _socket!.connect(); // just reconnect, no listener rebuild
          // }
          if (_socket != null) {
            _socket!.io.options?['auth'] = {'token': getToken};

            log("🔐 Reconnect token: $getToken");

            _socket!.connect();
          } else {
            await connectSocket(); // full rebuild only if socket was destroyed
          }
        } catch (e) {
          log("❌ Reconnect #$_retryCount failed: $e");
        }
      }
    });
  }
}

/*


{"statusCode":200,"success":true,"message":"You have retrieved all conversation requests.","data":[{"_id":"69c3b1238adbc682371dbea3","participants":[{"_id":"69ae9cb708dc2ab1a71ac76e","name":"soubir","profileImage":"uploads/profile-image/profile-avatar-1773811023684.jpeg"},{"_id":"69b661d6abc1103705aa7704","name":"abc","profileImage":"uploads/profile-image/screenshot-2026-03-17-094619-1773741134511.png"}],"status":"Pending","createdAt":"2026-03-25T09:55:47.826Z","updatedAt":"2026-03-25T09:55:47.826Z","__v":0}]}
*/
