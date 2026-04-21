import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:mama_app/core/components/ui/dialogs/popups.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';
import 'package:mama_app/features/video_meeting/services/meeting_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../app/controller_export.dart';
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
  /*
  Future<void> initAgora() async {
    debugPrint('🔵 [4] initAgora() started');

    /// Ask permissions (camera/mic)
    await requestPermissions();
    debugPrint('🔵 [5] Permissions granted');

    // ✅ Always create + release first to reset native state
    final engine = createAgoraRtcEngine();

    try {
      await engine.release(sync: true); // force-clean native engine
      debugPrint('✅ Pre-release done (clears stale native state)');
    } catch (e) {
      debugPrint('⚠️ Pre-release skipped: $e'); // safe to ignore on first launch
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // Now initialize on a clean slate
    try {
      await engine.initialize(RtcEngineContext(appId: appId.value));
      debugPrint('🔵 [6] Engine initialized');
    } catch (e) {
      debugPrint('❌ Engine init FAILED: $e');
      return;
    }

    /// Clean previous engine if exists (VERY important)
    // if (agoraEngine != null) {
    //   debugPrint('⚠️ Releasing previous engine');
    //   await agoraEngine!.leaveChannel();
    //   await agoraEngine!.release();
    //   agoraEngine = null;

    //   await Future.delayed(const Duration(milliseconds: 500));
    // }

    // final engine = createAgoraRtcEngine();

    // /// Initialize engine
    // /// Initialize engine
    // try {
    //   await engine.initialize(RtcEngineContext(appId: appId.value));
    //   debugPrint('🔵 [6] Engine initialized');
    // } catch (e) {
    //   debugPrint('❌ Engine init FAILED: $e');
    //   return;
    // }

    // ✅ Step 1: Channel profile FIRST — before anything else
    try {
      await engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
      debugPrint('✅ setChannelProfile → LiveBroadcasting done');
    } catch (e) {
      debugPrint('❌ setChannelProfile FAILED: $e');
      return;
    }

    // ✅ Step 2: Client role second
    try {
      await engine.setClientRole(
        role: ClientRoleType.clientRoleAudience,
        options: const ClientRoleOptions(
          audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
        ),
      );
      debugPrint('✅ setClientRole → AUDIENCE with low latency done');
    } catch (e) {
      debugPrint('❌ setClientRole FAILED: $e');
      return;
    }

    // ✅ Step 3: Audio/video after profile is set
    try {
      await engine.enableAudio();
      debugPrint('✅ enableAudio done');
    } catch (e) {
      debugPrint('❌ enableAudio FAILED: $e');
      return;
    }

    try {
      await engine.setDefaultAudioRouteToSpeakerphone(true);
      debugPrint('✅ setDefaultAudioRouteToSpeakerphone done');
    } catch (e) {
      debugPrint('❌ setDefaultAudioRouteToSpeakerphone FAILED: $e');
    }

    try {
      await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioDefault,
      );
      debugPrint('✅ setAudioProfile done');
    } catch (e) {
      debugPrint('❌ setAudioProfile FAILED: $e');
    }

    try {
      await engine.enableVideo();
      debugPrint('✅ enableVideo done');
    } catch (e) {
      debugPrint('❌ enableVideo FAILED: $e');
      return;
    }

    /// 👤 USER ROLE = AUDIENCE (viewer-only app)
    // try {
    //   await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    //   debugPrint('🔵 [7] Role = AUDIENCE ✅');
    // } catch (e) {
    //   debugPrint('❌ setClientRole FAILED: $e');
    //   return;
    // }

    debugPrint('🔵 [7] Role = AUDIENCE');

    /// -------------------- Event Handlers -------------------- ///
    ///

    try {
      engine.registerEventHandler(
        RtcEngineEventHandler(
          onError: (err, msg) {
            debugPrint('❌ Agora Error: $err - $msg');
          },

          onJoinChannelSuccess: (connection, elapsed) {
            try {
              debugPrint('✅ Joined channel: ${connection.channelId}, uid: ${connection.localUid}');

              isJoined.value = true;
            } catch (e) {
              debugPrint('❌ onJoinChannelSuccess handler error: $e');
            }
          },

          onUserJoined: (connection, uid, elapsed) async {
            try {
              debugPrint('🎥 Host joined: uid=$uid');
              remoteUids.add(uid);
              hasLiveStarted.value = true;
              hasLiveEnded.value = false;

              /// 🔥 FORCE AUDIO SUBSCRIBE (THIS FIXES YOUR ISSUE)
              await agoraEngine?.muteRemoteAudioStream(uid: uid, mute: false);
              debugPrint('🔊 Forced audio subscribe for uid=$uid');
              // ✅ Start timer the moment host video appears
              startSessionTimer();
            } catch (e) {
              debugPrint('❌ onUserJoined handler error: $e');
            }
          },

          onUserOffline: (connection, uid, reason) async {
            try {
              debugPrint('⚠️ Host left: uid=$uid');
              remoteUids.remove(uid);
              if (hasLiveStarted.value && remoteUids.isEmpty) {
                hasLiveEnded.value = true;

                // show a popup saying: the live has ended.

                await Future.delayed(Duration(milliseconds: 300));

                showLiveEndMsg();
              }
            } catch (e) {
              debugPrint('❌ onUserOffline handler error: $e');
            }
          },

          onTokenPrivilegeWillExpire: (connection, token) {
            try {
              debugPrint('⚠️ Token expiring soon');
              // TODO: refresh token from backend here
            } catch (e) {
              debugPrint('❌ onTokenPrivilegeWillExpire handler error: $e');
            }
          },

          onConnectionStateChanged: (connection, state, reason) {
            try {
              debugPrint('🔵 Connection: $state, reason: $reason');
            } catch (e) {
              debugPrint('❌ onConnectionStateChanged handler error: $e');
            }
          },

          onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
            try {
              debugPrint('🎥 Video state: uid=$remoteUid, state=$state');

              if (state == RemoteVideoState.remoteVideoStateStopped) {
                isHostVideoOn.value = false;
              } else if (state == RemoteVideoState.remoteVideoStateDecoding) {
                isHostVideoOn.value = true;
              }
            } catch (e) {
              debugPrint('❌ onRemoteVideoStateChanged handler error: $e');
            }
          },

          onClientRoleChanged: (connection, oldRole, newRole, newRoleOptions) {
            try {
              debugPrint('🔄 [ROLE CHANGE] $oldRole → $newRole');
              debugPrint('   channel: ${connection.channelId}');
              debugPrint('   localUid: ${connection.localUid}');
              if (newRole == ClientRoleType.clientRoleBroadcaster) {
                debugPrint('   ✅ Now BROADCASTER — web CAN hear this user');
              } else {
                debugPrint('   ✅ Now AUDIENCE — web can NO LONGER hear this user');
              }
            } catch (e) {
              debugPrint('❌ onClientRoleChanged handler error: $e');
            }
          },

          onRemoteAudioStateChanged: (connection, remoteUid, state, reason, elapsed) {
            try {
              debugPrint('🔊 Audio state: uid=$remoteUid, state=$state');

              if (state == RemoteAudioState.remoteAudioStateStopped) {
                isHostAudioOn.value = false;
              } else if (state == RemoteAudioState.remoteAudioStateDecoding) {
                isHostAudioOn.value = true;
              }
            } catch (e) {
              debugPrint('❌ onRemoteAudioStateChanged handler error: $e');
            }
          },

          // ← ADD: fires every 2s with live audio stats per remote uid
          onRemoteAudioStats: (connection, stats) {
            debugPrint(
              '📊 [AUDIO STATS] uid=${stats.uid} '
              '| receivedBitrate=${stats.receivedBitrate} '
              '| totalFrozenTime=${stats.totalFrozenTime} '
              '| quality=${stats.quality}',
            );
            // If receivedBitrate is 0 every time → host is not publishing audio
            // If quality is 0 → network issue
          },

          // ← ADD: fires when audio subscribing state changes
          onAudioSubscribeStateChanged: (channel, uid, oldState, newState, elapseSinceLastState) {
            debugPrint(
              '🔊 [AUDIO SUBSCRIBE] uid=$uid '
              '| $oldState → $newState '
              '| elapsed=${elapseSinceLastState}ms',
            );
            // Should see: subscribing → subscribed
            // If stuck at "idle" → autoSubscribeAudio not working
          },

          //
        ),
      );
      debugPrint('✅ Event handlers registered');
    } catch (e) {
      debugPrint('❌ registerEventHandler FAILED: $e');
      return;
    }

    /// -------------------- Join Channel -------------------- ///
    debugPrint('🔵 Joining channel...');

    await engine.joinChannel(
      token: rtcToken.value, // for live streaming
      channelId: channelName.value,
      uid: uid.value,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,

        /// ❌ Viewer app → no publishing
        publishCameraTrack: false,
        publishMicrophoneTrack: false,

        audienceLatencyLevel: // ← ADD THIS
            AudienceLatencyLevelType.audienceLatencyLevelLowLatency,

        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );

    // ✅ ADD THESE — must be called AFTER joinChannel
    await engine.setEnableSpeakerphone(true); // forces speaker output NOW
    await engine.adjustPlaybackSignalVolume(200);
    await engine.muteAllRemoteAudioStreams(false);

    debugPrint('✅ Playback volume boosted to 400');

    agoraEngine = engine;

    /// UI can now render video
    isEngineReady.value = true;

    debugPrint('🔵 Engine ready');
  }
*/

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
        onError: (err, msg) {
          debugPrint('❌ Agora Error: $err - $msg');
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

        onUserOffline: (connection, uid, reason) async {
          try {
            debugPrint('⚠️ Host left: uid=$uid, reason=$reason');
            remoteUids.remove(uid);

            if (uid == hostUid.value) {
              debugPrint('❌ HOST LEFT');

              hostUid.value = null;
              isHostAudioOn.value = false;
              isHostVideoOn.value = false;

              hasLiveEnded.value = true;
              stopSessionTimer();

              showLiveEndMsg();
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
          if (state == ConnectionStateType.connectionStateDisconnected ||
              state == ConnectionStateType.connectionStateFailed) {
            debugPrint('⚠️ Disconnected — cleaning up');
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

  // ✅ Handle unexpected disconnects (network loss etc.)
  void _handleUnexpectedDisconnect() {
    remoteUids.clear();
    isHostAudioOn.value = false;
    isHostVideoOn.value = false;
    hasLiveStarted.value = false;
    stopSessionTimer();
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
      debugPrint('🎙️ [SPEAK] token: ${rtcToken.value.substring(0, 10)}...'); // partial for safety

      isSpeaking.value = true;
      debugPrint('🎙️ [SPEAK] isSpeaking = true ✅ — web should now hear app user');
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