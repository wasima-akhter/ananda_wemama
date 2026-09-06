// push_notification_service.dart

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:we_mama/core/network/helpers/network_helpers.dart';

import '../../local/app_storage.dart';
import '../firebase/firebase_service.dart';
import 'controller/notification_count_controller.dart';
import 'controller/push_notification_controller.dart';
import 'firebase_token_service.dart';
import 'notification_payload.dart';

class PushNotificationService extends GetxService {
  // ── Singleton via GetX ───────────────────────────────────────────────────────
  static PushNotificationService get to => Get.find();

  // ── Private deps ─────────────────────────────────────────────────────────────
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _channelInitialized = false;

  // ── Public stream ─────────────────────────────────────────────────────────────
  static final StreamController<String> notificationTapStream =
      StreamController<String>.broadcast();

  static String? lastPayload;

  // ── Retry state ───────────────────────────────────────────────────────────────
  bool _tokenUploaded = false;
  int _tokenUploadAttempts = 0;
  static const int _maxTokenUploadAttempts = 5;

  // ── Lifecycle ─────────────────────────────────────────────────────────────────

  /// Full init — call once from main() AFTER Firebase + FirebaseTokenService
  /// are both registered in GetX.
  Future<PushNotificationService> init() async {
    debugPrint('🔧 [PushNotificationService] init started');

    await _initLocalPlugin();
    //
    await refreshNotificationPermissionStatus();
    await _requestPermissions();
    await _createAndroidChannel();
    _registerFcmListeners(); // registers onMessage + onMessageOpenedApp only
    await _subscribeToTopic();
    await _handleTerminatedLaunch();
    // await _uploadFcmToken(); // safe here — FirebaseTokenService is already in GetX

    debugPrint('✅ [PushNotificationService] init complete');
    return this;
  }

  @override
  void onClose() {
    notificationTapStream.close();
    super.onClose();
  }

  // ── Setup steps ───────────────────────────────────────────────────────────────

  Future<void> _requestPermissions() async {
    debugPrint('🔧 [PushNotificationService] requesting permissions...');
    if (Platform.isAndroid) {
      final granted = await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      debugPrint(
        '✅ [PushNotificationService] Android permission granted: $granted',
      );
    } else if (Platform.isIOS) {
      final granted = await _localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      debugPrint(
        '✅ [PushNotificationService] iOS permission granted: $granted',
      );
    }
  }

  Future<bool> requestPermissionIfNeeded() async {
    debugPrint(
      '🔧 [PushNotificationService] checking current permission status...',
    );

    // Check current status first — never ask if already granted/denied
    final settings = await _fcm.getNotificationSettings();
    debugPrint(
      'ℹ️ [PushNotificationService] current status: ${settings.authorizationStatus}',
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint(
        '✅ [PushNotificationService] already authorized — skipping prompt',
      );
      return true;
    }

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint(
        '⚠️ [PushNotificationService] previously denied — cannot prompt again',
      );
      return false;
    }

    // Status is .notDetermined — safe to ask
    debugPrint('🔧 [PushNotificationService] requesting system permission...');

    bool granted = false;

    if (Platform.isAndroid) {
      granted =
          await _localNotifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;

      debugPrint(
        '✅ [PushNotificationService] Android permission granted: $granted',
      );
    } else if (Platform.isIOS) {
      granted =
          await _localNotifications
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;

      debugPrint(
        '✅ [PushNotificationService] iOS permission granted: $granted',
      );
    }

    await refreshNotificationPermissionStatus();

