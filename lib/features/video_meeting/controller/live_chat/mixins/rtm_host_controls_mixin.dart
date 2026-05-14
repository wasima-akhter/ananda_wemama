import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';

import '../../../../../app/controller_export.dart';
import '../../live_chat_controller.dart';

mixin RtmHostControlsMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  /// Host mutes a remote participant
  Future<void> muteParticipant(String targetUid) async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    final payload = jsonEncode({
      "type": "REMOTE_MUTE",
      "sender": _self.mc.uid.value.toString(),
      "target": targetUid,
    });

    final (status, _) = await _self.rtmClient!.publish(
      _self.mc.channelName.value,
      payload,
      channelType: RtmChannelType.message,
    );

    if (status.error) {
      log('❌ [RTM] muteParticipant failed: ${status.errorCode}');
      "Failed to mute participant".showToast();
      return;
    }

    // Optimistically update local participant list
    final index = _self.participants.indexWhere((p) => p.uid == targetUid);
    if (index != -1) {
      _self.participants[index] = _self.participants[index].copyWith(isMuted: true);
    }

    log('✅ [RTM] Mute command sent to $targetUid');
    "Mute command sent".showToast();
  }

  /// Host kicks a remote participant
  Future<void> kickParticipant(String targetUid) async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    final payload = jsonEncode({
      "type": "REMOTE_KICK",
      "sender": _self.mc.uid.value.toString(),
      "target": targetUid,
    });

    final (status, _) = await _self.rtmClient!.publish(
      _self.mc.channelName.value,
      payload,
      channelType: RtmChannelType.message,
    );

    if (status.error) {
      log('❌ [RTM] kickParticipant failed: ${status.errorCode}');
      "Failed to remove participant".showToast();
      return;
    }

    // Optimistically remove from local list
    _self.participants.removeWhere((p) => p.uid == targetUid);
    _self.raisedHands.removeWhere((h) => h.uid == targetUid);
    _self.viewCount.value = _self.participants.length;

    log('✅ [RTM] Kick command sent to $targetUid');
    "Participant removed".showToast();
  }

  /// Host lowers a specific participant's hand
  Future<void> lowerParticipantHand(String targetUid) async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    final payload = jsonEncode({
      "type": "HAND_LOWER",
      "sender": _self.mc.uid.value.toString(),
      "target": targetUid,
    });

    final (status, _) = await _self.rtmClient!.publish(
      _self.mc.channelName.value,
      payload,
      channelType: RtmChannelType.message,
    );

    if (status.error) {
      log('❌ [RTM] lowerParticipantHand failed: ${status.errorCode}');
      return;
    }

    _self.raisedHands.removeWhere((h) => h.uid == targetUid);
    log('✅ [RTM] Hand lowered for $targetUid');
  }
}