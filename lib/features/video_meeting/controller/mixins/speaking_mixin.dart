import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:we_mama/features/video_meeting/controller/live_chat_controller.dart';

import '../../../../app/controller_export.dart';
import '../meeting_controller.dart';

// client new requirement:
// ✅ Host from web can mute + unmute the app user
// ✅ App user can ONLY mute themselves, CANNOT unmute
// ❌ Unmute is ONLY via host REMOTE_UNMUTE message
mixin SpeakingMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  /// ---------------- Speaking (Audience → Broadcaster) ---------------- ///
  var isSpeaking = false.obs;

  /// User can only mute (stop speaking), NOT unmute
  /// Host can unmute via REMOTE_UNMUTE in muteLocalAudio()
  Future<void> toggleSpeak(LiveChatController cc) async {
    // ✅ Only allow user to STOP speaking (mute) if currently speaking
    if (isSpeaking.value) {
      print('🔇 [SPEAK] Stepping down from broadcaster → audience');

      await _self.agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleAudience,
      );
      print('🔇 [SPEAK] setClientRole → AUDIENCE done');

      await _self.agoraEngine?.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishMicrophoneTrack: false,
          clientRoleType: ClientRoleType.clientRoleAudience,
        ),
      );

      print('🔇 [SPEAK] updateChannelMediaOptions → mic UNPUBLISHED');

      isSpeaking.value = false;

      // ← notify web: mic is now OFF
      await _publishMuteState(isMuted: true, cc: cc);

      print('🔇 [SPEAK] isSpeaking = false ✅');
    } else {
      // ❌ BLOCKED: User cannot unmute themselves
      // Host must unmute via REMOTE_UNMUTE message
      print('❌ [SPEAK] Unmute blocked - only host can unmute');
      Get.snackbar(
        'Not Allowed',
        'Only the host can unmute you',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
  }

  Future<void> _publishMuteState({
    required bool isMuted,
    required LiveChatController cc,
  }) async {
    try {
      if (!cc.isRtmReady.value || cc.rtmClient == null) return;

      // 1. Publish a channel message — web receives this via onMessage
      //    and updates the participant's isMuted state in its list
      final payload = jsonEncode({
        "type": "MUTE_STATE_CHANGE",
        "sender": _self.uid.value.toString(),
        "isMuted": isMuted,
      });

      await cc.rtmClient!.publish(
        _self.channelName.value,
        payload,
        channelType: RtmChannelType.message,
      );

      // 2. Also update own presence state — for late joiners who get snapshot
      await cc.rtmClient!.getPresence().setState(
        _self.channelName.value,
        RtmChannelType.message,
        {'isMuted': isMuted ? 'true' : 'false'},
      );

      print(
        '📡 [RTM] Mute state broadcast → uid=${_self.uid.value}, isMuted=$isMuted',
      );
    } catch (e) {
      print('❌ [RTM] _publishMuteState error: $e');
    }
  }

  /// Called by LiveChatController when host sends REMOTE_MUTE or REMOTE_UNMUTE
  /// ✅ User CAN be unmuted by host (even if they muted themselves)
  Future<void> muteLocalAudio(
    bool mute, {
    required LiveChatController cc,
  }) async {
    if (_self.agoraEngine == null) return;

    _self.isLocalAudioMuted.value = mute;

    if (mute) {
      // ❌ HOST MUTING USER
      if (isSpeaking.value) {
        await _self.agoraEngine?.updateChannelMediaOptions(
          ChannelMediaOptions(
            publishMicrophoneTrack: false,
            clientRoleType: ClientRoleType.clientRoleAudience,
          ),
        );
        await _self.agoraEngine?.setClientRole(
          role: ClientRoleType.clientRoleAudience,
        );
        isSpeaking.value = false;
      }
    } else {
      // ✅ HOST UNMUTING USER — SET isSpeaking = true
      await _self.agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
      );
      await _self.agoraEngine?.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      isSpeaking.value = true;
    }

    // ← sync mute state to web via RTM presence
    await _publishMuteState(isMuted: mute, cc: cc);

    print('🔇 muteLocalAudio($mute) applied by host');
  }
}
