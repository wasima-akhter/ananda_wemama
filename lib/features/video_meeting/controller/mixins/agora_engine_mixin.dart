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

  final RxBool hasVideoInitError = false.obs;

  /// -------------------- Start Flow -------------------- ///
  Future<void> hostMeeting() async {
    print('🔴 ===== HOSTMEETING CALLED ====='); // Move to the VERY FIRST line
    print(
      '🔴 ===== print HOSTMEETING CALLED =====',
    ); // Move to the VERY FIRST line
    print('🔵 [1] hostMeeting() started');
    print('🔵 [1] hostMeeting() started');
    hasVideoInitError.value = false;

    /// Step 1: Fetch token & session data
    await _self.getSessionsInfo();

    print('🔵 [2] sessionInfo after fetch:');
    print('   channelName: ${_self.sessionInfo.value.channelName}');
    print('   rtmToken: ${_self.sessionInfo.value.rtmToken}');
    print('   rtc_Token: ${_self.sessionInfo.value.rtcToken}');
    print('   uid: ${_self.sessionInfo.value.uid}');

    final fetchedRtmToken = _self.sessionInfo.value.rtmToken;
    final fetchedRtcToken = _self.sessionInfo.value.rtcToken;
    final fetchedChannel = _self.sessionInfo.value.channelName;
    final fetchedUid = _self.sessionInfo.value.uid;

    /// 🔴 Safety checks (must have valid data)
    if (fetchedRtmToken == null || fetchedRtmToken.isEmpty) {
      print('❌ Token is null or empty!');
      hasVideoInitError.value = true;
      return;
    }

    if (fetchedChannel == null || fetchedChannel.isEmpty) {
      print('❌ ChannelName is null or empty!');
      hasVideoInitError.value = true;
      return;
    }
    if (fetchedRtcToken == null || fetchedRtcToken.isEmpty) {
      print('❌ fetchedRtcToken is null or empty!');
      hasVideoInitError.value = true;
      return;
    }

    /// Step 2: Assign values
    _self.rtmToken.value = fetchedRtmToken;
    _self.rtcToken.value = fetchedRtcToken;
    _self.channelName.value = fetchedChannel;
    _self.uid.value = fetchedUid ?? 0;
    _self.appId.value = AgoraConfig.appId;

    print('🔵 [3] appId: ${_self.appId.value}');
    print('🔵 [3] rtm token: ${_self.rtmToken.value}');
    print('🔵 [3] rtcToken: ${_self.rtcToken.value}');
    print('🔵 [3] channel: ${_self.channelName.value}');
    print('🔵 [3] uid: ${_self.uid.value}');

    /// Step 3: Initialize Agora
    await initAgora();
  }

  /// -------------------- Agora Setup -------------------- ///

  Timer? _videoOffDebounceTimer;

  Timer? _videoFrozenDebounceTimer;

  Timer? _watchdogTimer;

  final hostUid = RxnInt(); // ✅ nullable int
  Future<void> initAgora() async {
    print('🔵 [4] initAgora() started');

    final granted = await requestPermissions();

    if (granted) {
      // your codes here

      print('🔵 [5] Permissions granted');

      final engine = createAgoraRtcEngine();

      // ✅ Release any stale native engine
      try {
        await engine.release(sync: true);
        print('✅ Pre-release done');
      } catch (e) {
        print('⚠️ Pre-release skipped: $e');
      }

      // 🔴 FIX: Add a longer delay in Release builds
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        await engine.initialize(RtcEngineContext(appId: _self.appId.value));
        print('🔵 [6] Engine initialized');
      } catch (e) {
        print('❌ Engine init FAILED: $e');
        return;
      }

      try {
        await engine.setChannelProfile(
          ChannelProfileType.channelProfileLiveBroadcasting,
        );
        print('✅ setChannelProfile done');
      } catch (e) {
        print('❌ setChannelProfile FAILED: $e');
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
        print('✅ setClientRole AUDIENCE done');
      } catch (e) {
        print('❌ setClientRole FAILED: $e');
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
        print('✅ Audio/Video enabled');
      } catch (e) {
        print('❌ Audio/Video setup FAILED: $e');
        return;
      }

      // ✅ CRITICAL: assign engine BEFORE registering handlers and joining
      // so that onUserJoined, onJoinChannelSuccess etc. can use agoraEngine
      _self.agoraEngine = engine;
      // 🔴 FIX: Add delay BEFORE registering event handlers
      await Future.delayed(const Duration(milliseconds: 300));
      engine.registerEventHandler(
        RtcEngineEventHandler(
          // Agora engine error (add inside onError handler)
          onError: (err, msg) {
            print('❌ Agora Error: $err - $msg');
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
              print(
                '✅ Joined: ${connection.channelId}, uid: ${connection.localUid}',
              );
              _self.isJoined.value = true;

              // ✅ NOW safe to set speaker — channel is active
              await _self.agoraEngine?.setEnableSpeakerphone(true);
              await _self.agoraEngine?.adjustPlaybackSignalVolume(200);
              await _self.agoraEngine?.muteAllRemoteAudioStreams(false);

              await WakelockPlus.enable(); // 🔥 keep screen ON
              print('🌙 Wakelock enabled');
              print('✅ Speaker on, volume boosted');
            } catch (e) {
              print('❌ onJoinChannelSuccess handler error: $e');
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
             print('🎥 Host joined: uid=$uid');

              if (hostUid.value == null) {
                hostUid.value = uid;
               print('🎯 Assigned HOST uid=$uid');
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
             print('❌ onUserJoined handler error: $e');
            }
          },
         */
          /*
          onUserOffline: (connection, uid, reason) async {
            try {
             print('⚠️ Host left: uid=$uid, reason=$reason');
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
             print('❌ onUserOffline handler error: $e');
            }
          },
*/
          onUserJoined: (connection, uid, elapsed) async {
            try {
              print('🎥 Host joined: uid=$uid');

              // 🔴 FIX: Use dart:developer log instead of print for Release builds
              print('🎥 ===== CRITICAL: onUserJoined fired: uid=$uid =====');
              print('🎥 hostUid before: ${hostUid.value}');

              if (hostUid.value == null) {
                hostUid.value = uid;
                print('🎥 ✅ Set hostUid to: $uid');
              }

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
                print('✅ Remote video renderer set up for uid=$uid');
              }

              // Cancel any pending grace timer (host reconnected in time)
              if (_hostOfflineGraceTimer != null) {
                print(
                  '🟢 Host rejoined before grace period expired — cancelling end flow',
                );
                _hostOfflineGraceTimer?.cancel();
                _hostOfflineGraceTimer = null;
              }

              // 👇 NEW: also recover if the session was already marked
              // "ended" (grace period had fully expired and popup shown),
              // but the host has now genuinely rejoined the same live.
              if (_hasEndedDueToTimeout || _isEndedPopupShowing) {
                print(
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
                print('🎯 Assigned HOST uid=$uid');
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
              print('❌ onUserJoined handler error: $e');
            }
          },

          onUserOffline: (connection, uid, reason) async {
            try {
              print('⚠️ Host left: uid=$uid, reason=$reason');
              _self.remoteUids.remove(uid);

              if (uid == hostUid.value) {
                print(
                  '🟡 Host disconnected — waiting ${_hostOfflineGraceDuration.inSeconds}s to confirm real end',
                );

                _hostOfflineGraceTimer?.cancel();
                _hostOfflineGraceTimer = Timer(_hostOfflineGraceDuration, () async {
                  print(
                    '🟡 Host still offline after grace period — showing reconnecting popup, keeping engine joined so it can catch the host\'s rejoin',
                  );

                  // 👇 CHANGED: no isSessionExiting, no hasLiveEnded, no hostUid=null,
                  // no _releaseEngineOnly() here. We're only *presumed* offline — the
                  // backend keeps the live alive up to 3 more minutes waiting for the
                  // host, so we stay in the channel too. Only confirmHostEndedLive()
                  // (a real HOST_ENDED_LIVE) should tear the engine down.
                  _self.stopSessionTimer();

                  // 🔴 FIX: Add a longer delay in Release builds
                  await Future.delayed(const Duration(milliseconds: 500));

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
              print('❌ onUserOffline handler error: $e');
            }
          },

          //
          onUserMuteAudio: (connection, remoteUid, muted) {
            if (remoteUid == hostUid.value) {
              _self.isHostAudioOn.value = !muted;
            }
          },
          onTokenPrivilegeWillExpire: (connection, token) {
            print('⚠️ Token expiring soon — refresh needed');
            // TODO: call backend to refresh token, then renewToken()
          },

          onConnectionStateChanged: (connection, state, reason) {
            print('🔵 Connection: $state, reason: $reason');

            // ✅ Handle unexpected disconnects
            // 🚨 KEY FIX
            if (_self.isSessionExiting) {
              print('🟡 Ignoring connection change (intentional exit)');
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
          //        print('🎥 Video state: uid=$remoteUid, state=$state');
          //         if (state == RemoteVideoState.remoteVideoStateStopped) {
          //           _self.isHostVideoOn.value = false;
          //         } else if (state ==
          //             RemoteVideoState.remoteVideoStateDecoding) {
          //           _self.isHostVideoOn.value = true;
          //         }
          //       } catch (e) {
          //        print('❌ onRemoteVideoStateChanged error: $e');
          //       }
          //     },
          onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
            if (remoteUid != hostUid.value) return;

            print(
              '🎥 REMOTE VIDEO | '
              'uid=$remoteUid | '
              'state=$state | '
              'reason=$reason | '
              'elapsed=${elapsed}ms',
            );

            switch (state) {
              case RemoteVideoState.remoteVideoStateStarting:
                print(
                  '🟡 REMOTE VIDEO STARTING | '
                  'uid=$remoteUid | '
                  'reason=$reason | '
                  'elapsed=${elapsed}ms | '
                  '→ VideoStatus.loading',
                );

                _videoOffDebounceTimer?.cancel();
                print('🟡 REMOTE VIDEO | Off debounce timer cancelled');

                _videoFrozenDebounceTimer?.cancel();
                print('🟡 REMOTE VIDEO | Frozen debounce timer cancelled');

                _self.isHostVideoOn.value = VideoStatus.loading;

                print(
                  '🟡 REMOTE VIDEO | isHostVideoOn=${_self.isHostVideoOn.value}',
                );
                break;

              case RemoteVideoState.remoteVideoStateDecoding:
                print(
                  '🟢 REMOTE VIDEO DECODING | '
                  'uid=$remoteUid | '
                  'reason=$reason | '
                  'elapsed=${elapsed}ms | '
                  '→ VideoStatus.on',
                );

                _videoOffDebounceTimer?.cancel();
                print('🟢 REMOTE VIDEO | Off debounce timer cancelled');

                _videoFrozenDebounceTimer?.cancel();
                print('🟢 REMOTE VIDEO | Frozen debounce timer cancelled');

                _self.isHostVideoOn.value = VideoStatus.on;

                print(
                  '🟢 REMOTE VIDEO | isHostVideoOn=${_self.isHostVideoOn.value}',
                );
                break;

              /*
              case RemoteVideoState.remoteVideoStateFrozen:
                print(
                  '🟠 REMOTE VIDEO FROZEN | '
                  'uid=$remoteUid | '
                  'reason=$reason | '
                  'elapsed=${elapsed}ms | '
                  'Starting 2000ms debounce',
                );

                _videoFrozenDebounceTimer?.cancel();
                print('🟠 REMOTE VIDEO | Previous frozen timer cancelled');

                _videoFrozenDebounceTimer = Timer(
                  const Duration(milliseconds: 2000),
                  () {
                    print(
                      '🟠 REMOTE VIDEO FROZEN TIMEOUT | '
                      'uid=$remoteUid | '
                      'Frozen for 2000ms',
                    );

                    if (_self.isHostVideoOn.value != VideoStatus.off) {
                      _self.isHostVideoOn.value = VideoStatus.frozen;

                      print(
                        '🟠 REMOTE VIDEO | '
                        'isHostVideoOn=${_self.isHostVideoOn.value}',
                      );
                    } else {
                      print(
                        '🟠 REMOTE VIDEO | '
                        'Already OFF, keeping VideoStatus.off',
                      );
                    }
                  },
                );

                print('🟠 REMOTE VIDEO | Frozen debounce timer started');
                break;
*/
              case RemoteVideoState.remoteVideoStateFrozen:
                // ✅ Ignore frozen from network congestion
                if (reason ==
                    RemoteVideoStateReason
                        .remoteVideoStateReasonNetworkCongestion) {
                  print(
                    '⚠️ Network congestion detected (${elapsed}ms) - '
                    'keeping last frame visible, not showing frozen UI',
                  );
                  // DO NOT change isHostVideoOn - keep showing last frame
                  break;
                }

                print(
                  '🟠 REMOTE VIDEO FROZEN | '
                  'uid=$remoteUid | '
                  'reason=$reason | '
                  'elapsed=${elapsed}ms',
                );

                _videoFrozenDebounceTimer?.cancel();

                _videoFrozenDebounceTimer = Timer(
                  const Duration(milliseconds: 2000),
                  () {
                    if (_self.isHostVideoOn.value != VideoStatus.off) {
                      _self.isHostVideoOn.value = VideoStatus.frozen;

                      print(
                        '🟠 REMOTE VIDEO | '
                        'Frozen for 2s | '
                        'isHostVideoOn=${_self.isHostVideoOn.value}',
                      );
                    }
                  },
                );
                break;

              //
              case RemoteVideoState.remoteVideoStateStopped:
                print(
                  '🔴 REMOTE VIDEO STOPPED | '
                  'uid=$remoteUid | '
                  'reason=$reason | '
                  'elapsed=${elapsed}ms | '
                  'Starting 3000ms off debounce',
                );

                _videoOffDebounceTimer?.cancel();
                print('🔴 REMOTE VIDEO | Previous off timer cancelled');

                _videoFrozenDebounceTimer?.cancel();
                print('🔴 REMOTE VIDEO | Frozen timer cancelled');

                _videoOffDebounceTimer = Timer(
                  const Duration(milliseconds: 3000),
                  () {
                    print(
                      '🔴 REMOTE VIDEO STOPPED TIMEOUT | '
                      'uid=$remoteUid | '
                      '3000ms elapsed | '
                      '→ VideoStatus.off',
                    );

                    _self.isHostVideoOn.value = VideoStatus.off;

                    print(
                      '🔴 REMOTE VIDEO | '
                      'isHostVideoOn=${_self.isHostVideoOn.value}',
                    );
                  },
                );

                print('🔴 REMOTE VIDEO | Off debounce timer started');
                break;

              case RemoteVideoState.remoteVideoStateFailed:
                print(
                  '❌ REMOTE VIDEO FAILED | '
                  'uid=$remoteUid | '
                  'reason=$reason | '
                  'elapsed=${elapsed}ms | '
                  'Starting 3000ms off debounce',
                );

                _videoOffDebounceTimer?.cancel();
                print('❌ REMOTE VIDEO | Previous off timer cancelled');

                _videoFrozenDebounceTimer?.cancel();
                print('❌ REMOTE VIDEO | Frozen timer cancelled');

                _videoOffDebounceTimer = Timer(
                  const Duration(milliseconds: 3000),
                  () {
                    print(
                      '❌ REMOTE VIDEO FAILED TIMEOUT | '
                      'uid=$remoteUid | '
                      '3000ms elapsed | '
                      '→ VideoStatus.off',
                    );

                    _self.isHostVideoOn.value = VideoStatus.off;

                    print(
                      '❌ REMOTE VIDEO | '
                      'isHostVideoOn=${_self.isHostVideoOn.value}',
                    );
                  },
                );

                print('❌ REMOTE VIDEO | Off debounce timer started');
                break;

              default:
                print(
                  '⚪ REMOTE VIDEO UNKNOWN STATE | '
                  'uid=$remoteUid | '
                  'state=$state | '
                  'reason=$reason | '
                  'elapsed=${elapsed}ms',
                );
                break;
            }
          },
          // onRemoteAudioStateChanged:
          //     (connection, remoteUid, state, reason, elapsed) {
          //       try {
          //        print('🔊 Audio state: uid=$remoteUid, state=$state');

          //         if (state == RemoteAudioState.remoteAudioStateStopped ||
          //             state == RemoteAudioState.remoteAudioStateFailed) {
          //           _self.isHostAudioOn.value = false;
          //         } else if (state ==
          //             RemoteAudioState.remoteAudioStateDecoding) {
          //           _self.isHostAudioOn.value = true;

          //           // ✅ Re-apply speaker AFTER audio track is active
          //           // This defeats Android's audio re-routing after track starts
          //           _self.agoraEngine?.setEnableSpeakerphone(true).then((_) {
          //            print('🔊 Speaker re-applied after decode started');
          //           });
          //         }
          //       } catch (e) {
          //        print('❌ onRemoteAudioStateChanged error: $e');
          //       }
          //     },
          onRemoteAudioStateChanged:
              (connection, uid, state, reason, elapsed) async {
                print('🔊 Audio state: uid=$uid, state=$state, reason=$reason');

                // Audio stopped or failed — force a re-subscribe cycle
                if (state == RemoteAudioState.remoteAudioStateStopped ||
                    state == RemoteAudioState.remoteAudioStateFailed) {
                  await Future.delayed(const Duration(milliseconds: 800));

                  try {
                    await _self.agoraEngine?.muteRemoteAudioStream(
                      uid: uid,
                      mute: true,
                    );
                    await Future.delayed(const Duration(milliseconds: 500));
                    await _self.agoraEngine?.muteRemoteAudioStream(
                      uid: uid,
                      mute: false,
                    );
                    print('🔄 Re-subscribed audio for uid=$uid');
                  } catch (e) {
                    print('❌ Re-subscribe error: $e');
                  }
                }
              },
          onClientRoleChanged: (connection, oldRole, newRole, newRoleOptions) {
            print('🔄 Role: $oldRole → $newRole');
          },

          onRemoteAudioStats: (connection, stats) {
            print(
              '📊 [AUDIO STATS] uid=${stats.uid} | bitrate=${stats.receivedBitrate} | quality=${stats.quality}',
            );
          },

          onAudioSubscribeStateChanged:
              (channel, uid, oldState, newState, elapsed) {
                print('🔊 [AUDIO SUB] uid=$uid | $oldState → $newState');
              },
        ),
      );

      print('🔵 Joining channel...');

      // 🔴 FIX: Add another delay BEFORE joining channel
      await Future.delayed(const Duration(milliseconds: 300));

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
      print('🔵 Engine ready');

      // 🔴 NEW: Add watchdog that forces checks
      _watchdogTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!_self.isEngineReady.value) return;

        print(
          '🔍 [WATCHDOG] hostUid: ${hostUid.value}, remoteUids: ${_self.remoteUids.length}',
        );

        // If still no host after 10 seconds, something is wrong
        if (hostUid.value == null && _self.remoteUids.isEmpty) {
          print('⚠️ [WATCHDOG] No users detected after long delay');
          // Optionally restart
        }
      });
    } else {
      // optional extra handling
    }
  }

  // Connection lost / unexpected disconnect
  // ✅ Handle unexpected disconnects (network loss etc.)
  void handleUnexpectedDisconnect() {
    _self.remoteUids.clear();
    _self.isHostAudioOn.value = false;
    _self.isHostVideoOn.value = VideoStatus.loading;
    _videoOffDebounceTimer?.cancel();
    _videoOffDebounceTimer?.cancel();
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
    _self.isHostVideoOn.value = VideoStatus.off;
    _videoOffDebounceTimer?.cancel();
    _videoOffDebounceTimer?.cancel();
    _self.isSpeaking.value = false;
    _self.isEngineReady.value = false;

    await WakelockPlus.disable();
    print('🌙 Wakelock disabled (engine-only release)');

    if (_self.agoraEngine != null) {
      try {
        await _self.agoraEngine!.leaveChannel();
        print('✅ Left channel (engine-only release)');
      } catch (e) {
        print('❌ leaveChannel error: $e');
      }
      try {
        await _self.agoraEngine!.release(sync: true);
        print('✅ Engine released (engine-only release)');
      } catch (e) {
        print('❌ release error: $e');
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

    print('🔴 [RTM] Host confirmed end — skipping grace timer');
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

    // 🔴 FIX: Add a longer delay in Release builds
    await Future.delayed(const Duration(milliseconds: 500));

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

    _watchdogTimer?.cancel();
  }
}
