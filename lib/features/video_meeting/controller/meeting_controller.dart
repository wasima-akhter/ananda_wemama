import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:we_mama/app/service_export.dart';

import '../../../app/controller_export.dart';
import 'arg_model/meeting_ctrl_ag_model.dart';
import 'mixins/agora_engine_mixin.dart';
import 'mixins/leave_session_mixin.dart';
import 'mixins/session_info_mixin.dart';
import 'mixins/session_timer_mixin.dart';
import 'mixins/speaking_mixin.dart';

enum VideoStatus { loading, on, off, frozen }

class MeetingController extends GetxController
    with
        SessionInfoMixin,
        AgoraEngineMixin,
        SpeakingMixin,
        SessionTimerMixin,
        LeaveSessionMixin {
  /// 🔹 Channel passed from previous screen
  final MeetingCtrlAgModel agrModel;
  MeetingController(this.agrModel);

  static MeetingController get to => Get.find();

  final isFullscreen = false.obs;

  void enterFullscreen() {
    if (isFullscreen.value) return;

    isFullscreen.value = true;
  }

  void exitFullscreen() {
    if (!isFullscreen.value) return;

    isFullscreen.value = false;
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
  }

  /////////

  /// 🔹 Chat input
  final inputMsgCtrl = TextEditingController();
  final inputMsgFocus = FocusNode();

  /// -------------------- Agora Core Config -------------------- ///
  /// These are populated AFTER backend response
  final appId = ''.obs;
  final rtmToken = ''.obs;
  final rtcToken = ''.obs;
  final channelName = ''.obs;
  final uid = 0.obs;

  /// Agora engine instance
  RtcEngine? agoraEngine;

  /// Engine ready → UI can render video
  var isEngineReady = false.obs;

  /// Remote users (host(s))
  var remoteUids = <int>[].obs;

  /// Local states (future use if needed)
  var isLocalAudioMuted = false.obs;
  var isLocalVideoMuted = false.obs;

  // RxBool isHostVideoOn = true.obs;

  final isHostVideoOn = Rx<VideoStatus>(VideoStatus.loading);

  RxBool isHostAudioOn = true.obs;

  RxBool isJoined = false.obs;

  //
  RxInt videoViewGeneration = 0.obs;
  final embeddedVideoAreaKey =
      GlobalKey(); // measures where the embedded slot sits

  @override
  void onInit() {
    /// Initial channel from navigation
    print('channelname arg: ${agrModel.channelname}');

    channelName.value = agrModel.channelname;

    ever(isJoined, (callback) {
      if (!isJoined.value) {
        "You have left the live".showToast();
      }
    });

    super.onInit();
  }

  @override
  void onReady() {
    print('🔴 ===== ONREADY CALLED ====='); // Add this at the TOP
    print('🔴 ===== ONREADY CALLED ====='); // Add this at the TOP
    super.onReady();

    print('🔴 About to call hostMeeting()'); // Add this
    try {
      hostMeeting();
    } catch (e) {
      print('❌ hostMeeting() threw exception: $e');
    }
    print(
      '🔴 hostMeeting() call completed',
    ); // This will be async so may fire before hostMeeting actually completes
  }

  @override
  void onClose() async {
    print('🔵 onClose called');
    await leaveMeeting(); // reuse the same logic
    disposeAgoraEngineMixin();
    inputMsgCtrl.dispose();
    inputMsgFocus.dispose();
    super.onClose();
  }
}

/*

App opens MeetingScreen with channelName
    ↓
MeetingController.getSessionsInfo(channelName)
    ↓
Your backend generates a token for that channel + uid
    ↓
Backend returns { token, uid, channelName }
    ↓
initAgora() uses that token to joinChannel()


*/

/*

App opens MeetingScreen with channelName
    ↓
MeetingController.getSessionsInfo(channelName)
    ↓
Your backend generates a token for that channel + uid
    ↓
Backend returns { token, uid, channelName }
    ↓
initAgora() uses that token to joinChannel()


*/
