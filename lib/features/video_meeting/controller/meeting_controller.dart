import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:mama_app/app/service_export.dart';

import '../../../app/controller_export.dart';
import 'arg_model/meeting_ctrl_ag_model.dart';
import 'mixins/agora_engine_mixin.dart';
import 'mixins/leave_session_mixin.dart';
import 'mixins/session_info_mixin.dart';
import 'mixins/session_timer_mixin.dart';
import 'mixins/speaking_mixin.dart';

/*

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
    log('channelname arg: ${agrModel.channelname}');

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
      final data = await MeetingService().fetchSessionsInfo(
        channelName: agrModel.channelname,
      );

      if (data != null) {
        sessionInfo.value = data;

        /// Debug logs (VERY useful for Agora debugging)
        log('📦 Parsed model rtmToken: ${data.rtmToken}');
        log('📦 Parsed model rtcToken: ${data.rtcToken}');
        log('📦 Parsed model channel: ${data.channelName}');
        log('📦 Parsed model uid: ${data.uid}');
      }

      /// Small delay for smoother UX
      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      log('getSessionsInfo error: $e');
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
    log('🔵 [1] hostMeeting() started');

    /// Step 1: Fetch token & session data
    await getSessionsInfo();

    log('🔵 [2] sessionInfo after fetch:');
    log('   channelName: ${sessionInfo.value.channelName}');
    log('   rtmToken: ${sessionInfo.value.rtmToken}');
    log('   rtc_Token: ${sessionInfo.value.rtcToken}');
    log('   uid: ${sessionInfo.value.uid}');

    final fetchedRtmToken = sessionInfo.value.rtmToken;
    final fetchedRtcToken = sessionInfo.value.rtcToken;
    final fetchedChannel = sessionInfo.value.channelName;
    final fetchedUid = sessionInfo.value.uid;

    /// 🔴 Safety checks (must have valid data)
    if (fetchedRtmToken == null || fetchedRtmToken.isEmpty) {
      log('❌ Token is null or empty!');
      return;
    }

    if (fetchedChannel == null || fetchedChannel.isEmpty) {
      log('❌ ChannelName is null or empty!');
      return;
    }
    if (fetchedRtcToken == null || fetchedRtcToken.isEmpty) {
      log('❌ fetchedRtcToken is null or empty!');
      return;
    }

    /// Step 2: Assign values
    rtmToken.value = fetchedRtmToken;
    rtcToken.value = fetchedRtcToken;
    channelName.value = fetchedChannel;
    uid.value = fetchedUid ?? 0;
    appId.value = AgoraConfig.appId;

    log('🔵 [3] appId: ${appId.value}');
    log('🔵 [3] rtm token: ${rtmToken.value}');
    log('🔵 [3] rtcToken: ${rtcToken.value}');
    log('🔵 [3] channel: ${channelName.value}');
    log('🔵 [3] uid: ${uid.value}');

    /// Step 3: Initialize Agora
    await initAgora();
  }

  /// -------------------- Agora Setup -------------------- ///

  final hostUid = RxnInt(); // ✅ nullable int
  Future<void> initAgora() async {
    log('🔵 [4] initAgora() started');

    final granted = await requestPermissions();

    log("granted : $granted");

    if (granted) {
      // your codes here

      log('🔵 [5] Permissions granted');

      final engine = createAgoraRtcEngine();

      // ✅ Release any stale native engine
      try {
        await engine.release(sync: true);
        log('✅ Pre-release done');
      } catch (e) {
        log('⚠️ Pre-release skipped: $e');
      }

      await Future.delayed(const Duration(milliseconds: 300));

      try {
        await engine.initialize(RtcEngineContext(appId: appId.value));
        log('🔵 [6] Engine initialized');
      } catch (e) {
        log('❌ Engine init FAILED: $e');
        return;
      }

      try {
        await engine.setChannelProfile(
          ChannelProfileType.channelProfileLiveBroadcasting,
        );
        log('✅ setChannelProfile done');
      } catch (e) {
        log('❌ setChannelProfile FAILED: $e');
        return;
      }

      try {
        await engine.setClientRole(
          role: ClientRoleType.clientRoleAudience,
          options: const ClientRoleOptions(
            audienceLatencyLevel:
                AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
          ),
        );
        log('✅ setClientRole AUDIENCE done');
      } catch (e) {
        log('❌ setClientRole FAILED: $e');
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
        log('✅ Audio/Video enabled');
      } catch (e) {
        log('❌ Audio/Video setup FAILED: $e');
        return;
      }

      // ✅ CRITICAL: assign engine BEFORE registering handlers and joining
      // so that onUserJoined, onJoinChannelSuccess etc. can use agoraEngine
      agoraEngine = engine;

      engine.registerEventHandler(
        RtcEngineEventHandler(
          // Agora engine error (add inside onError handler)
          onError: (err, msg) {
            log('❌ Agora Error: $err - $msg');
            // Only show popup for fatal errors, not minor ones
            final fatalCodes = [
              17,
              110,
              111,
              112,
            ]; // token expired, not in channel, etc.
            if (fatalCodes.contains(err.index)) {
              showLiveExitPopup(
                LiveExitReason.connectionLost,
                onRejoin: () => hostMeeting(),
              );
            }
          },
          onJoinChannelSuccess: (connection, elapsed) async {
            try {
              log(
                '✅ Joined: ${connection.channelId}, uid: ${connection.localUid}',
              );
              isJoined.value = true;

              // ✅ NOW safe to set speaker — channel is active
              await agoraEngine?.setEnableSpeakerphone(true);
              await agoraEngine?.adjustPlaybackSignalVolume(200);
              await agoraEngine?.muteAllRemoteAudioStreams(false);

              await WakelockPlus.enable(); // 🔥 keep screen ON
              log('🌙 Wakelock enabled');
              log('✅ Speaker on, volume boosted');
            } catch (e) {
              log('❌ onJoinChannelSuccess handler error: $e');
            }
          },

          onUserJoined: (connection, uid, elapsed) async {
            try {
              log('🎥 Host joined: uid=$uid');

              // ✅ If this is the host
              if (hostUid.value == null) {
                // fallback (if backend didn’t provide)
                hostUid.value = uid;
                log('🎯 Assigned HOST uid=$uid');
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
              log('❌ onUserJoined handler error: $e');
            }
          },
          // Host left → ended
          onUserOffline: (connection, uid, reason) async {
            try {
              log('⚠️ Host left: uid=$uid, reason=$reason');
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
              log('❌ onUserOffline handler error: $e');
            }
          },

          onUserMuteAudio: (connection, remoteUid, muted) {
            if (remoteUid == hostUid.value) {
              isHostAudioOn.value = !muted;
            }
          },
          onTokenPrivilegeWillExpire: (connection, token) {
            log('⚠️ Token expiring soon — refresh needed');
            // TODO: call backend to refresh token, then renewToken()
          },

          onConnectionStateChanged: (connection, state, reason) {
            log('🔵 Connection: $state, reason: $reason');

            // ✅ Handle unexpected disconnects
            // 🚨 KEY FIX
            if (isSessionExiting) {
              log('🟡 Ignoring connection change (intentional exit)');
              return;
            }

            if (state == ConnectionStateType.connectionStateDisconnected ||
                state == ConnectionStateType.connectionStateFailed) {
              _handleUnexpectedDisconnect();
            }
          },

          onRemoteVideoStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
                if (remoteUid != hostUid.value) return;
                try {
                  log('🎥 Video state: uid=$remoteUid, state=$state');
                  if (state == RemoteVideoState.remoteVideoStateStopped) {
                    isHostVideoOn.value = false;
                  } else if (state ==
                      RemoteVideoState.remoteVideoStateDecoding) {
                    isHostVideoOn.value = true;
                  }
                } catch (e) {
                  log('❌ onRemoteVideoStateChanged error: $e');
                }
              },

          onRemoteAudioStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
                try {
                  log('🔊 Audio state: uid=$remoteUid, state=$state');

                  if (state == RemoteAudioState.remoteAudioStateStopped) {
                    isHostAudioOn.value = false;
                  } else if (state ==
                      RemoteAudioState.remoteAudioStateDecoding) {
                    isHostAudioOn.value = true;

                    // ✅ Re-apply speaker AFTER audio track is active
                    // This defeats Android's audio re-routing after track starts
                    agoraEngine?.setEnableSpeakerphone(true).then((_) {
                      log('🔊 Speaker re-applied after decode started');
                    });
                  }
                } catch (e) {
                  log('❌ onRemoteAudioStateChanged error: $e');
                }
              },
          onClientRoleChanged: (connection, oldRole, newRole, newRoleOptions) {
            log('🔄 Role: $oldRole → $newRole');
          },

          onRemoteAudioStats: (connection, stats) {
            log(
              '📊 [AUDIO STATS] uid=${stats.uid} | bitrate=${stats.receivedBitrate} | quality=${stats.quality}',
            );
          },

          onAudioSubscribeStateChanged:
              (channel, uid, oldState, newState, elapsed) {
                log('🔊 [AUDIO SUB] uid=$uid | $oldState → $newState');
              },
        ),
      );

      log('🔵 Joining channel...');

      await engine.joinChannel(
        token: rtcToken.value,
        channelId: channelName.value,
        uid: uid.value,
        options: const ChannelMediaOptions(
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
          publishCameraTrack: false,
          publishMicrophoneTrack: false,
          audienceLatencyLevel:
              AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
          clientRoleType: ClientRoleType.clientRoleAudience,
        ),
      );

      // ✅ No audio calls here — moved to onJoinChannelSuccess
      isEngineReady.value = true;
      log('🔵 Engine ready');
    } else {
      // optional extra handling
    }
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
      log('🔇 [SPEAK] Stepping down from broadcaster → audience');

      await agoraEngine?.setClientRole(role: ClientRoleType.clientRoleAudience);
      log('🔇 [SPEAK] setClientRole → AUDIENCE done');

      await agoraEngine?.updateChannelMediaOptions(
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

      await agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
      );
      log('🎙️ [SPEAK] setClientRole → BROADCASTER done');

      await agoraEngine?.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      log('🎙️ [SPEAK] updateChannelMediaOptions → mic PUBLISHED');

      // ✅ Confirm engine state
      log('🎙️ [SPEAK] agoraEngine is null: ${agoraEngine == null}');
      log('🎙️ [SPEAK] channel: ${channelName.value}');
      log('🎙️ [SPEAK] uid: ${uid.value}');
      log(
        '🎙️ [SPEAK] token: ${rtcToken.value.substring(0, 10)}...',
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
        "sender": uid.value.toString(),
        "isMuted": isMuted,
      });

      await cc.rtmClient!.publish(
        channelName.value,
        payload,
        channelType: RtmChannelType.message,
      );

      // 2. Also update own presence state — for late joiners who get snapshot
      await cc.rtmClient!.getPresence().setState(
        channelName.value,
        RtmChannelType.message,
        {'isMuted': isMuted ? 'true' : 'false'},
      );

      log(
        '📡 [RTM] Mute state broadcast → uid=${uid.value}, isMuted=$isMuted',
      );
    } catch (e) {
      log('❌ [RTM] _publishMuteState error: $e');
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
        elapsedSeconds.value = DateTime.now()
            .difference(sessionStartTime.value!)
            .inSeconds;
      });

      log(
        '⏱️ Timer started — start: $startTime, elapsed: ${elapsedSeconds.value}s',
      );
    } catch (e) {
      log('❌ Timer error: $e');
    }
  }

  void stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    log('⏱️ Session timer stopped');
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
  Future<void> muteLocalAudio(
    bool mute, {
    required LiveChatController cc,
  }) async {
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
        await agoraEngine?.setClientRole(
          role: ClientRoleType.clientRoleAudience,
        );
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

    log('🔇 muteLocalAudio($mute) applied');
  }

  var isSessionExiting = false;
  LiveExitReason? exitReason;

  /// Called by LiveChatController when host sends REMOTE_KICK targeting this user
  Future<void> leaveSession() async {
    log('🔴 leaveSession() — kicked by host');
    await leaveMeeting();

    // Navigate away after cleanup
    // Small delay so leaveMeeting() finishes before navigation
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAllNamed(RoutePaths.mainNav);
    MainNavController.to.goToTab(
      4,
    ); // ← replace with your actual home/dashboard route
  }

  /// ---------------- Live State ---------------- ///
  var hasLiveStarted = false.obs;
  var hasLiveEnded = false.obs;

  /// Leave channel manually
  Future<void> leaveMeeting() async {
    log('🔵 leaveMeeting() called');

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
    log('🌙 Wakelock disabled');

    if (agoraEngine != null) {
      try {
        await agoraEngine!.leaveChannel();
        log('✅ Left channel');
      } catch (e) {
        log('❌ leaveChannel error: $e');
      }

      try {
        await agoraEngine!.release(sync: true);
        log('✅ Engine released');
      } catch (e) {
        log('❌ release error: $e');
      }

      agoraEngine = null;
    }

    isJoined.value = false;
    log('✅ leaveMeeting complete');
  }

  @override
  void onClose() async {
    log('🔵 onClose called');
    await leaveMeeting(); // reuse the same logic
    inputMsgCtrl.dispose();
    inputMsgFocus.dispose();
    super.onClose();
  }
}
*/

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
