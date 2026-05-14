import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:mama_app/features/video_meeting/controller/live_chat_controller.dart';

import '../../../../app/controller_export.dart';
import '../meeting_controller.dart';

mixin SpeakingMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  /// ---------------- Speaking (Audience → Broadcaster) ---------------- ///
  var isSpeaking = false.obs;

  Future<void> toggleSpeak(LiveChatController cc) async {
    if (isSpeaking.value) {
      log('🔇 [SPEAK] Stepping down from broadcaster → audience');

      await _self.agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleAudience,
      );
      log('🔇 [SPEAK] setClientRole → AUDIENCE done');

      await _self.agoraEngine?.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishMicrophoneTrack: false,
          clientRoleType: ClientRoleType.clientRoleAudience,
        ),
      );

      log('🔇 [SPEAK] updateChannelMediaOptions → mic UNPUBLISHED');

      isSpeaking.value = false;

      // ← notify web: mic is now OFF
      await _publishMuteState(isMuted: true, cc: cc);

      log('🔇 [SPEAK] isSpeaking = false ✅');
    } else {
      log('🎙️ [SPEAK] Promoting to broadcaster → host');

      await _self.agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
      );
      log('🎙️ [SPEAK] setClientRole → BROADCASTER done');

      await _self.agoraEngine?.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      log('🎙️ [SPEAK] updateChannelMediaOptions → mic PUBLISHED');

      // ✅ Confirm engine state
      log(
        '🎙️ [SPEAK] agoraEngine is null: ${_self.agoraEngine == null}',
      );
      log('🎙️ [SPEAK] channel: ${_self.channelName.value}');
      log('🎙️ [SPEAK] uid: ${_self.uid.value}');
      log(
        '🎙️ [SPEAK] token: ${_self.rtcToken.value.substring(0, 10)}...',
      ); // partial for safety

      isSpeaking.value = true;

      // ← notify web: mic is now ON
      await _publishMuteState(isMuted: false, cc: cc);

      log(
        '🎙️ [SPEAK] isSpeaking = true ✅ — web should now hear app user',
      );
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

      log(
        '📡 [RTM] Mute state broadcast → uid=${_self.uid.value}, isMuted=$isMuted',
      );
    } catch (e) {
      log('❌ [RTM] _publishMuteState error: $e');
    }
  }

  //
  /// Called by LiveChatController when host sends REMOTE_MUTE targeting this user
  Future<void> muteLocalAudio(
    bool mute, {
    required LiveChatController cc,
  }) async {
    if (_self.agoraEngine == null) return;

    _self.isLocalAudioMuted.value = mute;

    if (isSpeaking.value) {
      await _self.agoraEngine?.updateChannelMediaOptions(
        ChannelMediaOptions(
          publishMicrophoneTrack: !mute,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      if (mute) {
        await _self.agoraEngine?.setClientRole(
          role: ClientRoleType.clientRoleAudience,
        );
        await _self.agoraEngine?.updateChannelMediaOptions(
          const ChannelMediaOptions(
            publishMicrophoneTrack: false,
            clientRoleType: ClientRoleType.clientRoleAudience,
          ),
        );
        isSpeaking.value = false;
      }
    }

    // ← sync mute state to web via RTM presence
    await _publishMuteState(isMuted: mute, cc: cc);

    log('🔇 muteLocalAudio($mute) applied');
  }
}
