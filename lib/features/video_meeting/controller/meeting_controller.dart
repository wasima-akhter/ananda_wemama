import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:mama_app/core/components/ui/dialogs/popups.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';
import 'package:mama_app/features/main_nav/controller/main_nav_controller.dart';
import 'package:mama_app/features/video_meeting/controller/live_chat_controller.dart';
import 'package:mama_app/features/video_meeting/services/meeting_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../app/controller_export.dart';
import '../../../core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import '../../../core/config/agora_config.dart';
import '../../../core/helpers/permission_helper.dart';
import '../model/live_session_info_model.dart';

class MeetingCtrlAgModel {
  final String channelname;
  final String sessionTitle;
  final String hostName;

  MeetingCtrlAgModel({
    required this.channelname,
    required this.sessionTitle,
    required this.hostName,
  });
}

class MeetingController extends GetxController {
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

  @override
  void onInit() {
    /// Initial channel from navigation
    debugPrint('channelname arg: ${agrModel.channelname}');

    channelName.value = agrModel.channelname;

    ever(isJoined, (callback) {
      if (!isJoined.value) {
        "You have left the live".showToast();
      }
    });

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
      final data = await MeetingService().fetchSessionsInfo(channelName: agrModel.channelname);

      if (data != null) {
        sessionInfo.value = data;

        /// Debug logs (VERY useful for Agora debugging)
        debugPrint('📦 Parsed model rtmToken: ${data.rtmToken}');
        debugPrint('📦 Parsed model rtcToken: ${data.rtcToken}');
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
    debugPrint('   rtmToken: ${sessionInfo.value.rtmToken}');
    debugPrint('   rtc_Token: ${sessionInfo.value.rtcToken}');
    debugPrint('   uid: ${sessionInfo.value.uid}');

    final fetchedRtmToken = sessionInfo.value.rtmToken;
    final fetchedRtcToken = sessionInfo.value.rtcToken;
    final fetchedChannel = sessionInfo.value.channelName;
    final fetchedUid = sessionInfo.value.uid;

    /// 🔴 Safety checks (must have valid data)
    if (fetchedRtmToken == null || fetchedRtmToken.isEmpty) {
      debugPrint('❌ Token is null or empty!');
      return;
    }

    if (fetchedChannel == null || fetchedChannel.isEmpty) {
      debugPrint('❌ ChannelName is null or empty!');
      return;
    }
    if (fetchedRtcToken == null || fetchedRtcToken.isEmpty) {
      debugPrint('❌ fetchedRtcToken is null or empty!');
      return;
    }

    /// Step 2: Assign values
    rtmToken.value = fetchedRtmToken;
    rtcToken.value = fetchedRtcToken;
    channelName.value = fetchedChannel;
    uid.value = fetchedUid ?? 0;
    appId.value = AgoraConfig.appId;

    debugPrint('🔵 [3] appId: ${appId.value}');
    debugPrint('🔵 [3] rtm token: ${rtmToken.value}');
    debugPrint('🔵 [3] rtcToken: ${rtcToken.value}');
    debugPrint('🔵 [3] channel: ${channelName.value}');
    debugPrint('🔵 [3] uid: ${uid.value}');

    /// Step 3: Initialize Agora
    await initAgora();
  }

  /// -------------------- Agora Setup -------------------- ///

  final hostUid = RxnInt(); // ✅ nullable int
  Future<void> initAgora() async {
    debugPrint('🔵 [4] initAgora() started');

    await requestPermissions();
    debugPrint('🔵 [5] Permissions granted');

    final engine = createAgoraRtcEngine();

    // ✅ Release any stale native engine
    try {
      await engine.release(sync: true);
      debugPrint('✅ Pre-release done');
    } catch (e) {
      debugPrint('⚠️ Pre-release skipped: $e');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      await engine.initialize(RtcEngineContext(appId: appId.value));
      debugPrint('🔵 [6] Engine initialized');
    } catch (e) {
      debugPrint('❌ Engine init FAILED: $e');
      return;
    }

    try {
      await engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
      debugPrint('✅ setChannelProfile done');
    } catch (e) {
      debugPrint('❌ setChannelProfile FAILED: $e');
      return;
    }

    try {
      await engine.setClientRole(
        role: ClientRoleType.clientRoleAudience,
        options: const ClientRoleOptions(
          audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
        ),
      );
      debugPrint('✅ setClientRole AUDIENCE done');
    } catch (e) {
      debugPrint('❌ setClientRole FAILED: $e');
      return;
    }

    try {
      await engine.enableAudio();
      await engine.enableVideo();
      await engine.setDefaultAudioRouteToSpeakerphone(true);
      await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioGameStreaming,
      );
      debugPrint('✅ Audio/Video enabled');
    } catch (e) {
      debugPrint('❌ Audio/Video setup FAILED: $e');
      return;
    }

    // ✅ CRITICAL: assign engine BEFORE registering handlers and joining
    // so that onUserJoined, onJoinChannelSuccess etc. can use agoraEngine
    agoraEngine = engine;

    engine.registerEventHandler(
      RtcEngineEventHandler(
        // Agora engine error (add inside onError handler)
        onError: (err, msg) {
          debugPrint('❌ Agora Error: $err - $msg');
          // Only show popup for fatal errors, not minor ones
          final fatalCodes = [17, 110, 111, 112]; // token expired, not in channel, etc.
          if (fatalCodes.contains(err.index)) {
            showLiveExitPopup(LiveExitReason.connectionLost, onRejoin: () => hostMeeting());
          }
        },
        onJoinChannelSuccess: (connection, elapsed) async {
          try {
            debugPrint('✅ Joined: ${connection.channelId}, uid: ${connection.localUid}');
            isJoined.value = true;

            // ✅ NOW safe to set speaker — channel is active
            await agoraEngine?.setEnableSpeakerphone(true);
            await agoraEngine?.adjustPlaybackSignalVolume(200);
            await agoraEngine?.muteAllRemoteAudioStreams(false);

            await WakelockPlus.enable(); // 🔥 keep screen ON
            debugPrint('🌙 Wakelock enabled');
            debugPrint('✅ Speaker on, volume boosted');
          } catch (e) {
            debugPrint('❌ onJoinChannelSuccess handler error: $e');
          }
        },

        onUserJoined: (connection, uid, elapsed) async {
          try {
            debugPrint('🎥 Host joined: uid=$uid');

            // ✅ If this is the host
            if (hostUid.value == null) {
              // fallback (if backend didn’t provide)
              hostUid.value = uid;
              debugPrint('🎯 Assigned HOST uid=$uid');
            }

            // ✅ Always keep list (optional)
            if (!remoteUids.contains(uid)) {
              remoteUids.add(uid);
            }

            hasLiveStarted.value = true;
            hasLiveEnded.value = false;

            await agoraEngine?.muteRemoteAudioStream(uid: uid, mute: false);

            if (uid == hostUid.value) {
              startSessionTimer(); // ✅ only for host
            }
          } catch (e) {
            debugPrint('❌ onUserJoined handler error: $e');
          }
        },
        // Host left → ended
        onUserOffline: (connection, uid, reason) async {
          try {
            debugPrint('⚠️ Host left: uid=$uid, reason=$reason');
            remoteUids.remove(uid);
            if (uid == hostUid.value) {
              isSessionExiting = true;
              exitReason = LiveExitReason.ended;

              hostUid.value = null;
              hasLiveEnded.value = true;
              stopSessionTimer();

              await Future.delayed(const Duration(milliseconds: 300));

              showLiveExitPopup(LiveExitReason.ended);
            }
          } catch (e) {
            debugPrint('❌ onUserOffline handler error: $e');
          }
        },

        onUserMuteAudio: (connection, remoteUid, muted) {
          if (remoteUid == hostUid.value) {
            isHostAudioOn.value = !muted;
          }
        },
        onTokenPrivilegeWillExpire: (connection, token) {
          debugPrint('⚠️ Token expiring soon — refresh needed');
          // TODO: call backend to refresh token, then renewToken()
        },

        onConnectionStateChanged: (connection, state, reason) {
          debugPrint('🔵 Connection: $state, reason: $reason');

          // ✅ Handle unexpected disconnects
          // 🚨 KEY FIX
          if (isSessionExiting) {
            debugPrint('🟡 Ignoring connection change (intentional exit)');
            return;
          }

          if (state == ConnectionStateType.connectionStateDisconnected ||
              state == ConnectionStateType.connectionStateFailed) {
            _handleUnexpectedDisconnect();
          }
        },

        onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
          if (remoteUid != hostUid.value) return;
          try {
            debugPrint('🎥 Video state: uid=$remoteUid, state=$state');
            if (state == RemoteVideoState.remoteVideoStateStopped) {
              isHostVideoOn.value = false;
            } else if (state == RemoteVideoState.remoteVideoStateDecoding) {
              isHostVideoOn.value = true;
            }
          } catch (e) {
            debugPrint('❌ onRemoteVideoStateChanged error: $e');
          }
        },

        onRemoteAudioStateChanged: (connection, remoteUid, state, reason, elapsed) {
          try {
            debugPrint('🔊 Audio state: uid=$remoteUid, state=$state');

            if (state == RemoteAudioState.remoteAudioStateStopped) {
              isHostAudioOn.value = false;
            } else if (state == RemoteAudioState.remoteAudioStateDecoding) {
              isHostAudioOn.value = true;

              // ✅ Re-apply speaker AFTER audio track is active
              // This defeats Android's audio re-routing after track starts
              agoraEngine?.setEnableSpeakerphone(true).then((_) {
                debugPrint('🔊 Speaker re-applied after decode started');
              });
            }
          } catch (e) {
            debugPrint('❌ onRemoteAudioStateChanged error: $e');
          }
        },
        onClientRoleChanged: (connection, oldRole, newRole, newRoleOptions) {
          debugPrint('🔄 Role: $oldRole → $newRole');
        },

        onRemoteAudioStats: (connection, stats) {
          debugPrint(
            '📊 [AUDIO STATS] uid=${stats.uid} | bitrate=${stats.receivedBitrate} | quality=${stats.quality}',
          );
        },

        onAudioSubscribeStateChanged: (channel, uid, oldState, newState, elapsed) {
          debugPrint('🔊 [AUDIO SUB] uid=$uid | $oldState → $newState');
        },
      ),
    );

