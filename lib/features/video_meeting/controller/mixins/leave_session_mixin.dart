import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:we_mama/core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import 'package:we_mama/features/main_nav/controller/main_nav_controller.dart';

import '../../../../app/controller_export.dart';
import '../live_chat_controller.dart';
import '../meeting_controller.dart';

mixin LeaveSessionMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  /// ---------------- Live State ---------------- ///
  var hasLiveStarted = false.obs;
  var hasLiveEnded = false.obs;

  var isSessionExiting = false;
  LiveExitReason? exitReason;

  /// Called by LiveChatController when host sends REMOTE_KICK targeting this user
  Future<void> leaveSession() async {
    print('🔴 leaveSession() — kicked by host');
    await leaveMeeting();

    // Navigate away after cleanup
    // Small delay so leaveMeeting() finishes before navigation
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAllNamed(RoutePaths.mainNav);
    MainNavController.to.goToTab(
      4,
    ); // ← replace with your actual home/dashboard route
  }

  /// Leave channel manually
  Future<void> leaveMeeting() async {
    print('🔵 leaveMeeting() called');

    _self.isSessionExiting = true;

    // 👇 only the host publishes this — rtmClient lives on LiveChatController,
    // not on MeetingController, so we reach across via Get.find

    try {
      final chat = Get.isRegistered<LiveChatController>()
          ? Get.find<LiveChatController>()
          : null;

      if (chat != null && chat.rtmClient != null && chat.isRtmReady.value) {
        await chat.rtmClient!.publish(
          _self.channelName.value,
          jsonEncode({
            'type': 'HOST_ENDED_LIVE',
            'ts': DateTime.now().millisecondsSinceEpoch,
          }),
          channelType: RtmChannelType.message,
        );
        print('📡 [RTM] HOST_ENDED_LIVE published');
      } else {
        print(
          '⚠️ [RTM] Chat controller not ready — skipping HOST_ENDED_LIVE publish',
        );
      }
    } catch (e) {
      print('❌ [RTM] Failed to publish HOST_ENDED_LIVE: $e');
    }

    //
    _self.stopSessionTimer();

    // ✅ Reset all visual state immediately so UI doesn't show stale data
    _self.remoteUids.clear();
    _self.isHostAudioOn.value = false;
    _self.isHostVideoOn.value = VideoStatus.loading;
    hasLiveStarted.value = false;
    hasLiveEnded.value = false;
    _self.isSpeaking.value = false;
    _self.isEngineReady.value = false;

    await WakelockPlus.disable(); // 🔥 allow sleep again
    print('🌙 Wakelock disabled');

    if (_self.agoraEngine != null) {
      try {
        await _self.agoraEngine!.leaveChannel();
        print('✅ Left channel');
      } catch (e) {
        print('❌ leaveChannel error: $e');
      }

      try {
        await _self.agoraEngine!.release(sync: true);
        print('✅ Engine released');
      } catch (e) {
        print('❌ release error: $e');
      }

      _self.agoraEngine = null;
    }

    _self.isJoined.value = false;
    print('✅ leaveMeeting complete');
  }
}
