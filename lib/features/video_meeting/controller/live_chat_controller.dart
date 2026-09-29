import 'package:agora_rtm/agora_rtm.dart';

import '../../../app/controller_export.dart';
import 'live_chat/mixins/rtm_connection_mixin.dart';
import 'live_chat/mixins/rtm_host_controls_mixin.dart';
import 'live_chat/mixins/rtm_message_mixin.dart';
import 'live_chat/mixins/rtm_presence_mixin.dart';
import 'live_chat/mixins/rtm_raise_hand_mixin.dart';
import 'live_chat/mixins/rtm_reaction_mixin.dart';
import 'meeting_controller.dart';

class LiveChatController extends GetxController
    with
        RtmConnectionMixin,
        RtmMessageMixin,
        RtmPresenceMixin,
        RtmReactionMixin,
        RtmRaiseHandMixin,
        RtmHostControlsMixin {
  static LiveChatController get to => Get.find();
  RtmClient? rtmClient;

  late MeetingController mc;

  // ---- Scroll ---- //
  final chatScrollCtrl = ScrollController();

  void scrollToBottom() {
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

  @override
  void onInit() {
    mc = MeetingController.to;

    // Wait until MeetingController finishes fetching tokens + joining RTC
    ever(mc.isEngineReady, (ready) {
      if (ready && !isRtmReady.value) {
        print('🔵 [CHAT] Engine ready → starting RTM');
        initRtm();
      }
    });
    super.onInit();
  }

  @override
  void onClose() async {
    await disposeRtm(); // unsubscribe + logout + release
    chatScrollCtrl.dispose();
    super.onClose();
  }
}

// record history

/*

Now that RTM is working, to enable message history you need changes in both the Flutter code and Agora Console.

---

## 1. Agora Console — Enable Message History

In the same Signaling settings where you enabled the data center:

- Find **"Message History"** or **"Storage"** toggle → **Enable it**
- Set retention period (e.g. 7 days or 30 days)

---

## 2. Flutter Code — Add `storeInHistory: true`

You have it commented out in 3 places. Just uncomment them:

### `rtm_message_mixin.dart` — `sendMessage()`
```dart
final (status, result) = await _self.rtmClient!.publish(
  _self.mc.channelName.value,
  payload,
  channelType: RtmChannelType.message,
  storeInHistory: true, // ← uncomment this
);
```

### `rtm_reaction_mixin.dart` — `sendReaction()`
```dart
final (status, _) = await _self.rtmClient!.publish(
  _self.mc.channelName.value,
  payload,
  channelType: RtmChannelType.message,
  storeInHistory: true, // ← uncomment this
);
```

### `rtm_raise_hand_mixin.dart` — `toggleRaiseHand()`
```dart
await _self.rtmClient!.publish(
  _self.mc.channelName.value,
  payload,
  channelType: RtmChannelType.message,
  storeInHistory: true, // ← uncomment this
);
```

---

## 3. Enable Storage + Presence History in `initRtm()`

In `rtm_connection_mixin.dart`, update the `subscribe()` call to also enable presence and metadata storage:

```dart
final (subStatus, subResult) = await _self.rtmClient!.subscribe(
  _self.mc.channelName.value,
  withMessage: true,
  withPresence: true,
  withMetadata: true,   // ← add: stores channel/user metadata
  withLock: false,      // ← add: not needed unless you use distributed locks
);
```

---

## 4. Load History on Join (optional but recommended)

After subscribe succeeds in `rtm_connection_mixin.dart`, fetch previous messages so users joining mid-session see chat history:

```dart
// After subscribe succeeds — fetch message history
try {
  final (historyStatus, historyResult) = await _self.rtmClient!
      .getStorage()
      .getChannelMetadata(
        channelName: _self.mc.channelName.value,
        channelType: RtmChannelType.message,
      );

  // Or use history API if your Agora SDK version supports it:
  // rtmClient!.getHistory(...)
  print('✅ [RTM] History/metadata fetched');
} catch (e) {
  print('⚠️ [RTM] History fetch skipped: $e');
}
```

> Note: The actual message history API (`getMessages`) is a REST API call on Agora's side — your **backend** can expose an endpoint that calls `https://api.agora.io/dev/v2/project/{appid}/rtm/channel/{channel}/message/history` and returns it to Flutter on join. That's the cleanest way to load chat history for late joiners.

---

## Summary of what enables what

| Feature | Where to fix |
|---|---|
| Chat messages saved | `storeInHistory: true` in `sendMessage()` |
| Reactions saved | `storeInHistory: true` in `sendReaction()` |
| Raise hand saved | `storeInHistory: true` in `toggleRaiseHand()` |
| Participant state persisted | `withMetadata: true` in `subscribe()` |
| History visible to late joiners | Backend REST call to Agora history API |
| Retention period | Agora Console → Signaling → Storage settings |

*/

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
