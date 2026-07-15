import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:mama_app/app/service_export.dart';

import '../../../app/controller_export.dart';
import 'arg_model/meeting_ctrl_ag_model.dart';
import 'mixins/agora_engine_mixin.dart';
import 'mixins/leave_session_mixin.dart';
import 'mixins/session_info_mixin.dart';
import 'mixins/session_timer_mixin.dart';
import 'mixins/speaking_mixin.dart';

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

  RxBool isHostVideoOn = true.obs;
  RxBool isHostAudioOn = true.obs;

  RxBool isJoined = false.obs;

  RxBool isFullscreen = false.obs;
  //
  RxInt videoViewGeneration = 0.obs;
  final embeddedVideoAreaKey =
      GlobalKey(); // measures where the embedded slot sits

  @override
  void onInit() {
    /// Initial channel from navigation
    log('channelname arg: ${agrModel.channelname}');

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
    super.onReady();

    /// -->  Entry point of live flow
    hostMeeting();
  }

  @override
  void onClose() async {
    log('🔵 onClose called');
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
