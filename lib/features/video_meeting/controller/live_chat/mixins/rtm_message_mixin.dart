import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:mama_app/core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';
import 'package:mama_app/features/video_meeting/model/chat_message_live_model.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/components/ui/dialogs/popups.dart';
import '../../live_chat_controller.dart';

mixin RtmMessageMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  final messages = <ChatMessageLiveModel>[].obs;

  Future<void> onMessage(MessageEvent event) async {
    try {
      log('💬 [RTM] Raw message from ${event.publisher}: "${event.message}"');

      String rawText = (event.message ?? '').toString();
      String displayText = rawText;
      String senderName = '';
      String senderAvatar = '';

      try {
        if (rawText.trimLeft().startsWith('[')) {
          final List<dynamic> byteList = jsonDecode(rawText);
          final bytes = byteList.cast<int>();
          final decoded = utf8.decode(bytes);
          final Map<String, dynamic> payload = jsonDecode(decoded);

          log('payload: ${payload.toString()}');

          final type = payload['type'];
          switch (type) {
            case 'LIKE':
              _self.reactionCount.value++;
              _self.triggerHeartAnimation(payload["emoji"] ?? '');
              return;

            case 'RAISE_HAND':
              final uid = payload['sender']?.toString() ?? '';
              if (uid.isNotEmpty && !_self.raisedHands.any((h) => h.uid == uid)) {
                _self.raisedHands.add(
                  RaiseHandModel(
                    uid: uid,
                    name: payload['senderName'] ?? uid,
                    avatar: payload['senderAvatar'] ?? '',
                  ),
                );
              }
              return;

            case 'HAND_LOWER':
              final target = payload['target']?.toString() ?? '';
              _self.raisedHands.removeWhere((h) {
                log('raisedHands target id: ${target} ');
                log('raisedHands target id: ${h.uid} ');
                return h.uid == target;
              });
              return;

            case 'REMOTE_MUTE':
              final target = payload['target']?.toString() ?? '';
              if (target == _self.mc.uid.value.toString()) {
                await _self.mc.muteLocalAudio(true, cc: _self);
                "You have been muted by the host".showToast();
              }
              return;

            case 'REMOTE_KICK':
              final target = payload['target']?.toString() ?? '';
              if (target == _self.mc.uid.value.toString()) {
                // 1. Clean up engine immediately — user stops seeing/hearing live
                _self.mc.isSessionExiting = true;
                _self.mc.exitReason = LiveExitReason.kicked;

                await _self.mc.leaveMeeting();

                // 2. Navigate away from meeting screen entirely
                Get.offAllNamed(RoutePaths.ongoingSessions);

                // 3. Small delay to let the new screen settle before showing popup
                await Future.delayed(const Duration(milliseconds: 400));

                // 4. Show popup on top of the new screen
                showLiveExitPopup(LiveExitReason.kicked);
              }
              return;

            default:
              displayText = payload['message'] ?? decoded;
              senderName = payload['senderName'] ?? '';
              senderAvatar = payload['senderAvatar'] ?? payload['avatar'] ?? '';
          }
        } else {
          // Plain JSON string path (sent by Flutter clients)
          try {
            final Map<String, dynamic> payload = jsonDecode(rawText);
            final type = payload['type'];

            switch (type) {
              case 'LIKE':
                _self.reactionCount.value++;
                _self.triggerHeartAnimation(payload["emoji"] ?? '');
                return;

              case 'RAISE_HAND':
                final uid = payload['sender']?.toString() ?? '';
                if (uid.isNotEmpty && !_self.raisedHands.any((h) => h.uid == uid)) {
                  _self.raisedHands.add(
                    RaiseHandModel(
                      uid: uid,
                      name: payload['senderName'] ?? uid,
                      avatar: payload['senderAvatar'] ?? '',
                    ),
                  );
                }
                return;

              case 'HAND_LOWER':
                final target = payload['target']?.toString() ?? '';
                _self.raisedHands.removeWhere((h) {
                  log('raisedHands target id: $target');
                  log('raisedHands uid: ${h.uid}');
                  return h.uid == target;
                });
                // Only show toast if the host lowered THIS user's hand
                if (target == _self.mc.uid.value.toString()) {
                  "The host has lowered your hand".showToast();
                }
                return;

              case 'REMOTE_MUTE':
                final target = payload['target']?.toString() ?? '';
                if (target == _self.mc.uid.value.toString()) {
                  await _self.mc.muteLocalAudio(true, cc: _self);
                  "You have been muted by the host".showToast();
                }
                return;

              case 'REMOTE_KICK':
                final target = payload['target']?.toString() ?? '';
                if (target == _self.mc.uid.value.toString()) {
                  // 1. Clean up engine immediately — user stops seeing/hearing live
                  await _self.mc.leaveMeeting();

                  // 2. Navigate away from meeting screen entirely
                  Get.offAllNamed(RoutePaths.ongoingSessions);

                  // 3. Small delay to let the new screen settle before showing popup
                  await Future.delayed(const Duration(milliseconds: 400));

                  // 4. Show popup on top of the new screen
                  showLiveExitPopup(LiveExitReason.kicked);
                }
                return;

              case 'CHAT':
                displayText = payload['message'] ?? rawText;
                senderName = payload['senderName'] ?? '';
                senderAvatar = payload['senderAvatar'] ?? payload['avatar'] ?? '';
                break;

              default:
                displayText = rawText;
            }
          } catch (_) {
            displayText = rawText;
          }
        }
      } catch (e) {
        log('⚠️ [RTM] Could not decode message — using raw: $e');
        displayText = rawText;
      }

      // Skip adding a chat bubble for non-CHAT types that already returned above
      final isMe = event.publisher == _self.mc.uid.value.toString();

      if (senderName.isEmpty) {
        senderName = isMe ? (_self.mc.sessionInfo.value.userName ?? 'You') : 'User';
      }
      if (senderAvatar.isEmpty) {
        senderAvatar = isMe ? (_self.mc.sessionInfo.value.userAvatar ?? '') : '';
      }

      messages.add(
        ChatMessageLiveModel(
          text: displayText,
          senderId: event.publisher ?? '',
          isMe: isMe,
          timestamp: DateTime.now(),
          senderAvatar: senderAvatar,
          senderName: senderName,
        ),
      );

      log('✅ [RTM] Total messages: ${messages.length}');
      _self.scrollToBottom();
    } catch (e) {
      log('❌ [RTM] _onMessage error: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();

    if (trimmed.isEmpty) {
      log('⚠️ [RTM] Empty message — skipping');
      return;
    }

    if (!_self.isRtmReady.value || _self.rtmClient == null) {
      log('❌ [RTM] Not ready — cannot send');
      "Chat not connected yet".showToast();
      return;
    }

    try {
      log('📤 [RTM] Publishing: "$trimmed"');

      final payload = jsonEncode({
        "type": "CHAT",
        "message": trimmed,
        "sender": _self.mc.uid.value.toString(),
        "senderName": _self.mc.sessionInfo.value.userName ?? '',
        "senderAvatar": _self.mc.sessionInfo.value.userAvatar ?? '',
      });

      final (status, result) = await _self.rtmClient!.publish(
        _self.mc.channelName.value,
        payload,
        channelType: RtmChannelType.message,
      );

      if (status.error) {
        log(
          '❌ [RTM] Publish failed — code: ${status.errorCode}, reason: ${status.reason}',
        );
        "Failed to send".showToast();
        return;
      }

      log('✅ [RTM] Published: ${result.toString()}');

      // v2 does NOT echo back to sender — add locally
      messages.add(
        ChatMessageLiveModel(
          text: trimmed,
          senderId: _self.mc.uid.value.toString(),
          isMe: true,
          timestamp: DateTime.now(),
          senderAvatar: _self.mc.sessionInfo.value.userAvatar ?? '',
          senderName: _self.mc.sessionInfo.value.userName ?? '',
        ),
      );

      _self.mc.inputMsgCtrl.clear();
      FocusManager.instance.primaryFocus?.unfocus(); // ← dismiss keyboard
      _self.scrollToBottom();
    } catch (e) {
      log('❌ [RTM] sendMessage error: $e');
      "Failed to send".showToast();
    }
  }
}