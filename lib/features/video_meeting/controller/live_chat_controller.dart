import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';

import '../../../app/controller_export.dart';
import '../../../core/utils/extension/string_extension.dart';
import '../model/chat_message_live_model.dart';
import 'meeting_controller.dart';

class LiveChatController extends GetxController {
  RtmClient? rtmClient;
  // ✅ No RtmChannel, no AgoraRtmClient — just RtmClient

  final messages = <ChatMessageLiveModel>[].obs;
  RxBool isRtmReady = false.obs;
  RxBool isRtmLoading = false.obs;

  late MeetingController mc;

  @override
  void onInit() {
    mc = Get.find<MeetingController>();

    // Wait until MeetingController finishes fetching tokens + joining RTC
    ever(mc.isEngineReady, (ready) {
      if (ready && !isRtmReady.value) {
        debugPrint('🔵 [CHAT] Engine ready → starting RTM');
        initRtm();
      }
    });
    super.onInit();
  }

  // ---- Listeners (kept as named references so removeListener works) ---- //

  void _onMessage(MessageEvent event) {
    try {
      debugPrint('💬 [RTM] Raw message from ${event.publisher}: "${event.message}"');

      String rawText = (event.message ?? '').toString();

      // ✅ Web sends JSON bytes — decode it
      String displayText = rawText;

      /// 🆕 extracted fields
      String senderName = '';
      String senderAvatar = '';

      try {
        // Check if it looks like a byte array string "[123, 34, ...]"
        if (rawText.trimLeft().startsWith('[')) {
          final List<dynamic> byteList = jsonDecode(rawText);
          final bytes = byteList.cast<int>();
          final decoded = utf8.decode(bytes);
          final Map<String, dynamic> payload = jsonDecode(decoded);

          // ✅ Same type routing as plain string path
          final type = payload['type'];
          switch (type) {
            case 'LIKE':
              reactionCount.value++;
              _triggerHeartAnimation(payload["emoji"] ?? '');
              return;
            case 'RAISE_HAND':
              final uid = payload['sender'];
              if (!raisedHands.any((h) => h.uid == uid)) {
                raisedHands.add(
                  RaiseHandModel(
                    uid: uid,
                    name: payload['senderName'] ?? uid,
                    avatar: payload['senderAvatar'] ?? '',
                  ),
                );
              }
              return;
            case 'HAND_LOWER':
              raisedHands.removeWhere((h) => h.uid == payload['sender']);
              return;
            default:
              displayText = payload['message'] ?? decoded;
              senderName = payload['senderName'] ?? '';
              senderAvatar = payload['senderAvatar'] ?? payload['avatar'] ?? '';
          }
        }
      } catch (e) {
        debugPrint('⚠️ [RTM] Could not decode message — using raw: $e');
        displayText = rawText;
      }

      final isMe = event.publisher == mc.uid.value.toString();

      /// 🆕 fallback handling (VERY IMPORTANT)
      if (senderName.isEmpty) {
        senderName = isMe ? (mc.sessionInfo.value.userName ?? 'You') : 'User';
      }

      if (senderAvatar.isEmpty) {
        senderAvatar = isMe ? (mc.sessionInfo.value.userAvatar ?? '') : '';
      }

      /// 🆕 final message push
      messages.add(
        ChatMessageLiveModel(
          text: displayText,
          senderId: event.publisher ?? '',
          isMe: isMe,
          timestamp: DateTime.now(),
          senderAvatar: senderAvatar,
          senderName: senderName,
        ),
      );

      debugPrint('✅ [RTM] Total messages: ${messages.length}');
      _scrollToBottom();
    } catch (e) {
      debugPrint('❌ [RTM] _onMessage error: $e');
    }
  }

  //

  void _onLinkState(LinkStateEvent event) {
    debugPrint('🔵 [RTM] LinkState: ${event.currentState}, reason: ${event.reason}');

    if (event.currentState == RtmLinkState.connected) {
      isRtmReady.value = true;
    } else if (event.currentState == RtmLinkState.disconnected ||
        event.currentState == RtmLinkState.failed) {
      isRtmReady.value = false;
    }
  }

