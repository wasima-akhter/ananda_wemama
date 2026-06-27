// notification_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/local/app_storage.dart';
import '../../../../routes/route_paths.dart';
import '../notification_payload.dart';
import '../push_notification_service.dart';

class PushNotificationController extends GetxController {
  static PushNotificationController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    debugPrint('🔧 [NotificationController] onInit — registering tap listener');
    _listenToTaps();
    _consumeColdStartPayload();
  }

  // ── Stream listener ───────────────────────────────────────────────────────

  // push_notification_controller.dart

  void _listenToTaps() {
    PushNotificationService.notificationTapStream.stream.listen(
      (jsonString) {
        debugPrint(
          '🔔 [NotificationController] tap event received: $jsonString',
        );
        final payload = NotificationPayload.fromJsonString(jsonString);

        // ✅ One frame delay — ensures deep link service has already
        // processed (and ignored) the SELECT_NOTIFICATION intent
        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint('🔔 [NotificationController] routing after frame settle');
          _route(payload);
        });
      },
      onError: (e) {
        debugPrint('❌ [NotificationController] stream error: $e');
      },
    );
    debugPrint('✅ [NotificationController] tap listener active');
  }
  // ── Cold start (app was terminated, user tapped notification) ─────────────
  // lastPayload is written before this controller exists, so consume it once.

  void _consumeColdStartPayload() {
    final raw = PushNotificationService.lastPayload;
    if (raw == null || raw.isEmpty) {
      debugPrint('ℹ️ [NotificationController] no cold-start payload');
      return;
    }

    debugPrint('📩 [NotificationController] cold-start payload: $raw');
    PushNotificationService.lastPayload = null; // consume — don't route twice

    final payload = NotificationPayload.fromJsonString(raw);

    // Delay one frame — routes/bindings may not be ready at onInit time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
        '📩 [NotificationController] routing cold-start payload after frame',
      );
      _route(payload);
    });
  }

  // ── Central router ────────────────────────────────────────────────────────

  void _route(NotificationPayload payload) {
    debugPrint(
      '🧭 [NotificationController] routing → '
      'type: ${payload.type} | '
      'referenceId: ${payload.referenceId} | '
      'metadata: ${payload.metadata}',
    );

    // Guard: some routes require login
    final loggedIn = AppStorage.to.getLoggedIn;
    if (!loggedIn) {
      debugPrint(
        '⚠️ [NotificationController] user not logged in — '
        'storing payload and redirecting to signin',
      );
      // Store so SplashController or signin success can re-trigger
      PushNotificationService.lastPayload = payload.toJsonString();
      Get.offAllNamed(RoutePaths.signin);
      return;
    }

    switch (payload.type) {
      case 'OTHER':
        _handleOther(payload);
        break;

      // ── Add as backend ENUM_NOTIFICATION_TYPE grows ──────────────────────
      // case 'ORDER':
      //   Get.toNamed(RoutePaths.orderDetail, arguments: payload.referenceId);
      //   break;
      // case 'MESSAGE':
      //   Get.toNamed(RoutePaths.chat, arguments: payload.referenceId);
      //   break;

      default:
        debugPrint(
          '⚠️ [NotificationController] unhandled type: ${payload.type}',
        );
    }
  }

  void _handleOther(NotificationPayload payload) {
    final userId = payload.metadata['userId']?.toString();
    debugPrint('🧭 [NotificationController] OTHER → userId: $userId');
    debugPrint(
      '🧭 [NotificationController] current route: ${Get.currentRoute}',
    );
    debugPrint('🧭 [NotificationController] routing to: ${RoutePaths.profile}');

    if (userId != null && userId.isNotEmpty) {
      Get.toNamed(RoutePaths.profile, arguments: {'userId': userId});
      debugPrint('🧭 [NotificationController] Get.toNamed called');
    } else {
      debugPrint('⚠️ [NotificationController] OTHER — no userId in metadata');
    }
  }

  // Add this temporary test method to NotificationController
  // Call it from a debug button anywhere in your UI

  void sendTestNotification(String scenario) {
    debugPrint(
      '🧪 [NotificationController] sending test — scenario: $scenario',
    );

    final testPayload = NotificationPayload(
      toId: 'test-user-id',
      toModel: 'User',
      title: '[$scenario] Profile Updated',
      description: 'You have updated your profile.',
      type: 'OTHER',
      referenceId: 'test-ref-id',
      referenceModel: 'User',
      metadata: {'name': 'Test User', 'userId': 'test-user-id-123'},
    );

    // Simulate what FCM would trigger
    PushNotificationService.to.showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: testPayload.title,
      body: testPayload.description,
      payload: testPayload,
    );

    debugPrint('🧪 [NotificationController] test notification shown');
  }

  /*
  FOREGROUND test:
  1. Keep app open on any screen
  2. Tap the debug button
  3. ✅ You should see the notification banner drop down
  4. Tap it
  5. ✅ You should be routed to profile screen

BACKGROUND test:
  1. Tap the debug button
  2. Immediately press Home (minimize the app)
  3. Tap the notification from the system tray
  4. ✅ App should open and route to profile screen

TERMINATED test:
  1. Use your actual backend to send the FCM push
     (local test button won't work for terminated — app isn't running)
  2. Force-close the app
  3. Tap the notification
  4. ✅ App cold-launches and routes to profile screen after login check

  */
}