    debugPrint(
      granted
          ? '✅ [PushNotificationService] permission GRANTED'
          : '⚠️ [PushNotificationService] permission DENIED by user',
    );
    return granted;
  }

  bool _pluginInitialized = false; // add this field

  Future<void> _initLocalPlugin() async {
    debugPrint('🔧 initializing local plugin...');
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundLocalNotificationTap,
    );
    _pluginInitialized =
        true; // ✅ mark so createAndroidChannelOnly skips re-init
    debugPrint('✅ local plugin initialized WITH callbacks');
  }

  /// Public so the background isolate top-level function can call it on a
  /// fresh, un-registered instance without touching GetX.
  Future<void> createAndroidChannelOnly() async {
    if (_channelInitialized) {
      debugPrint('ℹ️ Android channel already created, skipping');
      return;
    }

    debugPrint('🔧 creating Android channel...');

    // ✅ Only re-run full initialize() if we're in a fresh, unregistered
    // instance (background isolate). Detect via a simple flag instead of
    // always calling initialize() here.
    if (!_pluginInitialized) {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _localNotifications.initialize(settings: settings);
      _pluginInitialized = true;
    }

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'All push notifications',
      importance: Importance.high,
    );

    _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    _channelInitialized = true;
    debugPrint('✅ Android channel created');
  }

  // Private — full init path only (also sets iOS foreground options)
  Future<void> _createAndroidChannel() async {
    await createAndroidChannelOnly();

    debugPrint(
      '🔧 [PushNotificationService] setting iOS foreground options...',
    );
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('✅ [PushNotificationService] iOS foreground options set');
  }

  void _registerFcmListeners() {
    // debugPrint('🔧 [PushNotificationService] registering FCM listeners...');

    // // Foreground messages
    // FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // // Background tap (app was in background, user tapped notification)
    // FirebaseMessaging.onMessageOpenedApp.listen(_onBackgroundTap);

    // // ⚠️  DO NOT call FirebaseMessaging.onBackgroundMessage() here.
    // //     It is registered once in main() via the top-level handler below,
    // //     before runApp(). Calling it twice causes undefined behavior.

    // debugPrint('✅ [PushNotificationService] FCM listeners registered');

    debugPrint('🔧 [PushNotificationService] registering FCM listeners...');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🚨 FCM PUSH RECEIVED — FOREGROUND');
      debugPrint('📨 Message ID: ${message.messageId}');
      debugPrint('📨 From: ${message.from}');
      debugPrint('📨 Data: ${message.data}');
      debugPrint('📨 Notification: ${message.notification}');
      debugPrint('📨 Title: ${message.notification?.title}');
      debugPrint('📨 Body: ${message.notification?.body}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      _onForegroundMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🚨 FCM PUSH TAPPED — BACKGROUND');
      debugPrint('📨 Message ID: ${message.messageId}');
      debugPrint('📨 From: ${message.from}');
      debugPrint('📨 Data: ${message.data}');
      debugPrint('📨 Notification: ${message.notification}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      _onBackgroundTap(message);
    });

    debugPrint('✅ [PushNotificationService] FCM listeners registered');
  }

  Future<void> _subscribeToTopic() async {
    debugPrint('🔧 [PushNotificationService] subscribing to topic "Client"...');
    await _fcm.subscribeToTopic('Client');
    debugPrint('✅ [PushNotificationService] subscribed to topic "Client"');
  }

  /*
  Future<void> _handleTerminatedLaunch() async {
    debugPrint(
      '🔧 [PushNotificationService] checking terminated-launch notification...',
    );
    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      final payload = details!.notificationResponse?.payload;
      if (payload != null) {
        lastPayload = payload;
        notificationTapStream.add(payload); // ✅ was: 'notification_tap'

        debugPrint(
          '📩 [PushNotificationService] launched from terminated state — payload: $payload',
        );
      } else {
        debugPrint(
          'ℹ️ [PushNotificationService] launched from terminated notification but payload was null',
        );
      }
    } else {
      debugPrint(
        'ℹ️ [PushNotificationService] app was NOT launched from a notification',
      );
    }
  }
*/
  Future<void> _handleTerminatedLaunch() async {
    debugPrint(
      '🔧 [PushNotificationService] checking terminated notification...',
    );

    // 1️⃣ Firebase Messaging terminated tap
    final initialMessage = await _fcm.getInitialMessage();

    if (initialMessage != null) {
      debugPrint(
        '📩 [PushNotificationService] Firebase terminated launch detected',
      );

      final payload = NotificationPayload.fromMap(initialMessage.data);

      lastPayload = payload.toJsonString();

      notificationTapStream.add(payload.toJsonString());

      return;
    }

    // 2️⃣ flutter_local_notifications terminated tap
    final details = await _localNotifications.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      final payload = details!.notificationResponse?.payload;

      if (payload != null && payload.isNotEmpty) {
        lastPayload = payload;
        notificationTapStream.add(payload);

        debugPrint(
          '📩 [PushNotificationService] local notification launch payload: $payload',
        );
      }
    }
  }
  //

  /// Phase 2 — call after successful login (or on app resume if already logged in).
  /// Safe to call multiple times — guarded by _tokenUploaded flag.
  Future<void> uploadTokenAfterLogin() async {
    debugPrint('🔧 [PushNotificationService] uploadTokenAfterLogin() called');
    await _uploadFcmToken();
    _listenForTokenRefresh(); // start refresh listener only after we care about the token
  }

  bool _refreshListenerRegistered = false;

  void _listenForTokenRefresh() {
    if (_refreshListenerRegistered) return;
    _refreshListenerRegistered = true;

    debugPrint(
      '🔧 [PushNotificationService] registering token refresh listener...',
    );
    _fcm.onTokenRefresh.listen((newToken) async {
      debugPrint('🔄 [PushNotificationService] FCM token refreshed: $newToken');
      _tokenUploaded = false; // force re-upload with new token
      await _uploadFcmToken(isRetry: true);
    });
    debugPrint('✅ [PushNotificationService] token refresh listener registered');
  }

  // Replace _uploadFcmToken() with this:

  Future<void> _uploadFcmToken({bool isRetry = false}) async {
    if (_tokenUploaded) {
      debugPrint(
        'ℹ️ [PushNotificationService] token already uploaded — skipping',
      );
      // return;
    }

    if (_tokenUploadAttempts >= _maxTokenUploadAttempts) {
      debugPrint(
        '⚠️ [PushNotificationService] max token upload attempts ($_maxTokenUploadAttempts) reached — giving up',
      );
      return;
    }

    _tokenUploadAttempts++;
    debugPrint(
      '🔧 [PushNotificationService] fetching FCM token... (attempt $_tokenUploadAttempts/$_maxTokenUploadAttempts${isRetry ? ' — RETRY' : ''})',
    );

    try {
      final apnsToken = await _fcm.getAPNSToken();

      debugPrint('🍎 APNs token: $apnsToken');
      final token = await _fcm.getToken();

      if (token == null) {
        debugPrint(
          '⚠️ [PushNotificationService] FCM token is null — will retry on next opportunity',
        );
        return; // don't increment retry — token being null is usually transient
      }

      if (storage.getToken.isEmpty) {
        return;
      }

      debugPrint('🔑 [PushNotificationService] FCM token: $token');
      debugPrint('🔧 [PushNotificationService] uploading FCM token...');

      final success = await Get.find<FirebaseTokenService>().updateToken(
        firebaseToken: token,
      );

      if (success == true) {
        _tokenUploaded = true;
        _tokenUploadAttempts = 0; // reset for any future forced refresh
        debugPrint(
          '✅ [PushNotificationService] FCM token uploaded successfully',
        );
      } else {
        debugPrint(
          '⚠️ [PushNotificationService] FCM token upload returned false — will retry on next opportunity',
        );
      }
    } catch (e, st) {
      debugPrint('❌ [PushNotificationService] FCM token upload FAILED: $e');
      debugPrint('$st');
      // Will be retried on foreground resume or network reconnect
    }
  }

  // Add this public method — called from outside on foreground resume / network restore

  /// Retries any failed initialization steps silently.
  /// Safe to call multiple times — each step is guarded by its own flag.
  /// Retries only the auth-dependent steps. Safe to call multiple times.
  Future<void> retryFailedSteps() async {
    debugPrint('🔄 [PushNotificationService] retryFailedSteps() called');

    if (_tokenUploaded) {
      debugPrint(
        'ℹ️ [PushNotificationService] token already uploaded — nothing to retry',
      );
      return;
    }

    await _uploadFcmToken(isRetry: true);
  }
  // ── Message handlers ──────────────────────────────────────────────────────────

  // In push_notification_service.dart — updated call sites and showLocalNotification

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint(
      '🔔 [PushNotificationService] foreground message — id: ${message.messageId}',
    );
    debugPrint('🔔 [PushNotificationService] raw data: ${message.data}');

    if (message.data.isEmpty) {
      debugPrint('ℹ️ [PushNotificationService] no data payload — ignoring');
      if (kDebugMode) {
        PushNotificationController.to.sendTestNotification(
          'FOREGROUND : ${message.toString()}',
        );
      }

      return;
    }

    final payload = NotificationPayload.fromMap(message.data);
    debugPrint('🔔 [PushNotificationService] parsed payload: $payload');

    //
    // ✅ Update counts — GetX available here
    // ✅ Update counts — single source of truth
    NotificationCountController.to.onPushReceived(
      unread: payload.unreadCount,
      newN: payload.newCount,
    );
    // Use description as body (matches backend field name)
    final title = payload.title.isNotEmpty
        ? payload.title
        : (message.notification?.title ?? '');
    final body = payload.description.isNotEmpty
        ? payload.description
        : (message.notification?.body ?? '');

    if (title.isEmpty && body.isEmpty) {
      debugPrint(
        'ℹ️ [PushNotificationService] empty title+body — skipping display',
      );
      return;
    }

    lastPayload = payload.toJsonString();

    //

    showLocalNotification(
      id: _safeId(message.messageId),
      title: title,
      body: body,
      payload: payload,
    );
  }

  void showLocalNotification({
    required int id,
    required String title,
    required String body,
    NotificationPayload? payload, // typed, not raw Object
    String channelId = 'high_importance_channel',
    String channelName = 'High Importance Notifications',
  }) {
    debugPrint(
      '🔔 [PushNotificationService] showing notification — '
      'id: $id | title: "$title" | type: ${payload?.type ?? "unknown"}',
    );

    _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      // Serialize the full typed payload so tap handlers can reconstruct it
      payload: payload?.toJsonString(),
    );
  }

  // Tap handlers — now deserialize back to NotificationPayload

  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint(
      '👆 [PushNotificationService] local notification tapped — raw payload: ${response.payload}',
    );

    if (response.payload == null || response.payload!.isEmpty) {
      debugPrint('⚠️ [PushNotificationService] tap had no payload — ignoring');
      return;
    }

    final payload = NotificationPayload.fromJsonString(response.payload!);
    debugPrint('👆 [PushNotificationService] parsed tap payload: $payload');

    //
    // ✅ update counts from the tapped payload — covers the BGIsolate-shown
    // notification tap case, where GetX is alive now but wasn't when the
    // notification was originally created
    NotificationCountController.to.onPushReceived(
      unread: payload.unreadCount,
      newN: payload.newCount,
    );

    lastPayload = response.payload;
    notificationTapStream.add(payload.toJsonString());
  }

  void _onBackgroundTap(RemoteMessage message) {
    debugPrint(
      '📲 [PushNotificationService] background tap — id: ${message.messageId}',
    );
    debugPrint('📲 [PushNotificationService] raw data: ${message.data}');

    final payload = NotificationPayload.fromMap(message.data);
    debugPrint('📲 [PushNotificationService] parsed tap payload: $payload');

    // ✅ GetX still alive — update via controller (single source of truth)
    NotificationCountController.to.onPushReceived(
      unread: payload.unreadCount,
      newN: payload.newCount,
    );
    lastPayload = payload.toJsonString();
    notificationTapStream.add(payload.toJsonString());
  }
  // ── Public API ────────────────────────────────────────────────────────────────

  // ── Helpers ───────────────────────────────────────────────────────────────────

  int _safeId(String? messageId) {
    if (messageId == null) {
      return DateTime.now().millisecondsSinceEpoch % 100000;
    }
    return messageId.hashCode.abs() % 100000;
  }

  // Access NOTIFICATION ON OFF ----------------->>>
  final Rx<AuthorizationStatus> notificationStatus =
      AuthorizationStatus.notDetermined.obs;

  final RxBool notificationPermissionEnabled = false.obs;

  /// Internal helper - keeps both values in sync.
  void _updateNotificationState(AuthorizationStatus status) {
    notificationStatus.value = status;
    notificationPermissionEnabled.value =
        status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }

  Future<void> refreshNotificationPermissionStatus() async {
    debugPrint(
      'Service hash: ${identityHashCode(this)} '
      'status=${notificationStatus.value}',
    );

    final settings = await _fcm.getNotificationSettings();

    _updateNotificationState(settings.authorizationStatus);

    debugPrint(
      '🔔 [PushNotificationService] notification status: '
      '${notificationStatus.value} | enabled: ${notificationPermissionEnabled.value}',
    );
  }

  bool get isNotificationEnabled => notificationPermissionEnabled.value;

  Future<bool> isNotificationPermissionGranted() async {
    await refreshNotificationPermissionStatus();
    return notificationPermissionEnabled.value;
  }

  Future<bool> enableNotifications() async {
    final granted = await requestPermissionIfNeeded();

    // User may have accepted/denied the OS dialog.
    await refreshNotificationPermissionStatus();

    return granted;
  }

  Future<AuthorizationStatus> getNotificationStatus() async {
    final settings = await _fcm.getNotificationSettings();

    _updateNotificationState(settings.authorizationStatus);

    debugPrint(
      '🔔 [PushNotificationService] getNotificationStatus -> '
      '${notificationStatus.value} | enabled: ${notificationPermissionEnabled.value}',
    );

    return notificationStatus.value;
  }

  Future<void> onNotificationPermissionEnabled() async {
    debugPrint('🔄 [PushNotificationService] notification permission enabled');

    await refreshNotificationPermissionStatus();

    if (!isNotificationEnabled) {
      debugPrint('⚠️ [PushNotificationService] permission still not enabled');
      return;
    }

    // Upload token if user is logged in.
    await uploadTokenAfterLogin();

    debugPrint('✅ [PushNotificationService] notification setup refreshed');
  }
}