  RxInt viewCount = 0.obs;
  RxList<ParticipantModel> participants = <ParticipantModel>[].obs;

  void _onPresence(PresenceEvent event) {
    debugPrint('👤 [RTM] Presence: ${event.type} — ${event.publisher}');

    switch (event.type) {
      case RtmPresenceEventType.snapshot:
        // Initial state when you first join — full member list
        final members = event.snapshot?.userStateList ?? [];

        participants.assignAll(
          members.map((m) {
            final stateMap = {for (var s in (m.states ?? [])) s.key: s.value};

            return ParticipantModel(
              uid: m.userId,
              name: stateMap['name'] ?? m.userId,
              avatar: stateMap['avatar'] ?? '',
              isMuted: stateMap['isMuted'] == 'true',
            );
          }),
        );

        viewCount.value = participants.length;
        return;

      case RtmPresenceEventType.remoteJoinChannel:
        // Someone joined
        final uid = event.publisher ?? '';

        if (!participants.any((j) => j.uid == uid)) {
          final stateMap = {for (var s in (event.stateItems ?? [])) s.key: s.value};

          participants.add(
            ParticipantModel(
              uid: uid,
              name: stateMap['name'] ?? uid,
              avatar: stateMap['avatar'] ?? '',
              isMuted: stateMap['isMuted'] == 'true',
            ),
          );
        }

        viewCount.value = participants.length;
        debugPrint('✅ [RTM] Joiner added: $uid, total: ${viewCount.value}');
        return;

      case RtmPresenceEventType.remoteLeaveChannel:
      case RtmPresenceEventType.remoteTimeout:
        // Someone left
        participants.removeWhere((j) => j.uid == event.publisher);
        viewCount.value = participants.length;
        debugPrint('✅ [RTM] Joiner removed: ${event.publisher}');
        return;

      case RtmPresenceEventType.remoteStateChanged:
        // Someone updated their state (e.g. muted/unmuted)
        final uid = event.publisher ?? '';

        final stateMap = {for (StateItem s in (event.stateItems ?? [])) s.key: s.value};

        final index = participants.indexWhere((p) => p.uid == uid);

        if (index != -1 && stateMap.containsKey('isMuted')) {
          participants[index] = participants[index].copyWith(
            isMuted: stateMap['isMuted'] == 'true',
          );

          debugPrint('✅ [RTM] State changed for $uid: $stateMap');
        }

        return;

      default:
        // Optional: handle unknown events
        debugPrint('⚠️ [RTM] Unhandled presence event: ${event.type}');
        return;
    }
  }

  void _onToken(TokenEvent event) {
    debugPrint('⚠️ [RTM] Token event: ${event.channelName}');
    // TODO: refresh rtmToken from backend here
  }