/*Backgrounf test

For background and terminated you can't use a local button since the app needs to actually be in the background/killed. Use **FCM HTTP v1 API directly** — fastest way to test without touching your backend.

---

**Step 1 — Get your FCM token from logs:**
```
// It prints on every login:
🔑 [PushNotificationService] FCM token: xxxxxxxx
```

**Step 2 — Get a Google access token:**
```bash
# Install gcloud CLI first if you don't have it
# https://cloud.google.com/sdk/docs/install

gcloud auth application-default login
gcloud auth application-default print-access-token
```

**Step 3 — Send test notifications via curl:**

```bash
# ── BACKGROUND TEST ──────────────────────────────────────────────────────────
# 1. Run the app, put it in BACKGROUND (press Home)
# 2. Run this curl
# 3. Tap the notification from system tray
# 4. ✅ App should foreground and route to profile

curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send \
  -H "Authorization: Bearer YOUR_GOOGLE_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "YOUR_FCM_DEVICE_TOKEN",
      "data": {
        "toId": "test-user-123",
        "toModel": "User",
        "title": "[BACKGROUND] Profile Updated",
        "description": "You have updated your profile.",
        "type": "OTHER",
        "referenceId": "test-user-123",
        "referenceModel": "User",
        "metadata": "{\"name\":\"Test User\",\"userId\":\"test-user-123\"}"
      },
      "android": {
        "priority": "high"
      }
    }
  }'
```

```bash
# ── TERMINATED TEST ───────────────────────────────────────────────────────────
# 1. FORCE CLOSE the app completely
# 2. Run this curl
# 3. Tap the notification from system tray
# 4. ✅ App cold-launches → login check → routes to profile

curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send \
  -H "Authorization: Bearer YOUR_GOOGLE_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "YOUR_FCM_DEVICE_TOKEN",
      "data": {
        "toId": "test-user-123",
        "toModel": "User",
        "title": "[TERMINATED] Profile Updated",
        "description": "You have updated your profile.",
        "type": "OTHER",
        "referenceId": "test-user-123",
        "referenceModel": "User",
        "metadata": "{\"name\":\"Test User\",\"userId\":\"test-user-123\"}"
      },
      "android": {
        "priority": "high"
      },
      "apns": {
        "headers": {
          "apns-priority": "10"
        }
      }
    }
  }'
```

Replace these 3 values:

| Placeholder | Where to find it |
|---|---|
| `YOUR_PROJECT_ID` | Firebase Console → Project Settings → General → Project ID |
| `YOUR_GOOGLE_ACCESS_TOKEN` | Output of `gcloud auth application-default print-access-token` |
| `YOUR_FCM_DEVICE_TOKEN` | Your app logs: `🔑 [PushNotificationService] FCM token: ...` |

---

**Expected logs for each scenario:**

```
BACKGROUND TAP:
  📲 [PushNotificationService] background tap — id: ...
  📲 [PushNotificationService] raw data: {type: OTHER, ...}
  📲 [PushNotificationService] parsed tap payload: ...
  🔔 [NotificationController] tap event received: ...
  🧭 [NotificationController] routing → type: OTHER
  🧭 [NotificationController] OTHER → userId: test-user-123

TERMINATED TAP:
  🚀 [main] Flutter binding initialized
  ... (full cold start logs) ...
  📩 [NotificationController] cold-start payload: ...
  📩 [NotificationController] routing cold-start payload after frame
  🧭 [NotificationController] routing → type: OTHER
  🧭 [NotificationController] OTHER → userId: test-user-123
```

*/
