import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:mama_app/features/video_meeting/services/meeting_service.dart';

import '../../../app/controller_export.dart';
import '../../../core/config/agora_config.dart';
import '../../../core/helpers/permission_helper.dart';
import '../model/live_session_info_model.dart';
/*
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
          hasLiveStarted.value = true; // ✅ mark as started
          hasLiveEnded.value = false;
        },
        onUserOffline: (connection, uid, reason) {
          debugPrint('⚠️ [10] Remote user left: uid=$uid, reason=$reason');
          remoteUids.remove(uid);
          if (hasLiveStarted.value && remoteUids.isEmpty) {
            hasLiveEnded.value = true; // ✅ host left after live was active
          }
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

  /// ---------------- Speaking -----------------///
  var isSpeaking = false.obs;

  Future<void> toggleSpeak() async {
    if (isSpeaking.value) {
      // Step down back to audience
      await agoraEngine?.setClientRole(role: ClientRoleType.clientRoleAudience);
      await agoraEngine?.muteLocalAudioStream(true);
      isSpeaking.value = false;
    } else {
      // Promote to host so we can publish audio
      await agoraEngine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await agoraEngine?.muteLocalAudioStream(false);
      isSpeaking.value = true;
    }
  }

  // In MeetingController
  var hasLiveStarted = false.obs; // becomes true once host joins
  var hasLiveEnded = false.obs; // becomes true once host leaves

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

*/

class MeetingController extends GetxController {
  /// 🔹 Channel passed from previous screen
  final String channelname;
  MeetingController(this.channelname);

  /// 🔹 Chat input
  final inputMsgCtrl = TextEditingController();
  final inputMsgFocus = FocusNode();

  /// -------------------- Agora Core Config -------------------- ///
  /// These are populated AFTER backend response
  final appId = ''.obs;
  final token = ''.obs;
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

  @override
  void onInit() {
    /// Initial channel from navigation
    debugPrint('channelname arg: $channelname');

    channelName.value = channelname;

    super.onInit();
  }

  /// -------------------- Session Info -------------------- ///

  RxBool isSessionInfoLoading = false.obs;

  /// Backend response model
  final sessionInfo = LiveSessionInfoModel().obs;

  /// 🔹 Fetch token + channel + uid from backend
  Future<void> getSessionsInfo() async {
    if (isSessionInfoLoading.value) return;

    isSessionInfoLoading.value = true;

    try {
      final data = await MeetingService().fetchSessionsInfo(channelName: channelname);

      if (data != null) {
        sessionInfo.value = data;

        /// Debug logs (VERY useful for Agora debugging)
        debugPrint('📦 Parsed model token: ${data.token}');
        debugPrint('📦 Parsed model channel: ${data.channelName}');
        debugPrint('📦 Parsed model uid: ${data.uid}');
      }

      /// Small delay for smoother UX
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

    /// -->  Entry point of live flow
    hostMeeting();
  }

  /// -------------------- Start Flow -------------------- ///
  Future<void> hostMeeting() async {
    debugPrint('🔵 [1] hostMeeting() started');

    /// Step 1: Fetch token & session data
    await getSessionsInfo();

    debugPrint('🔵 [2] sessionInfo after fetch:');
    debugPrint('   channelName: ${sessionInfo.value.channelName}');
    debugPrint('   token: ${sessionInfo.value.token}');
    debugPrint('   uid: ${sessionInfo.value.uid}');

    final fetchedToken = sessionInfo.value.token;
    final fetchedChannel = sessionInfo.value.channelName;
    final fetchedUid = sessionInfo.value.uid;

    /// 🔴 Safety checks (must have valid data)
    if (fetchedToken == null || fetchedToken.isEmpty) {
      debugPrint('❌ Token is null or empty!');
      return;
    }

    if (fetchedChannel == null || fetchedChannel.isEmpty) {
      debugPrint('❌ ChannelName is null or empty!');
      return;
    }

    /// Step 2: Assign values
    token.value = fetchedToken;
    channelName.value = fetchedChannel;
    uid.value = fetchedUid ?? 0;
    appId.value = AgoraConfig.appId;

    debugPrint('🔵 [3] appId: ${appId.value}');
    debugPrint('🔵 [3] token: ${token.value}');
    debugPrint('🔵 [3] channel: ${channelName.value}');
    debugPrint('🔵 [3] uid: ${uid.value}');

    /// Step 3: Initialize Agora
    await initAgora();
  }

  /// -------------------- Agora Setup -------------------- ///
  Future<void> initAgora() async {
    debugPrint('🔵 [4] initAgora() started');

    /// Ask permissions (camera/mic)
    await requestPermissions();
    debugPrint('🔵 [5] Permissions granted');

    /// Clean previous engine if exists (VERY important)
    if (agoraEngine != null) {
      debugPrint('⚠️ Releasing previous engine');
      await agoraEngine!.leaveChannel();
      await agoraEngine!.release();
      agoraEngine = null;

      await Future.delayed(const Duration(milliseconds: 500));
    }

    final engine = createAgoraRtcEngine();

    /// Initialize engine
    try {
      await engine.initialize(RtcEngineContext(appId: appId.value));
      debugPrint('🔵 [6] Engine initialized');
    } catch (e) {
      debugPrint('❌ Engine init FAILED: $e');
      return;
    }

    /// Enable video stream
    await engine.enableVideo();

    /// Set as LIVE STREAM (not call)
    await engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

    /// 👤 USER ROLE = AUDIENCE (viewer-only app)
    await engine.setClientRole(role: ClientRoleType.clientRoleAudience);

    debugPrint('🔵 [7] Role = AUDIENCE');

    /// -------------------- Event Handlers -------------------- ///
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          debugPrint('❌ Agora Error: $err - $msg');
        },

        /// Joined successfully
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('✅ Joined channel: ${connection.channelId}, uid: ${connection.localUid}');
        },

