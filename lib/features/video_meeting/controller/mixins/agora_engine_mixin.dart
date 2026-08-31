import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:we_mama/core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import 'package:we_mama/core/helpers/permission_helper.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/config/agora_config.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../meeting_controller.dart';

mixin AgoraEngineMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  //
  // 👇 NEW: grace period handling for host disconnect vs real end
  Timer? _hostOfflineGraceTimer;
  bool _isEndedPopupShowing = false;
  bool _hasEndedDueToTimeout = false;
  bool _hasConfirmedHostEnded =
      false; // true only once the REAL HOST_ENDED_LIVE popup has shown

  BuildContext? _endedPopupContext;
  static const _hostOfflineGraceDuration = Duration(seconds: 8);

  final RxBool hasReceivedFirstHostFrame = false.obs;

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

          onFirstRemoteVideoFrame:
              (
                RtcConnection connection,
                int remoteUid,
                int width,
                int height,
                int elapsed,
              ) {
                if (remoteUid == hostUid.value) {
                  hasReceivedFirstHostFrame.value = true;
                }
              },

          /*
          onUserJoined: (connection, uid, elapsed) async {
            try {
              log('🎥 Host joined: uid=$uid');

              if (hostUid.value == null) {
                hostUid.value = uid;
                log('🎯 Assigned HOST uid=$uid');
              }

              if (!_self.remoteUids.contains(uid)) {
                _self.remoteUids.add(uid);
              }

              _self.hasLiveStarted.value = true;
              _self.hasLiveEnded.value = false;

              // ❌ Remove the muteRemoteAudioStream call here
              // ✅ Instead, set speaker on immediately
              await _self.agoraEngine?.setEnableSpeakerphone(true);

              if (uid == hostUid.value) {
                _self.startSessionTimer();
              }
            } catch (e) {
              log('❌ onUserJoined handler error: $e');
            }
          },
         */
          /*
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
*/
          onUserJoined: (connection, uid, elapsed) async {
            try {
              log('🎥 Host joined: uid=$uid');

              if (hostUid.value == null) {
                hostUid.value = uid;

                await _self.agoraEngine?.setupRemoteVideo(
                  VideoCanvas(
                    uid: uid,
                    renderMode: RenderModeType.renderModeFit,
                    setupMode:
                        VideoViewSetupMode.videoViewSetupReplace, // ✅ FIXED
                  ),
                );
                log('✅ Remote video renderer set up for uid=$uid');
              }

              // Cancel any pending grace timer (host reconnected in time)
              if (_hostOfflineGraceTimer != null) {
                log(
                  '🟢 Host rejoined before grace period expired — cancelling end flow',
                );
                _hostOfflineGraceTimer?.cancel();
                _hostOfflineGraceTimer = null;
              }

              // 👇 NEW: also recover if the session was already marked
              // "ended" (grace period had fully expired and popup shown),
              // but the host has now genuinely rejoined the same live.
              if (_hasEndedDueToTimeout || _isEndedPopupShowing) {
                log(
                  '🟢 Host rejoined AFTER grace period expired — reopening session, dismissing end popup',
                );
                // 👇 close THIS specific dialog via its own captured context
                if (_endedPopupContext != null &&
                    _endedPopupContext!.mounted &&
                    Navigator.of(_endedPopupContext!).canPop()) {
                  Navigator.of(_endedPopupContext!).pop();
                }
                _endedPopupContext = null;
                // if (_isEndedPopupShowing && (Get.isDialogOpen ?? false)) {
                //   Get.back();
                // }
                _isEndedPopupShowing = false;
                _hasEndedDueToTimeout = false;
                _hasConfirmedHostEnded = false;
                _self.isSessionExiting = false;
                _self.hasLiveEnded.value = false;
              }

              if (hostUid.value == null) {
                hostUid.value = uid;
                log('🎯 Assigned HOST uid=$uid');
              }

              if (!_self.remoteUids.contains(uid)) {
                _self.remoteUids.add(uid);
              }

              _self.hasLiveStarted.value = true;
              _self.hasLiveEnded.value = false;

              await _self.agoraEngine?.setEnableSpeakerphone(true);

              if (uid == hostUid.value) {
                _self.startSessionTimer();
              }
            } catch (e) {
              log('❌ onUserJoined handler error: $e');
            }
          },

          onUserOffline: (connection, uid, reason) async {
            try {
              log('⚠️ Host left: uid=$uid, reason=$reason');
              _self.remoteUids.remove(uid);

              if (uid == hostUid.value) {
                log(
                  '🟡 Host disconnected — waiting ${_hostOfflineGraceDuration.inSeconds}s to confirm real end',
                );

                _hostOfflineGraceTimer?.cancel();
                _hostOfflineGraceTimer = Timer(_hostOfflineGraceDuration, () async {
                  log(
                    '🟡 Host still offline after grace period — showing reconnecting popup, keeping engine joined so it can catch the host\'s rejoin',
                  );

                  // 👇 CHANGED: no isSessionExiting, no hasLiveEnded, no hostUid=null,
                  // no _releaseEngineOnly() here. We're only *presumed* offline — the
                  // backend keeps the live alive up to 3 more minutes waiting for the
                  // host, so we stay in the channel too. Only confirmHostEndedLive()
                  // (a real HOST_ENDED_LIVE) should tear the engine down.
                  _self.stopSessionTimer();

                  await Future.delayed(const Duration(milliseconds: 300));

                  _isEndedPopupShowing = true;
                  _hasEndedDueToTimeout = true;

                  showLiveExitPopup(
                    LiveExitReason.hostReconnecting, // 👈 CHANGED (was .ended)
                    onLeaveWhileWaiting: () async {
                      // user chose to actually leave while host is still presumed offline
                      _self.isSessionExiting = true;
                      _self.exitReason = LiveExitReason.voluntary;
                      await _releaseEngineOnly(); // 👈 real teardown happens HERE instead
                      Get.offAllNamed(RoutePaths.mainNav);
                      MainNavController.to.goToTab(4);
                    },
                    onDialogShown: (dialogContext) {
                      _endedPopupContext = dialogContext;
                    },
                  );

                  _hostOfflineGraceTimer = null;
                });
              }
            } catch (e) {
              log('❌ onUserOffline handler error: $e');
            }
          },

          //
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

          // onRemoteVideoStateChanged:
          //     (connection, remoteUid, state, reason, elapsed) {
          //       if (remoteUid != hostUid.value) return;
          //       try {
          //         log('🎥 Video state: uid=$remoteUid, state=$state');
          //         if (state == RemoteVideoState.remoteVideoStateStopped) {
          //           _self.isHostVideoOn.value = false;
          //         } else if (state ==
          //             RemoteVideoState.remoteVideoStateDecoding) {
          //           _self.isHostVideoOn.value = true;
          //         }
          //       } catch (e) {
          //         log('❌ onRemoteVideoStateChanged error: $e');
          //       }
          //     },
          onRemoteVideoStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
                if (remoteUid != hostUid.value) return;

                log(
                  '🎥 Remote video: '
                  'uid=$remoteUid | '
                  'state=$state | '
                  'reason=$reason',
                );

                switch (state) {
                  case RemoteVideoState.remoteVideoStateDecoding:
                    _self.isHostVideoOn.value = true;
                    break;

                  case RemoteVideoState.remoteVideoStateStopped:
                  case RemoteVideoState.remoteVideoStateFailed:
                  case RemoteVideoState.remoteVideoStateFrozen:
                    _self.isHostVideoOn.value = false;
                    break;

                  default:
                    break;
                }
              },
          // onRemoteAudioStateChanged:
          //     (connection, remoteUid, state, reason, elapsed) {
          //       try {
          //         log('🔊 Audio state: uid=$remoteUid, state=$state');

          //         if (state == RemoteAudioState.remoteAudioStateStopped ||
          //             state == RemoteAudioState.remoteAudioStateFailed) {
          //           _self.isHostAudioOn.value = false;
          //         } else if (state ==
          //             RemoteAudioState.remoteAudioStateDecoding) {
          //           _self.isHostAudioOn.value = true;

          //           // ✅ Re-apply speaker AFTER audio track is active
          //           // This defeats Android's audio re-routing after track starts
          //           _self.agoraEngine?.setEnableSpeakerphone(true).then((_) {
          //             log('🔊 Speaker re-applied after decode started');
          //           });
          //         }
          //       } catch (e) {
          //         log('❌ onRemoteAudioStateChanged error: $e');
          //       }
          //     },
          onRemoteAudioStateChanged:
              (connection, uid, state, reason, elapsed) async {
                log('🔊 Audio state: uid=$uid, state=$state, reason=$reason');

                // Audio stopped or failed — force a re-subscribe cycle
                if (state == RemoteAudioState.remoteAudioStateStopped ||
                    state == RemoteAudioState.remoteAudioStateFailed) {
                  await Future.delayed(const Duration(milliseconds: 800));

                  try {
                    await _self.agoraEngine?.muteRemoteAudioStream(
                      uid: uid,
                      mute: true,
                    );
                    await Future.delayed(const Duration(milliseconds: 300));
                    await _self.agoraEngine?.muteRemoteAudioStream(
                      uid: uid,
                      mute: false,
                    );
                    log('🔄 Re-subscribed audio for uid=$uid');
                  } catch (e) {
                    log('❌ Re-subscribe error: $e');
                  }
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

  //

  /// Tears down the RTC engine only — does NOT touch hasLiveEnded,
  /// isSessionExiting, or exitReason. Those are owned by whichever
  /// caller (confirmHostEndedLive, grace timeout, etc.) already
  /// decided the session is over; this just frees resources without
  /// clobbering the state that decision set.
  Future<void> _releaseEngineOnly() async {
    _self.remoteUids.clear();
    _self.isHostAudioOn.value = false;
    _self.isHostVideoOn.value = false;
    _self.isSpeaking.value = false;
    _self.isEngineReady.value = false;

    await WakelockPlus.disable();
    log('🌙 Wakelock disabled (engine-only release)');

    if (_self.agoraEngine != null) {
      try {
        await _self.agoraEngine!.leaveChannel();
        log('✅ Left channel (engine-only release)');
      } catch (e) {
        log('❌ leaveChannel error: $e');
      }
      try {
        await _self.agoraEngine!.release(sync: true);
        log('✅ Engine released (engine-only release)');
      } catch (e) {
        log('❌ release error: $e');
      }
      _self.agoraEngine = null;
    }

    _self.isJoined.value = false;
  }

  /// Called when RTM confirms the host explicitly ended the live —
  /// skip the grace timer and end immediately, no ambiguity.
  Future<void> confirmHostEndedLive() async {
    if (_hasConfirmedHostEnded) return;
    if (_hasEndedDueToTimeout) return; // already handled

    log('🔴 [RTM] Host confirmed end — skipping grace timer');
    _hostOfflineGraceTimer?.cancel();
    _hostOfflineGraceTimer = null;

    // 👇 NEW: close the "reconnecting" popup if it's currently up, so it
    // doesn't sit underneath the real "ended" popup.
    if (_isEndedPopupShowing &&
        _endedPopupContext != null &&
        _endedPopupContext!.mounted &&
        Navigator.of(_endedPopupContext!).canPop()) {
      Navigator.of(_endedPopupContext!).pop();
    }

    _self.isSessionExiting = true;
    _self.exitReason = LiveExitReason.ended;
    hostUid.value = null;
    _self.hasLiveEnded.value = true;
    _self.stopSessionTimer();

    // 👇 NEW: free the engine now — host is confirmed gone, no reason
    // to keep holding the channel/wakelock while the popup is up.
    await _releaseEngineOnly();

    await Future.delayed(const Duration(milliseconds: 300));

    _isEndedPopupShowing = true;
    _hasEndedDueToTimeout = true;

    _hasConfirmedHostEnded = true; // 👈 NEW

    showLiveExitPopup(
      LiveExitReason.ended,
      onDialogShown: (dialogContext) => _endedPopupContext = dialogContext,
    );
  }

  /// Call from the controller's onClose() to cancel any pending
  /// "host ended" grace timer, so it doesn't fire after disUserJoinedposal.
  void disposeAgoraEngineMixin() {
    _hostOfflineGraceTimer?.cancel();
    _hostOfflineGraceTimer = null;
    _hasConfirmedHostEnded = false;
    _isEndedPopupShowing = false;
    _hasEndedDueToTimeout = false;
    _endedPopupContext = null;
  }
}
