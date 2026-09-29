import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../app/helper_widgets_export.dart';
import '../../../features/main_tabs/chat/controller/chat_controller.dart';
import '../../../features/main_tabs/chat/controller/chat_inbox_controller.dart';
import '../../../features/main_tabs/chat/model/chat_inbox_msg_item_model.dart';
import '../../../features/main_tabs/chat/model/chat_list_item_model.dart';
import '../../../features/main_tabs/match/controller/match_controller.dart';
import '../../../features/shared/wave_request/controller/wave_request_controller.dart';
import '../../../features/shared/wave_request/model/new_wave_req_list_item_model.dart';
import 'socket_events.dart';
import 'socket_response_handler .dart';

class SocketListenerRegistry {
  final IO.Socket socket;

  SocketListenerRegistry(this.socket);

  void registerAll() {
    _registerConversationEvents();
    _registerNotificationEvents();
    _registerChatEvents();
  }

  void _registerConversationEvents() {
    // ── send_conversation_request ─────────────────────────────────────────────

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

      print(
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

      print('🧪 fallback participants: $participants');

      if (participants.length >= 2 && participants[1] == currentProfileId()) {
        Get.snackbar(
          'New Request 💬',
          res.message,
          snackPosition: SnackPosition.TOP,
        );
      }
    });

    // ── conversation_requests (list) ──────────────────────────────────────────
    _off(SocketEvents.conversationRequests);
    _on(SocketEvents.conversationRequests, (data) {
      final res = SocketResponseHandler.handle(
        data,
        eventName: SocketEvents.conversationRequests,
      );
      if (!res.isSuccess) return;
      try {
        final rawList = res.dataAsList ?? [];

        final list = rawList
            .map((e) => NewWaveListItemModel.fromJson(e))
            .toList();

        print("conversation_requests: ${list.length} item(s)");
        if (rawList.isNotEmpty) {
          print("first = ${rawList.first}");
        }

        for (final item in list) {
          print("id = ${item.id}");
        }

        if (Get.isRegistered<WaveRequestController>()) {
          Get.find<WaveRequestController>().updateWaveList(list);
        }
      } catch (e, s) {
        print(e.toString());
        print(s.toString());
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

      print(
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

    // etc.
  }

  void _registerNotificationEvents() {
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
    // _off(SocketEvents.newNotification);
    // _on(SocketEvents.newNotification, (data) {
    //   final res = SocketResponseHandler.handle(
    //     data,
    //     eventName: SocketEvents.newNotification,
    //   );
    //   if (!res.isSuccess) return;

    //   final notificationData = res.dataAsMap;
    //   if (notificationData == null) return;

    //   // ─────────────────────────────
    //   // 🔹 Push to notification list
    //   // ─────────────────────────────
    //   if (Get.isRegistered<NotificationController>()) {
    //     // ✅ NotificationItemModel.fromJson expects:
    //     // _id, toId, toModel, title, description, type,
    //     // referenceId, referenceModel, isSeen, createdAt, updatedAt, __v
    //     final notification = NotificationItemModel.fromJson(notificationData);
    //     Get.find<NotificationController>().addNotification(notification);
    //   }

    //   // ─────────────────────────────
    //   // 🔹 Suppress snackbar for SENT_WAVE
    //   // ─────────────────────────────
    //   final type = notificationData['type'] as String? ?? '';
    //   if (type == 'SENT_WAVE') return;

    //   Get.snackbar(
    //     notificationData['title'] ?? 'Notification',
    //     notificationData['description'] ?? '',
    //     backgroundColor: newBorderClr,
    //     titleText: buildTitle(notificationData['title']),
    //     messageText: buildMessage(notificationData['description']),
    //     snackPosition: SnackPosition.TOP,
    //   );
    // });
  }

  void _registerChatEvents() {
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
    // _on(SocketEvents.messages, (data) {
    //   final res = SocketResponseHandler.handle(
    //     data,
    //     eventName: SocketEvents.messages,
    //   );
    //   if (!res.isSuccess) return;

    //   final itemData = ChatInboxMessageItemModel.fromJson(res.dataAsMap ?? {});

    //   if (Get.isRegistered<ChatInboxController>()) {
    //     Get.find<ChatInboxController>().updateChatInboxMsgItem(itemData);
    //   }
    // });

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
  }

  /// Internal — removes a listener before re-registering, prevents stacking.
  void _off(String event) {
    socket.off(event);
    print("🧹 Removed listener: $event");
  }

  /// Internal — always called after _socket is assigned.
  void _on(String event, Function(Map<String, dynamic>) callback) {
    socket.on(event, (data) {
      try {
        callback(_parse(data));
        print("📥 Listen: [$event] $data");
      } catch (e, stack) {
        print("❌ Callback error [$event]: $e\n$stack");
      }
    });
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // PARSER
  // ═══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> _parse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return Map<String, dynamic>.from(data as Map);
  }
}
