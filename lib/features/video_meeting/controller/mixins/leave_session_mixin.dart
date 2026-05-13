import 'package:mama_app/core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import 'package:mama_app/features/main_nav/controller/main_nav_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../app/controller_export.dart';
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
    debugPrint('🔴 leaveSession() — kicked by host');
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
    debugPrint('🔵 leaveMeeting() called');

    _self.stopSessionTimer();

    // ✅ Reset all visual state immediately so UI doesn't show stale data
    _self.remoteUids.clear();
    _self.isHostAudioOn.value = false;
    _self.isHostVideoOn.value = false;
    hasLiveStarted.value = false;
    hasLiveEnded.value = false;
    _self.isSpeaking.value = false;
    _self.isEngineReady.value = false;

    await WakelockPlus.disable(); // 🔥 allow sleep again
    debugPrint('🌙 Wakelock disabled');

    if (_self.agoraEngine != null) {
      try {
        await _self.agoraEngine!.leaveChannel();
        debugPrint('✅ Left channel');
      } catch (e) {
        debugPrint('❌ leaveChannel error: $e');
      }

      try {
        await _self.agoraEngine!.release(sync: true);
        debugPrint('✅ Engine released');
      } catch (e) {
        debugPrint('❌ release error: $e');
      }

      _self.agoraEngine = null;
    }

    _self.isJoined.value = false;
    debugPrint('✅ leaveMeeting complete');
  }
}