  Future<void> initRtm() async {
    if (isRtmLoading.value) {
      debugPrint('⚠️ [RTM] Already loading — skipping');
      return;
    }

    if (mc.appId.value.isEmpty) {
      debugPrint('❌ [RTM] appId is empty');
      return;
    }

    if (mc.rtmToken.value.isEmpty) {
      debugPrint('❌ [RTM] rtmToken is empty');
      return;
    }

    if (mc.channelName.value.isEmpty) {
      debugPrint('❌ [RTM] channelName is empty');
      return;
    }

    isRtmLoading.value = true;

    try {
      // Step 1: Create client — real factory is RTM()
      // uid must be a STRING, not int
      debugPrint('🔵 [RTM-1] Calling RTM() factory...');
      debugPrint('   appId: ${mc.appId.value}');
      debugPrint('   userId: ${mc.uid.value.toString()}');

      final (createStatus, client) = await RTM(
        mc.appId.value,
        mc.uid.value.toString(), // ← userId is a String in RTM v2
      );

      if (createStatus.error) {
        debugPrint(
          '❌ [RTM-1] RTM() failed — code: ${createStatus.errorCode}, reason: ${createStatus.reason}',
        );
        return;
      }

      rtmClient = client;
      debugPrint('✅ [RTM-1] RtmClient created');

      // Step 2: Attach listeners BEFORE login
      rtmClient!.addListener(
        linkState: _onLinkState,
        message: _onMessage,
        presence: _onPresence,
        token: _onToken,
      );
      debugPrint('✅ [RTM-2] Listeners attached');

      // Step 3: Login with token
      debugPrint('🔵 [RTM-3] Logging in...');
      final (loginStatus, loginResult) = await rtmClient!.login(mc.rtmToken.value);

      if (loginStatus.error) {
        debugPrint(
          '❌ [RTM-3] Login failed — code: ${loginStatus.errorCode}, reason: ${loginStatus.reason}',
        );
        return;
      }

      debugPrint('✅ [RTM-3] Login success: $loginResult');

      // Step 4: Subscribe
      debugPrint('🔵 [RTM-4] Subscribing to: ${mc.channelName.value}');
      final (subStatus, subResult) = await rtmClient!.subscribe(
        mc.channelName.value,
        withMessage: true,
        withPresence: true,
      );

      if (subStatus.error) {
        debugPrint(
          '❌ [RTM-4] Subscribe failed — code: ${subStatus.errorCode}, reason: ${subStatus.reason}',
        );
        return;
      }

      // After subscribe succeeds — set your presence state
      await rtmClient!.getPresence().setState(mc.channelName.value, RtmChannelType.message, {
        'name': mc.sessionInfo.value.userName ?? '',
        'avatar': mc.sessionInfo.value.userAvatar ?? '',
        'isMuted': 'false',
      });

      debugPrint('✅ [RTM] Presence state set');
      debugPrint('✅ [RTM-4] Subscribed: $subResult');
      isRtmReady.value = true;
      debugPrint('✅ [RTM] FULLY READY');
    } catch (e, stack) {
      debugPrint('❌ [RTM] initRtm FAILED: $e');
      debugPrint('   $stack');
      isRtmReady.value = false;
    } finally {
      isRtmLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();

    if (trimmed.isEmpty) {
      debugPrint('⚠️ [RTM] Empty message — skipping');
      return;
    }

    if (!isRtmReady.value || rtmClient == null) {
      debugPrint('❌ [RTM] Not ready — cannot send');
      "Chat not connected yet".showToast();
      return;
    }

    try {
      debugPrint('📤 [RTM] Publishing: "$trimmed"');

      // final payload = jsonEncode({
      //   "type": "CHAT",
      //   "message": trimmed,
      //   "sender": mc.uid.value.toString(),
      // });

      final payload = jsonEncode({
        "type": "CHAT",
        "message": trimmed,
        "sender": mc.uid.value.toString(),
        "senderName": mc.sessionInfo.value.userName ?? '', // ← add this
        "senderAvatar": mc.sessionInfo.value.userAvatar ?? '', // ← add this
      });

      final (status, result) = await rtmClient!.publish(
        mc.channelName.value,
        payload, // ← send JSON string, not raw text
        channelType: RtmChannelType.message,
      );

      if (status.error) {
        debugPrint('❌ [RTM] Publish failed — code: ${status.errorCode}, reason: ${status.reason}');
        "Failed to send".showToast();
        return;
      }

      debugPrint('✅ [RTM] Published: ${result.toString()}');

      // v2 does NOT echo back to sender — add locally
      messages.add(
        ChatMessageLiveModel(
          text: trimmed,
          senderId: mc.uid.value.toString(),
          isMe: true,
          timestamp: DateTime.now(),
          senderAvatar: mc.sessionInfo.value.userAvatar ?? '',
          senderName: mc.sessionInfo.value.userName ?? '',
        ),
      );

      mc.inputMsgCtrl.clear();
      _scrollToBottom();
    } catch (e) {
      debugPrint('❌ [RTM] sendMessage error: $e');
      "Failed to send".showToast();
    }
  }

  //////
  Future<void> sendReaction(String emoji) async {
    // ← takes emoji
    if (!isRtmReady.value || rtmClient == null) return;

    final payload = jsonEncode({
      "type": "LIKE",
      "emoji": emoji, // ← send which emoji
      "sender": mc.uid.value.toString(),
      "senderName": mc.sessionInfo.value.userName ?? '',
    });

    final (status, _) = await rtmClient!.publish(
      mc.channelName.value,
      payload,
      channelType: RtmChannelType.message,
    );

    if (status.error) {
      debugPrint('❌ [RTM] Reaction failed: ${status.errorCode}');
      return;
    }

    reactionCount.value++;
    _triggerHeartAnimation(emoji); // ← pass emoji for display
  }

  void _triggerHeartAnimation(String emoji) {
    final id = DateTime.now().millisecondsSinceEpoch;
    hearts.add(id);
    Future.delayed(const Duration(seconds: 2), () => hearts.remove(id));
  }

  RxInt reactionCount = 0.obs;
  final hearts = <int>[].obs; // each int is a unique animation id

  ///-----------------------
  RxList<RaiseHandModel> raisedHands = <RaiseHandModel>[].obs;

  Future<void> toggleRaiseHand() async {
    if (!isRtmReady.value || rtmClient == null) return;

    final isRaised = raisedHands.any((h) => h.uid == mc.uid.value.toString());

    final payload = jsonEncode({
      "type": isRaised ? "HAND_LOWER" : "RAISE_HAND",
      "sender": mc.uid.value.toString(),
      "senderName": mc.sessionInfo.value.userName ?? '',
      "senderAvatar": mc.sessionInfo.value.userAvatar ?? '', // ← add
    });

    await rtmClient!.publish(mc.channelName.value, payload, channelType: RtmChannelType.message);

    if (isRaised) {
      raisedHands.removeWhere((h) => h.uid == mc.uid.value.toString());
    } else {
      raisedHands.add(
        RaiseHandModel(
          uid: mc.uid.value.toString(),
          name: mc.sessionInfo.value.userName ?? '',
          avatar: mc.sessionInfo.value.userAvatar ?? '', // ← add
        ),
      );
    }
  }

  // Computed bool for UI button state
  bool get isHandRaised => raisedHands.any((h) => h.uid == mc.uid.value.toString());
  ////////////
  // ---- Scroll ---- //
  final chatScrollCtrl = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatScrollCtrl.hasClients) {
        chatScrollCtrl.animateTo(
          chatScrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> disposeRtm() async {
    debugPrint('🔵 [RTM] Disposing...');

    // Remove named listeners cleanly
    try {
      rtmClient?.removeListener(
        linkState: _onLinkState,
        message: _onMessage,
        presence: _onPresence,
        token: _onToken,
      );
      debugPrint('✅ [RTM] Listeners removed');
    } catch (e) {
      debugPrint('⚠️ [RTM] removeListener error: $e');
    }

    try {
      await rtmClient?.unsubscribe(mc.channelName.value);
      debugPrint('✅ [RTM] Unsubscribed');
    } catch (e) {
      debugPrint('⚠️ [RTM] unsubscribe error: $e');
    }

    try {
      if (rtmClient != null) {
        final (status, _) = await rtmClient!.logout();
        debugPrint(
          status.error ? '⚠️ [RTM] logout error: ${status.errorCode}' : '✅ [RTM] Logged out',
        );
      }
    } catch (e) {
      debugPrint('⚠️ [RTM] logout error: $e');
    }

    try {
      await rtmClient?.release();
      debugPrint('✅ [RTM] Released');
    } catch (e) {
      debugPrint('⚠️ [RTM] release error: $e');
    }

    rtmClient = null;
    isRtmReady.value = false;
    debugPrint('✅ [RTM] Disposed cleanly');
  }

  @override
  void onClose() async {
    await disposeRtm(); // unsubscribe + logout + release
    chatScrollCtrl.dispose();
    super.onClose();
  }
}

/*

hostMeeting()
  → getSessionsInfo()       // gets rtmToken, rtcToken, uid
  → initAgora()             // joins RTC (video/audio)
  → initRtm()               // joins RTM (chat)

User types → sendMessage()
  → rtmChannel.sendMessage()   // sends to all members
  → messages.add() locally     // echoes for sender
  → Obx rebuilds list          // instant UI update

Remote sends → onMessageReceived fires
  → messages.add()             // RxList triggers Obx
  → UI updates automatically
  → scroll animates to bottom

  */
