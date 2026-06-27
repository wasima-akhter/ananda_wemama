// push_notification_service.dart

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../firebase/firebase_service.dart';
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

  Future<void> _initLocalPlugin() async {
    debugPrint('🔧 [PushNotificationService] initializing local plugin...');
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
    debugPrint('✅ [PushNotificationService] local plugin initialized');
  }

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

    debugPrint(
      granted
          ? '✅ [PushNotificationService] permission GRANTED'
          : '⚠️ [PushNotificationService] permission DENIED by user',
    );
    return granted;
  }

  /// Public so the background isolate top-level function can call it on a
  /// fresh, un-registered instance without touching GetX.
  Future<void> createAndroidChannelOnly() async {
    if (_channelInitialized) {
      debugPrint(
        'ℹ️ [PushNotificationService] Android channel already created, skipping',
      );
      return;
    }

    debugPrint('🔧 [PushNotificationService] creating Android channel...');

    // Re-initialize the local plugin with no callbacks (safe in isolate)
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(settings: settings);

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
    debugPrint('✅ [PushNotificationService] Android channel created');
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
    debugPrint('🔧 [PushNotificationService] registering FCM listeners...');

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Background tap (app was in background, user tapped notification)
    FirebaseMessaging.onMessageOpenedApp.listen(_onBackgroundTap);

    // ⚠️  DO NOT call FirebaseMessaging.onBackgroundMessage() here.
    //     It is registered once in main() via the top-level handler below,
    //     before runApp(). Calling it twice causes undefined behavior.

    debugPrint('✅ [PushNotificationService] FCM listeners registered');
  }

  Future<void> _subscribeToTopic() async {
    debugPrint('🔧 [PushNotificationService] subscribing to topic "Client"...');
    await _fcm.subscribeToTopic('Client');
    debugPrint('✅ [PushNotificationService] subscribed to topic "Client"');
  }

  Future<void> _handleTerminatedLaunch() async {
    debugPrint(
      '🔧 [PushNotificationService] checking terminated-launch notification...',
    );
    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      final payload = details!.notificationResponse?.payload;
      if (payload != null) {
        lastPayload = payload;
        notificationTapStream.add('notification_tap');
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
      return;
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
      final token = await _fcm.getToken();

      if (token == null) {
        debugPrint(
          '⚠️ [PushNotificationService] FCM token is null — will retry on next opportunity',
        );
        return; // don't increment retry — token being null is usually transient
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
      return;
    }

    final payload = NotificationPayload.fromMap(message.data);
    debugPrint('🔔 [PushNotificationService] parsed payload: $payload');

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
  PushNotificationService.notificationTapStream.add('notification_tap');
}
