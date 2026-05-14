

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:mama_app/core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import 'package:mama_app/core/helpers/permission_helper.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/config/agora_config.dart';
import '../meeting_controller.dart';

mixin AgoraEngineMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  /// -------------------- Start Flow -------------------- ///
  Future<void> hostMeeting() async {
    log('🔵 [1] hostMeeting() started');

    /// Step 1: Fetch token & session data
    await _self.getSessionsInfo();

    log('🔵 [2] sessionInfo after fetch:');
    log('   channelName: ${_self.sessionInfo.value.channelName}');
    log('   rtmToken: ${_self.sessionInfo.value.rtmToken}');
    log('   rtc_Token: ${_self.sessionInfo.value.rtcToken}');
    log('   uid: ${_self.sessionInfo.value.uid}');

    final fetchedRtmToken = _self.sessionInfo.value.rtmToken;
    final fetchedRtcToken = _self.sessionInfo.value.rtcToken;
    final fetchedChannel = _self.sessionInfo.value.channelName;
    final fetchedUid = _self.sessionInfo.value.uid;

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
    _self.rtmToken.value = fetchedRtmToken;
    _self.rtcToken.value = fetchedRtcToken;
    _self.channelName.value = fetchedChannel;
    _self.uid.value = fetchedUid ?? 0;
    _self.appId.value = AgoraConfig.appId;

    log('🔵 [3] appId: ${_self.appId.value}');
    log('🔵 [3] rtm token: ${_self.rtmToken.value}');
    log('🔵 [3] rtcToken: ${_self.rtcToken.value}');
    log('🔵 [3] channel: ${_self.channelName.value}');
    log('🔵 [3] uid: ${_self.uid.value}');

    /// Step 3: Initialize Agora
    await initAgora();
  }

  /// -------------------- Agora Setup -------------------- ///

  final hostUid = RxnInt(); // ✅ nullable int
  Future<void> initAgora() async {
    log('🔵 [4] initAgora() started');

    final granted = await requestPermissions();

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
        await engine.initialize(RtcEngineContext(appId: _self.appId.value));
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
      _self.agoraEngine = engine;

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
              _self.isJoined.value = true;

              // ✅ NOW safe to set speaker — channel is active
              await _self.agoraEngine?.setEnableSpeakerphone(true);
              await _self.agoraEngine?.adjustPlaybackSignalVolume(200);
              await _self.agoraEngine?.muteAllRemoteAudioStreams(false);

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
                // fallback (if backend didn't provide)
                hostUid.value = uid;
                log('🎯 Assigned HOST uid=$uid');
              }

              // ✅ Always keep list (optional)
              if (!_self.remoteUids.contains(uid)) {
                _self.remoteUids.add(uid);
              }

              _self.hasLiveStarted.value = true;
              _self.hasLiveEnded.value = false;

              await _self.agoraEngine?.muteRemoteAudioStream(
                uid: uid,
                mute: false,
              );

              if (uid == hostUid.value) {
                _self.startSessionTimer(); // ✅ only for host
              }
            } catch (e) {
              log('❌ onUserJoined handler error: $e');
            }
          },
          // Host left → ended
          onUserOffline: (connection, uid, reason) async {
            try {
              log('⚠️ Host left: uid=$uid, reason=$reason');
              _self.remoteUids.remove(uid);
              if (uid == hostUid.value) {
                _self.isSessionExiting = true;
                _self.exitReason = LiveExitReason.ended;

                hostUid.value = null;
                _self.hasLiveEnded.value = true;
                _self.stopSessionTimer();

                await Future.delayed(const Duration(milliseconds: 300));

                showLiveExitPopup(LiveExitReason.ended);
              }
            } catch (e) {
              log('❌ onUserOffline handler error: $e');
            }
          },

          onUserMuteAudio: (connection, remoteUid, muted) {
            if (remoteUid == hostUid.value) {
              _self.isHostAudioOn.value = !muted;
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
            if (_self.isSessionExiting) {
              log('🟡 Ignoring connection change (intentional exit)');
              return;
            }

            if (state == ConnectionStateType.connectionStateDisconnected ||
                state == ConnectionStateType.connectionStateFailed) {
              _self.handleUnexpectedDisconnect();
            }
          },

          onRemoteVideoStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
                if (remoteUid != hostUid.value) return;
                try {
                  log('🎥 Video state: uid=$remoteUid, state=$state');
                  if (state == RemoteVideoState.remoteVideoStateStopped) {
                    _self.isHostVideoOn.value = false;
                  } else if (state ==
                      RemoteVideoState.remoteVideoStateDecoding) {
                    _self.isHostVideoOn.value = true;
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
                    _self.isHostAudioOn.value = false;
                  } else if (state ==
                      RemoteAudioState.remoteAudioStateDecoding) {
                    _self.isHostAudioOn.value = true;

                    // ✅ Re-apply speaker AFTER audio track is active
                    // This defeats Android's audio re-routing after track starts
                    _self.agoraEngine?.setEnableSpeakerphone(true).then((_) {
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
        token: _self.rtcToken.value,
        channelId: _self.channelName.value,
        uid: _self.uid.value,
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
      _self.isEngineReady.value = true;
      log('🔵 Engine ready');
    } else {
      // optional extra handling
    }
  }

  // Connection lost / unexpected disconnect
  // ✅ Handle unexpected disconnects (network loss etc.)
  void handleUnexpectedDisconnect() {
    _self.remoteUids.clear();
    _self.isHostAudioOn.value = false;
    _self.isHostVideoOn.value = false;
    _self.hasLiveStarted.value = false;
    _self.stopSessionTimer();
    showLiveExitPopup(
      LiveExitReason.connectionLost,
      onRejoin: () => hostMeeting(), // re-runs the full join flow
    );
  }
}
