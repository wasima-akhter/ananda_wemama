import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:mama_app/features/video_meeting/services/meeting_service.dart';

import '../../../app/controller_export.dart';
import '../../../core/config/agora_config.dart';
import '../../../core/helpers/permission_helper.dart';
import '../model/live_session_info_model.dart';

class MeetingController extends GetxController {
  final String channelname;
  MeetingController(this.channelname);
  final inputMsgCtrl = TextEditingController();
  final inputMsgFocus = FocusNode();

  ///////////////////////////////
  final appId = ''.obs;
  final token = ''.obs;
  final channelName = ''.obs;
  final uid = 0.obs;

  final chatController = TextEditingController();

  RtcEngine? agoraEngine;

  var isEngineReady = false.obs;

  var remoteUids = <int>[].obs;
  var isLocalAudioMuted = false.obs;
  var isLocalVideoMuted = false.obs;

  @override
  void onInit() {
    //
    debugPrint('channelname arg: $channelname');

    channelName.value = channelname;

    super.onInit();
  }

  //----------------------- Actions --------------------------//

  RxBool isSessionInfoLoading = false.obs;
  final sessionInfo = LiveSessionInfoModel().obs;

  Future<void> getSessionsInfo() async {
    if (isSessionInfoLoading.value) return;
    isSessionInfoLoading.value = true;

    try {
      final data = await MeetingService().fetchSessionsInfo(channelName: channelname);

      if (data != null) {
        sessionInfo.value = data;

        debugPrint('📦 Parsed model token: ${data.token}');
        debugPrint('📦 Parsed model channel: ${data.channelName}');
        debugPrint('📦 Parsed model uid: ${data.uid}');
        /* fetched data:
        {channelName: "uscgsdc_iasuhdgcui_ashg", token: "atas67r673tcb734fbt4br56dft3", uid: 765794656}
        */
      }

      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      debugPrint('getSessionsInfo error: $e');
    } finally {
      isSessionInfoLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    hostMeeting(); // ✅ start meeting automatically
  }

  // ✅ Updated: wait for token from your backend before joining
  Future<void> hostMeeting() async {
    debugPrint('🔵 [1] hostMeeting() started');

    await getSessionsInfo();

    debugPrint('🔵 [2] sessionInfo after fetch:');
    debugPrint('   channelName: ${sessionInfo.value.channelName}');
    debugPrint('   token: ${sessionInfo.value.token}');
    debugPrint('   uid: ${sessionInfo.value.uid}');

    final fetchedToken = sessionInfo.value.token;
    final fetchedChannel = sessionInfo.value.channelName;
    final fetchedUid = sessionInfo.value.uid;

    if (fetchedToken == null || fetchedToken.isEmpty) {
      debugPrint('❌ [ERROR] Token is null or empty! Check LiveSessionInfoModel parsing.');
      return;
    }

    if (fetchedChannel == null || fetchedChannel.isEmpty) {
      debugPrint('❌ [ERROR] ChannelName is null or empty!');
      return;
    }

    token.value = fetchedToken;
    channelName.value = fetchedChannel;
    uid.value = fetchedUid ?? 0;
    appId.value = AgoraConfig.appId;

    debugPrint('🔵 [3] appId: ${appId.value}');
    debugPrint('🔵 [3] token: ${token.value}');
    debugPrint('🔵 [3] channel: ${channelName.value}');
    debugPrint('🔵 [3] uid: ${uid.value}');

    await initAgora();
  }

  Future<void> initAgora() async {
    debugPrint('🔵 [4] initAgora() started');

    await requestPermissions();
    debugPrint('🔵 [5] Permissions granted');

    // ✅ Always destroy any previous instance first
    if (agoraEngine != null) {
      debugPrint('⚠️ Previous engine found — releasing it first');
      await agoraEngine!.leaveChannel();
      await agoraEngine!.release();
      agoraEngine = null;
      await Future.delayed(const Duration(milliseconds: 500)); // give SDK time to clean up
    }

    final engine = createAgoraRtcEngine();

    // ✅ Check initialize result explicitly
    try {
      await engine.initialize(RtcEngineContext(appId: appId.value));
      debugPrint('🔵 [6] Engine initialized with appId: ${appId.value}');
    } catch (e) {
      debugPrint('❌ Engine initialize FAILED: $e');
      return;
    }

    await engine.enableVideo();
    debugPrint('🔵 [6b] enableVideo done');

    await engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    debugPrint('🔵 [7] Role set to AUDIENCE');

    ///////////////////////////

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          debugPrint('❌ [AGORA ERROR] $err - $msg');
        },
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint(
            '✅ [8] Joined channel successfully: ${connection.channelId}, uid: ${connection.localUid}',
          );
        },
        onUserJoined: (connection, uid, elapsed) {
          debugPrint('✅ [9] Remote user joined: uid=$uid — video should appear now');
          remoteUids.add(uid);
        },
        onUserOffline: (connection, uid, reason) {
          debugPrint('⚠️ [10] Remote user left: uid=$uid, reason=$reason');
          remoteUids.remove(uid);
        },
        onTokenPrivilegeWillExpire: (connection, token) {
          debugPrint('⚠️ Token expiring soon, need to refresh');
        },
        onConnectionStateChanged: (connection, state, reason) {
          debugPrint('🔵 Connection state: $state, reason: $reason');
        },
        onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
          debugPrint('🎥 Remote video state: uid=$remoteUid, state=$state, reason=$reason');
        },
      ),
    );

    debugPrint('🔵 Calling joinChannel with:');
    debugPrint('   token: $token');
    debugPrint('   channelId: $channelName');

    await engine.joinChannel(
      token: token.value,
      channelId: channelName.value,
      uid: uid.value,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );

    debugPrint('🔵 joinChannel() call returned (not yet confirmed by server)');

    agoraEngine = engine;
    isEngineReady.value = true;
    debugPrint('🔵 isEngineReady = true');
  }

  Future<void> startMeeting({required String channel, required String meetingToken}) async {
    channelName.value = channel;
    token.value = meetingToken;

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
  void onClose() async {
    debugPrint('🔵 onClose called — releasing engine');
    if (agoraEngine != null) {
      await agoraEngine!.leaveChannel();
      await agoraEngine!.release();
      agoraEngine = null;
    }
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