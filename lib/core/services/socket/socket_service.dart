import 'dart:async';

import 'package:get/get.dart';
import 'package:mama_app/core/config/app_info.dart';
import 'package:mama_app/features/main_tabs/match/controller/match_controller.dart';
import 'package:mama_app/features/shared/wave_request/controller/wave_request_controller.dart';
import 'package:mama_app/features/shared/wave_request/model/new_wave_req_list_item_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../features/more/notification/controller/notification_controller.dart';
import '../../helpers/methods_helper.dart';
import '../../helpers/widgets_helper.dart';
import '../../network/helpers/network_helpers.dart';
import '../../utils/extension/context_extension.dart';
import 'socket_events.dart';
import 'socket_response_handler .dart';

class SocketService extends GetxService {
  IO.Socket? _socket;

  Completer<void>? _connectCompleter;

  bool get isConnected => _socket?.connected ?? false;

  // ── onInit: nothing socket-related here — socket doesn't exist yet ─────────
  @override
  void onInit() {
    super.onInit();
    // connectSocket() is called explicitly:
    //   • At app start via MainNavBinding (already-logged-in users)
    //   • After login via SigninService._connectSocketAfterLogin()
    // Do NOT connect here — token may not be saved yet on first launch.
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONNECT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> connectSocket() async {
    // Reset completer
    _connectCompleter = Completer<void>();

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
          .disableAutoConnect() // 👈 important
          .build(),
    );

    _socket!.onConnect((_) {
      print("✅ Socket Connected: ${_socket!.id}");

      // complete future
      if (!(_connectCompleter?.isCompleted ?? true)) {
        _connectCompleter?.complete();
      }
    });

    _socket!.onConnectError((err) {
      print("❌ Socket error: $err");

      if (!(_connectCompleter?.isCompleted ?? true)) {
        _connectCompleter?.completeError(err);
      }
    });

    _registerListeners();

    _socket!.connect();

    // 👇 WAIT here until connected
    return _connectCompleter!.future;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LISTENERS — registered once per connectSocket() call
  // ═══════════════════════════════════════════════════════════════════════════

  void _registerListeners() {
    // ── send_conversation_request ─────────────────────────────────────────────
    _on(SocketEvents.sendConversationRequest, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.sendConversationRequest,
      );
      // No snackbar — MatchController.showWaveSentDialog() handles UI
    });

    // ── new_conversation_request ──────────────────────────────────────────────
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

      print(
        '🧪 newConversationRequest | currentId: ${currentProfileId()} '
        '| isSender: $isSender | isReceiver: $isReceiver | msg: ${res.message}',
      );

      if (isSender) {
        // ✅ Flag for MatchController (sender only)
        if (Get.isRegistered<MatchController>()) {
          Get.find<MatchController>().isSuccessSentReq.value = true;
        }
        return; // sender gets no snackbar — MatchController shows Wave Sent dialog
      }

      if (isReceiver) {
        Get.snackbar('New Request 💬', res.message, snackPosition: SnackPosition.TOP);
        return;
      }

      // ── Fallback: message was neither, use participant index as last resort ───
      final participants =
          (res.dataAsMap?['participants'] as List?)?.map((e) => e.toString()).toList() ?? [];

      print('🧪 fallback participants: $participants');

      if (participants.length >= 2 && participants[1] == currentProfileId()) {
        Get.snackbar('New Request 💬', res.message, snackPosition: SnackPosition.TOP);
      }
    });
    // ── new_notification ──────────────────────────────────────────────────────
    _on(SocketEvents.newNotification, (data) {
      final res = SocketResponseHandler.handle(data, eventName: SocketEvents.newNotification);
      if (!res.isSuccess) return;

      final notificationData = res.dataAsMap;
      if (notificationData == null) return;

      // Always push to notification list
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().addNotification(notificationData);
      }

      // Suppress snackbar for SENT_WAVE — already shown via conversation_request
      final type = notificationData['type'] as String? ?? '';
      if (type == 'SENT_WAVE') return;

      Get.snackbar(
        notificationData['title'] ?? 'Notification',
        notificationData['description'] ?? '',
        // 🎨 background (optional)
        backgroundColor: c.primary.withOpacity(0.1),
        // ❌ default texts disabled
        titleText: buildTitle(notificationData['title']),
        messageText: buildMessage(notificationData['description']),
        snackPosition: SnackPosition.TOP,
      );
    });

    // ── conversation_requests (list) ──────────────────────────────────────────
    _on(SocketEvents.conversationRequests, (data) {
      final res = SocketResponseHandler.handle(data, eventName: SocketEvents.conversationRequests);
      if (!res.isSuccess) return;

      final list = (res.dataAsList ?? []).map((e) => NewWaveListItemModel.fromJson(e)).toList();

      if (Get.isRegistered<WaveRequestController>()) {
        Get.find<WaveRequestController>().updateWaveList(list);
      }
    });

    // ── conversation_accepted ─────────────────────────────────────────────────
    _on(SocketEvents.conversationAccepted, (data) {
      final res = SocketResponseHandler.handle(data, eventName: SocketEvents.conversationAccepted);
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

      print(
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
    _on(SocketEvents.conversationRejected, (data) {
      final res = SocketResponseHandler.handle(data, eventName: SocketEvents.conversationRejected);
      if (!res.isSuccess) return;

      final msg = res.message.toLowerCase();
      final isRejector = msg.contains('you have rejected') || msg.contains('declined');

      print('🧪 conversationRejected | isRejector: $isRejector | msg: ${res.message}');

      if (isRejector && Get.isRegistered<WaveRequestController>()) {
        // Triggers ever(isSuccessReject) → _onRejectSuccess()
        Get.find<WaveRequestController>().isSuccessReject.value = true;
        Get.snackbar('Wave Rejected! ', res.message, snackPosition: SnackPosition.TOP);
      }

      // 🔕 No snackbar to wave sender — bad UX to explicitly notify rejection
    });
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
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PARSER
  // ═══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> _parse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return Map<String, dynamic>.from(data as Map);
  }
}



/*


{"statusCode":200,"success":true,"message":"You have retrieved all conversation requests.","data":[{"_id":"69c3b1238adbc682371dbea3","participants":[{"_id":"69ae9cb708dc2ab1a71ac76e","name":"soubir","profileImage":"uploads/profile-image/profile-avatar-1773811023684.jpeg"},{"_id":"69b661d6abc1103705aa7704","name":"abc","profileImage":"uploads/profile-image/screenshot-2026-03-17-094619-1773741134511.png"}],"status":"Pending","createdAt":"2026-03-25T09:55:47.826Z","updatedAt":"2026-03-25T09:55:47.826Z","__v":0}]}
*/