// ── Top-level callbacks ────────────────────────────────────────────────────────

/// FCM background isolate handler — registered ONCE in main(), top-level only.
/// GetX is NOT available here. Create a bare service instance manually.

@pragma('vm:entry-point')
Future<void> onFcmBackgroundMessage(RemoteMessage message) async {
  debugPrint(
    '📦 [BGIsolate] FCM background message — id: ${message.messageId}',
  );
  debugPrint('📦 [BGIsolate] raw data: ${message.data}');

  await FirebaseInitializer.init();
  debugPrint('✅ [BGIsolate] Firebase ready');

  final service = PushNotificationService();
  await service.createAndroidChannelOnly();

  // ✅ Parse into typed payload — same as foreground path
  final payload = NotificationPayload.fromMap(message.data);
  debugPrint('📦 [BGIsolate] parsed payload: $payload');

  // ✅ GetX is NOT available in this isolate — use bare GetStorage directly,
  //    writing to the SAME keys AppStorage uses, so they sync on next app open.
  // ✅ GetX isn't initialized in this isolate, so Get.find<AppStorage>()
  //    would throw. Instead, create a standalone AppStorage instance —
  //    it points to the same on-disk GetStorage container, so writes
  //    here are visible to AppStorage.to once the main isolate resumes.
  final appStorage = await AppStorage.init();

  appStorage.setNotificationCounts(
    unread: payload.unreadCount,
    newCount: payload.newCount,
  );

  debugPrint(
    '💾 [BGIsolate] persisted counts via AppStorage — unread: ${payload.unreadCount}, new: ${payload.newCount}',
  );

  // ✅ Sync OS app badge directly — no GetX needed for this either
  try {
    if (payload.unreadCount > 0) {
      await FlutterNewBadger.setBadge(payload.unreadCount);
    } else {
      await FlutterNewBadger.removeBadge();
    }
    debugPrint('📱 [BGIsolate] app badge synced → ${payload.unreadCount}');
  } catch (e) {
    debugPrint('⚠️ [BGIsolate] badge sync failed: $e');
  }

  service.showLocalNotification(
    id: message.messageId.hashCode.abs() % 100000,
    title: payload.title,
    body: payload.description,
    payload: payload, // ✅ typed now
  );

  debugPrint('✅ [BGIsolate] notification shown');
}

/// Local notification background tap — must be top-level.
@pragma('vm:entry-point')
void onBackgroundLocalNotificationTap(NotificationResponse response) {
  debugPrint(
    '👆 [BGIsolate] background local notification tapped — payload: ${response.payload}',
  );
  PushNotificationService.lastPayload = response.payload;
  PushNotificationService.notificationTapStream.add(response.payload!);
}
