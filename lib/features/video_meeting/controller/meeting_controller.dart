import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../app/controller_export.dart';
import '../../../core/config/agora_config.dart';
import '../../../core/helpers/permission_helper.dart';

class MeetingController extends GetxController {
  String appId = "";
  String token = "";
  String channelName = "";

  final chatController = TextEditingController();

  RtcEngine? agoraEngine;

  var isEngineReady = false.obs;

  var remoteUids = <int>[].obs;
  var isLocalAudioMuted = false.obs;
  var isLocalVideoMuted = false.obs;

  @override
  void onReady() {
    super.onReady();
    hostMeeting(); // ✅ start meeting automatically
  }

  Future<void> initAgora() async {
    await requestPermissions();

    final engine = createAgoraRtcEngine();

    await engine.initialize(RtcEngineContext(appId: appId));

    await engine.enableVideo();

    await engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, uid, elapsed) {
          remoteUids.add(uid);
        },
        onUserOffline: (connection, uid, reason) {
          remoteUids.remove(uid);
        },
      ),
    );

    await engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    agoraEngine = engine;
    isEngineReady.value = true;
  }

  Future<void> hostMeeting() async {
    appId = AgoraConfig.appId;
    token = AgoraConfig.token;
    channelName = AgoraConfig.channelName;

    // await initAgora();
  }

  Future<void> startMeeting({required String channel, required String meetingToken}) async {
    channelName = channel;
    token = meetingToken;

    // await initAgora();
  }

  String generateMeetingLink({String? userId}) {
    final uid = userId ?? "user_${DateTime.now().millisecondsSinceEpoch}";

    print("link: ${"https://wemama.app/meet?channel=$channelName&user=$uid"}");
    return "https://wemama.app/meet?channel=$channelName&user=$uid";
  }

  void toggleAudio() {
    isLocalAudioMuted.value = !isLocalAudioMuted.value;
    agoraEngine?.muteLocalAudioStream(isLocalAudioMuted.value);
  }

  void toggleVideo() {
    isLocalVideoMuted.value = !isLocalVideoMuted.value;
    agoraEngine?.muteLocalVideoStream(isLocalVideoMuted.value);
  }

  void leaveMeeting() {
    agoraEngine?.leaveChannel();
    remoteUids.clear();
    isEngineReady.value = false;
  }

  @override
  void onClose() {
    agoraEngine?.leaveChannel();
    agoraEngine?.release();
    super.onClose();
  }
}
