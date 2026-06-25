import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'firebase_token_service.dart';

class PushNotificationService extends GetxService {
  // ── Singleton via GetX ───────────────────────────────────────────────────────
  static PushNotificationService get to => Get.find();

  // ── Private deps ─────────────────────────────────────────────────────────────
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _channelInitialized = false;

  // ── Public stream (broadcast so multiple listeners are safe) ─────────────────
  static final StreamController<String> notificationTapStream =
      StreamController<String>.broadcast();

  static String? lastPayload;

  // ── Lifecycle ─────────────────────────────────────────────────────────────────

  /// Call once from main() after Firebase.initializeApp().
  Future<PushNotificationService> init() async {
    await _initLocalPlugin();
    await _requestPermissions();
    await _createAndroidChannel();
    _registerFcmListeners();
    await _subscribeToTopic();
    await _handleTerminatedLaunch();
    await _uploadFcmToken();
    return this;
  }

  @override
  void onClose() {
    notificationTapStream.close();
    super.onClose();
  }

  // ── Setup steps ───────────────────────────────────────────────────────────────

  Future<void> _initLocalPlugin() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      settings: settings,
      // Both background + foreground taps come here
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundLocalNotificationTap,
    );
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> _createAndroidChannel() async {
    if (_channelInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'All push notifications',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // iOS foreground presentation
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _channelInitialized = true;
  }

  void _registerFcmListeners() {
    // App in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // App in background, user tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen(_onBackgroundTap);

    // App terminated (background isolate) — top-level function required by FCM
    FirebaseMessaging.onBackgroundMessage(onFcmBackgroundMessage);
  }

  Future<void> _subscribeToTopic() async {
    await _fcm.subscribeToTopic('Client');
  }

  /// Handles the case where the app was fully terminated and launched via a
  /// notification tap.
  Future<void> _handleTerminatedLaunch() async {
    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      final payload = details!.notificationResponse?.payload;
      if (payload != null) {
        lastPayload = payload;
        notificationTapStream.add('notification_tap');
        debugPrint('📩 Launched from terminated state — payload: $payload');
      }
    }
  }

  Future<void> _uploadFcmToken() async {
    final token = await _fcm.getToken();
    debugPrint('FCM token: $token');
    if (token == null) return;
    await Get.find<FirebaseTokenService>().updateToken(firebaseToken: token);
  }

  // ── Message handlers ──────────────────────────────────────────────────────────

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (message.data.isEmpty) return;

    lastPayload = jsonEncode(message.data);

    final notification = message.notification;
    if (notification == null) return;

    debugPrint(
      '🔔 Foreground message — title: ${notification.title}, '
      'data: ${message.data}',
    );

    // Refresh unread badge without navigating
    // NotificationController.to.onNotificationReceived(); <--------- call it

    showLocalNotification(
      id: _safeId(message.messageId),
      title: message.data['title'] ?? notification.title ?? '',
      body: message.data['body'] ?? notification.body ?? '',
      payload: message.data,
    );
  }

  void _onBackgroundTap(RemoteMessage message) {
    lastPayload = jsonEncode(message.data);
    notificationTapStream.add('notification_tap');

    debugPrint(
      '📲 Background tap — id: ${message.messageId}, '
      'data: ${message.data}',
    );
  }

  /// Called when user taps a local notification (foreground OR background).
  void _onLocalNotificationTap(NotificationResponse response) {
    lastPayload = response.payload;
    notificationTapStream.add('notification_tap');
  }

  // ── Public API ────────────────────────────────────────────────────────────────

  /// Shows a local notification. Safe to call from anywhere (inc. background
  /// isolate after re-creating the service).
  void showLocalNotification({
    required int id,
    required String title,
    required String body,
    Object? payload,
    String channelId = 'high_importance_channel',
    String channelName = 'High Importance Notifications',
  }) {
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
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  int _safeId(String? messageId) {
    if (messageId == null)
      return DateTime.now().millisecondsSinceEpoch % 100000;
    return messageId.hashCode.abs() % 100000;
  }
}

// ── Top-level callbacks (must live outside the class) ─────────────────────────

/// FCM background isolate handler — must be top-level.
@pragma('vm:entry-point')
Future<void> onFcmBackgroundMessage(RemoteMessage message) async {
  // Firebase is already initialized by FCM before this runs, but
  // calling again is a no-op, so it's safe to keep for safety.
  debugPrint('📦 FCM background isolate — id: ${message.messageId}');

  final service = PushNotificationService();
  await service._createAndroidChannel();

  service.showLocalNotification(
    id: message.messageId.hashCode.abs() % 100000,
    title: message.data['title'] ?? '',
    body: message.data['body'] ?? '',
    payload: message.data,
  );
}

/// Local notification background tap — must be top-level.
@pragma('vm:entry-point')
void onBackgroundLocalNotificationTap(NotificationResponse response) {
  PushNotificationService.lastPayload = response.payload;
  PushNotificationService.notificationTapStream.add('notification_tap');
}