    debugPrint('🔵 Joining channel...');

    await engine.joinChannel(
      token: rtcToken.value,
      channelId: channelName.value,
      uid: uid.value,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
        audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );

    // ✅ No audio calls here — moved to onJoinChannelSuccess
    isEngineReady.value = true;
    debugPrint('🔵 Engine ready');
  }

  // Connection lost / unexpected disconnect
  // ✅ Handle unexpected disconnects (network loss etc.)
  void _handleUnexpectedDisconnect() {
    remoteUids.clear();
    isHostAudioOn.value = false;
    isHostVideoOn.value = false;
    hasLiveStarted.value = false;
    stopSessionTimer();
    showLiveExitPopup(
      LiveExitReason.connectionLost,
      onRejoin: () => hostMeeting(), // re-runs the full join flow
    );
  }

  /// ---------------- Speaking (Audience → Broadcaster) ---------------- ///
  var isSpeaking = false.obs;

  Future<void> toggleSpeak(LiveChatController cc) async {
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

      // ← notify web: mic is now OFF
      await _publishMuteState(isMuted: true, cc: cc);

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
      debugPrint('🎙️ [SPEAK] token: ${rtcToken.value.substring(0, 10)}...'); // partial for safety

      isSpeaking.value = true;

      // ← notify web: mic is now ON
      await _publishMuteState(isMuted: false, cc: cc);

      debugPrint('🎙️ [SPEAK] isSpeaking = true ✅ — web should now hear app user');
    }
  }

  Future<void> _publishMuteState({required bool isMuted, required LiveChatController cc}) async {
    try {
      if (!cc.isRtmReady.value || cc.rtmClient == null) return;

      // 1. Publish a channel message — web receives this via onMessage
      //    and updates the participant's isMuted state in its list
      final payload = jsonEncode({
        "type": "MUTE_STATE_CHANGE",
        "sender": uid.value.toString(),
        "isMuted": isMuted,
      });

      await cc.rtmClient!.publish(channelName.value, payload, channelType: RtmChannelType.message);

      // 2. Also update own presence state — for late joiners who get snapshot
      await cc.rtmClient!.getPresence().setState(channelName.value, RtmChannelType.message, {
        'isMuted': isMuted ? 'true' : 'false',
      });

      debugPrint('📡 [RTM] Mute state broadcast → uid=${uid.value}, isMuted=$isMuted');
    } catch (e) {
      debugPrint('❌ [RTM] _publishMuteState error: $e');
    }
  }

  /// --------------- Live Duration ---------------///

  /// -----------------

  // Add these
  final sessionStartTime = Rxn<DateTime>();
  final elapsedSeconds = 0.obs;
  Timer? _sessionTimer;

  // In MeetingController — replace startSessionTimer() call
  void startSessionTimer() {
    try {
      final startedAtRaw = sessionInfo.value.startedAt;

      /// ✅ Parse ISO string → DateTime (UTC)
      final startTime = startedAtRaw != null
          ? DateTime.parse(startedAtRaw).toLocal()
          : DateTime.now();

      sessionStartTime.value = startTime;

      /// ✅ Calculate elapsed time
      elapsedSeconds.value = DateTime.now().difference(startTime).inSeconds;

      /// ✅ Prevent negative (device time mismatch)
      if (elapsedSeconds.value < 0) {
        elapsedSeconds.value = 0;
      }

      /// ✅ Avoid multiple timers
      _sessionTimer?.cancel();

      /// ✅ Accurate ticking (no drift)
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsedSeconds.value = DateTime.now().difference(sessionStartTime.value!).inSeconds;
      });

      debugPrint('⏱️ Timer started — start: $startTime, elapsed: ${elapsedSeconds.value}s');
    } catch (e) {
      debugPrint('❌ Timer error: $e');
    }
  }

  void stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    debugPrint('⏱️ Session timer stopped');
  }

  String get formattedDuration {
    final s = elapsedSeconds.value;
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${sec.toString().padLeft(2, '0')}';
  }

  //
  /// Called by LiveChatController when host sends REMOTE_MUTE targeting this user
  Future<void> muteLocalAudio(bool mute, {required LiveChatController cc}) async {
    if (agoraEngine == null) return;

    isLocalAudioMuted.value = mute;

    if (isSpeaking.value) {
      await agoraEngine?.updateChannelMediaOptions(
        ChannelMediaOptions(
          publishMicrophoneTrack: !mute,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      if (mute) {
        await agoraEngine?.setClientRole(role: ClientRoleType.clientRoleAudience);
        await agoraEngine?.updateChannelMediaOptions(
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

    debugPrint('🔇 muteLocalAudio($mute) applied');
  }

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
    MainNavController.to.goToTab(4); // ← replace with your actual home/dashboard route
  }

  /// ---------------- Live State ---------------- ///
  var hasLiveStarted = false.obs;
  var hasLiveEnded = false.obs;

  /// Leave channel manually
  Future<void> leaveMeeting() async {
    debugPrint('🔵 leaveMeeting() called');

    stopSessionTimer();

    // ✅ Reset all visual state immediately so UI doesn't show stale data
    remoteUids.clear();
    isHostAudioOn.value = false;
    isHostVideoOn.value = false;
    hasLiveStarted.value = false;
    hasLiveEnded.value = false;
    isSpeaking.value = false;
    isEngineReady.value = false;

    await WakelockPlus.disable(); // 🔥 allow sleep again
    debugPrint('🌙 Wakelock disabled');

    if (agoraEngine != null) {
      try {
        await agoraEngine!.leaveChannel();
        debugPrint('✅ Left channel');
      } catch (e) {
        debugPrint('❌ leaveChannel error: $e');
      }

      try {
        await agoraEngine!.release(sync: true);
        debugPrint('✅ Engine released');
      } catch (e) {
        debugPrint('❌ release error: $e');
      }

      agoraEngine = null;
    }

    isJoined.value = false;
    debugPrint('✅ leaveMeeting complete');
  }

  @override
  void onClose() async {
    debugPrint('🔵 onClose called');
    await leaveMeeting(); // reuse the same logic
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