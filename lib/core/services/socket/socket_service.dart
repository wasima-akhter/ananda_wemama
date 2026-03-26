import 'dart:async';

import 'package:get/get.dart';
import 'package:mama_app/core/config/app_info.dart';
import 'package:mama_app/features/shared/wave_request/controller/wave_request_controller.dart';
import 'package:mama_app/features/shared/wave_request/model/new_wave_req_list_item_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../features/more/notification/controller/notification_controller.dart';
import '../../network/helpers/network_helpers.dart';
import 'socket_events.dart';

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
    // ── send_conversation_request (response back to USER 1 who emitted) ───────
    // User 1 gets this as confirmation. We do NOT show a snackbar here because
    // MatchController already shows a custom "Wave Sent" dialog on success.
    _on(SocketEvents.sendConversationRequest, (data) {
      print("📥 [send_conversation_request] response: $data");
      // Intentionally no snackbar — MatchController.showWaveSentDialog() handles UI
    });

    // ── new_conversation_request (incoming request to USER 2) ────────────────
    // Only show snackbar if this user is the RECEIVER.
    // We detect this by checking the message — the sender gets
    // "You have requested..." and the receiver gets "You have received..."
    _on(SocketEvents.newConversationRequest, (data) {
      print("📥 New Conversation Request: $data");

      final participants =
          (data["data"]?["participants"] as List?)?.map((e) => e.toString()).toList() ?? [];

      final currentProfileId = Get.find<ProfileController>().userProfileData.value?.id ?? '';

      // 🧠 Receiver is ALWAYS index 1 (based on your backend)
      final isReceiver = participants.length >= 2 && participants[1] == currentProfileId;
      final message = (data["message"] ?? '').toString();
      if (message.contains('received')) {
        // receiver
        Get.snackbar(
          "New Request 💬",
          data["message"] ?? "Someone sent you a conversation request",
        );
      } else {
        print("👤 Sender detected → snackbar skipped");
      }
    });

    // ── new_notification (USER 2 only) ────────────────────────────────────────
    _on(SocketEvents.newNotification, (data) {
      print("🔔 New Notification: $data");
      final notificationData = data["data"];

      // Add to notification list regardless
      if (notificationData != null && Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().addNotification(notificationData);
      }

      // Suppress snackbar for SENT_WAVE type — the new_conversation_request
      // listener above already showed a snackbar for this exact event.
      final type = notificationData?["type"] as String? ?? '';
      if (type == 'SENT_WAVE') {
        print(
          "🔕 Suppressing SENT_WAVE notification snackbar (already shown via conversation request)",
        );
        return;
      }

      // Show snackbar for all other notification types

      Get.snackbar(
        notificationData?["title"] ?? "Notification",
        notificationData?["description"] ?? "",
      );
    });

    _on(SocketEvents.conversationRequests, (data) {
      print("📥 conversation_requests: $data");

      // parse the data

      final parsedData = (data["data"] as List? ?? [])
          .map((e) => NewWaveListItemModel.fromJson(e))
          .toList();

      if (Get.isRegistered<WaveRequestController>()) {
        Get.find<WaveRequestController>().updateWaveList(parsedData);
      }

      // Get.snackbar("New Wave List Retrived", data["message"] ?? "you got the list!");
    });

    _on(SocketEvents.conversationAccepted, (data) {
      print("📥 conversation_accepted: $data");

      Get.snackbar("conversation Accepted ", data["message"] ?? "conversationAccepted");
    });
  }

  void _handleResponseSnackbar(Map<String, dynamic> data) {
    final success = data["success"] ?? false;
    final message = data["message"] ?? "Something happened";
    Get.snackbar(
      success ? "Success ✅" : "Error ❌",
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
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