        /// Host joined → show video
        onUserJoined: (connection, uid, elapsed) {
          debugPrint('🎥 Host joined: uid=$uid');

          remoteUids.add(uid);

          hasLiveStarted.value = true;
          hasLiveEnded.value = false;
        },

        /// Host left
        onUserOffline: (connection, uid, reason) {
          debugPrint('⚠️ Host left: uid=$uid');

          remoteUids.remove(uid);

          if (hasLiveStarted.value && remoteUids.isEmpty) {
            hasLiveEnded.value = true;
          }
        },

        /// Token expiry
        onTokenPrivilegeWillExpire: (connection, token) {
          debugPrint('⚠️ Token expiring soon');
        },

        /// Connection state
        onConnectionStateChanged: (connection, state, reason) {
          debugPrint('🔵 Connection: $state, reason: $reason');
        },

        /// Video state debug
        onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
          debugPrint('🎥 Video state: uid=$remoteUid, state=$state');
        },
      ),
    );

    /// -------------------- Join Channel -------------------- ///
    debugPrint('🔵 Joining channel...');

    await engine.joinChannel(
      token: token.value,
      channelId: channelName.value,
      uid: uid.value,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,

        /// ❌ Viewer app → no publishing
        publishCameraTrack: false,
        publishMicrophoneTrack: false,

        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );

    agoraEngine = engine;

    /// UI can now render video
    isEngineReady.value = true;

    debugPrint('🔵 Engine ready');
  }

  /// ---------------- Speaking (Audience → Broadcaster) ---------------- ///
  var isSpeaking = false.obs;

  Future<void> toggleSpeak() async {
    if (isSpeaking.value) {
      debugPrint('🔇 [SPEAK] Stepping down from broadcaster → audience');

      await agoraEngine?.setClientRole(role: ClientRoleType.clientRoleAudience);
      debugPrint('🔇 [SPEAK] setClientRole → AUDIENCE done');

      await agoraEngine?.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishMicrophoneTrack: false,
          clientRoleType: ClientRoleType.clientRoleAudience,
        ),
      );
      debugPrint('🔇 [SPEAK] updateChannelMediaOptions → mic UNPUBLISHED');

      isSpeaking.value = false;
      debugPrint('🔇 [SPEAK] isSpeaking = false ✅');
    } else {
      debugPrint('🎙️ [SPEAK] Promoting to broadcaster → host');

      await agoraEngine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      debugPrint('🎙️ [SPEAK] setClientRole → BROADCASTER done');

      await agoraEngine?.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      debugPrint('🎙️ [SPEAK] updateChannelMediaOptions → mic PUBLISHED');

      // ✅ Confirm engine state
      debugPrint('🎙️ [SPEAK] agoraEngine is null: ${agoraEngine == null}');
      debugPrint('🎙️ [SPEAK] channel: ${channelName.value}');
      debugPrint('🎙️ [SPEAK] uid: ${uid.value}');
      debugPrint('🎙️ [SPEAK] token: ${token.value.substring(0, 10)}...'); // partial for safety

      isSpeaking.value = true;
      debugPrint('🎙️ [SPEAK] isSpeaking = true ✅ — web should now hear app user');
    }
  }

  /// ---------------- Live State ---------------- ///
  var hasLiveStarted = false.obs;
  var hasLiveEnded = false.obs;

  /// Leave channel manually
  void leaveMeeting() {
    agoraEngine?.leaveChannel();
    remoteUids.clear();
    isEngineReady.value = false;
  }

  @override
  void onClose() async {
    debugPrint('🔵 onClose → releasing engine');

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