import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:we_mama/core/utils/extension/string_extension.dart';

import '../../../../../app/controller_export.dart';
import '../../live_chat_controller.dart';

mixin RtmHostControlsMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  /// Host mutes a remote participant
  Future<void> muteParticipant(String targetUid) async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    // Optimistically update local participant list
    final index = _self.participants.indexWhere((p) => p.uid == targetUid);
    if (index != -1) {
      _self.participants[index] = _self.participants[index].copyWith(
        isMuted: true,
      );
    }

    final payload = jsonEncode({
      "type": "REMOTE_MUTE",
      "sender": _self.mc.uid.value.toString(),
      "target": targetUid,
    });

    try {
      final (status, _) = await _self.rtmClient!.publish(
        _self.mc.channelName.value,
        payload,
        channelType: RtmChannelType.message,
      );

      if (status.error) {
        throw Exception('RTM publish failed: ${status.errorCode}');
      }

      print('✅ [RTM] Mute command sent to $targetUid');
      "Mute command sent".showToast();
    } catch (e) {
      print('❌ [RTM] muteParticipant failed: $e');
      // Revert optimistic update on error
      if (index != -1) {
        _self.participants[index] = _self.participants[index].copyWith(
          isMuted: false,
        );
      }
      "Failed to mute participant".showToast();
    }
  }

  /// Host unmutes a remote participant
  Future<void> unmuteParticipant(String targetUid) async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    // Optimistically update local participant list
    final index = _self.participants.indexWhere((p) => p.uid == targetUid);
    if (index != -1) {
      _self.participants[index] = _self.participants[index].copyWith(
        isMuted: false,
      );
    }

    final payload = jsonEncode({
      "type": "REMOTE_UNMUTE",
      "sender": _self.mc.uid.value.toString(),
      "target": targetUid,
    });

    try {
      final (status, _) = await _self.rtmClient!.publish(
        _self.mc.channelName.value,
        payload,
        channelType: RtmChannelType.message,
      );

      if (status.error) {
        throw Exception('RTM publish failed: ${status.errorCode}');
      }

      print('✅ [RTM] Unmute command sent to $targetUid');
      "Unmute command sent".showToast();
    } catch (e) {
      print('❌ [RTM] unmuteParticipant failed: $e');
      // Revert optimistic update on error
      if (index != -1) {
        _self.participants[index] = _self.participants[index].copyWith(
          isMuted: true,
        );
      }
      "Failed to unmute participant".showToast();
    }
  }

  /// Host kicks a remote participant
  Future<void> kickParticipant(String targetUid) async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    final payload = jsonEncode({
      "type": "REMOTE_KICK",
      "sender": _self.mc.uid.value.toString(),
      "target": targetUid,
    });

    try {
      final (status, _) = await _self.rtmClient!.publish(
        _self.mc.channelName.value,
        payload,
        channelType: RtmChannelType.message,
      );

      if (status.error) {
        throw Exception('RTM publish failed: ${status.errorCode}');
      }

      // Remove from local list
      _self.participants.removeWhere((p) => p.uid == targetUid);
      _self.raisedHands.removeWhere((h) => h.uid == targetUid);
      _self.viewCount.value = _self.participants.length;

      print('✅ [RTM] Kick command sent to $targetUid');
      "Participant removed".showToast();
    } catch (e) {
      print('❌ [RTM] kickParticipant failed: $e');
      "Failed to remove participant".showToast();
    }
  }

  /// Host lowers a specific participant's hand
  Future<void> lowerParticipantHand(String targetUid) async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    final payload = jsonEncode({
      "type": "HAND_LOWER",
      "sender": _self.mc.uid.value.toString(),
      "target": targetUid,
    });

    try {
      final (status, _) = await _self.rtmClient!.publish(
        _self.mc.channelName.value,
        payload,
        channelType: RtmChannelType.message,
      );

      if (status.error) {
        throw Exception('RTM publish failed: ${status.errorCode}');
      }

      _self.raisedHands.removeWhere((h) => h.uid == targetUid);
      print('✅ [RTM] Hand lowered for $targetUid');
    } catch (e) {
      print('❌ [RTM] lowerParticipantHand failed: $e');
    }
  }
}
//
