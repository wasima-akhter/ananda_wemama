import 'package:mama_app/app/service_export.dart';

import '../model/notifications_model.dart';
import '../service/notification_service.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  final NotificationService _service = NotificationService();

  final notifications = <NotificationItemModel>[].obs;
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final isupdateIsSeenLoading_ = false.obs;
  bool get isupdateIsSeenLoading => isupdateIsSeenLoading_.value;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  // ─────────────────────────────
  // 🔹 Socket — add incoming notification at top
  // ─────────────────────────────
  void addNotification(dynamic data) {
    notifications.insert(0, NotificationItemModel.fromJson(data));
  }

  // ─────────────────────────────
  // 🔹 Fetch all notifications
  // ─────────────────────────────
  Future<void> getNotifications() async {
    if (isLoading_.value) return;
    isLoading_.value = true;
    try {
      final data = await _service.fetchNotifications();
      notifications.assignAll(data);
      log('notifications loaded: ${notifications.length}');
    } catch (e) {
      log("Error fetch notifications: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  // ─────────────────────────────
  // 🔹 Mark single notification as seen
  // ─────────────────────────────
  Future<void> updateIsSeen({required String notificationId}) async {
    isupdateIsSeenLoading_.value = true;
    try {
      final isSuccess = await _service.updateIsSeen(
        notificationId: notificationId,
      );
      if (isSuccess) {
        final index = notifications.indexWhere((e) => e.id == notificationId);
        if (index != -1) {
          notifications[index] = notifications[index].copyWith(isSeen: true);
        }

        "Notification marked as seen".showToast();
      }
    } catch (e) {
      log("Error updateIsSeen: $e");
    } finally {
      isupdateIsSeenLoading_.value = false;
    }
  }
}

/*
// ─────────────────────────────────────────────────────────────────────────────
// notification_binding.dart
//
// Register all notification-related services + controller in one place.
// Add this binding to your initial route or AppPages.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:get/get.dart';

import 'controllers/notification_controller.dart';
import 'services/firebase_token_service.dart';
import 'services/push_notification/push_notification_service.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Services are permanent — they live for the app lifetime
    Get.putAsync<FirebaseTokenService>(
      () async => FirebaseTokenService(),
      permanent: true,
    );

    Get.putAsync<PushNotificationService>(
      () async => PushNotificationService().init(),
      permanent: true,
    );

    // Controller is created after the service so the stream is ready
    Get.put<NotificationController>(
      NotificationController(),
      permanent: true,
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// main.dart  (relevant parts only — merge with your existing file)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bindings/notification_binding.dart';
import 'utils/shared_pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  prefs ??= await SharedPreferences.getInstance();

  runApp(const App());
}


// ─────────────────────────────────────────────────────────────────────────────
// app.dart  (GetMaterialApp — relevant parts)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/notification_binding.dart';
import 'routes/app_pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // Bind notification services at app start
      initialBinding: NotificationBinding(),
    );
  }
}

*/

/*


import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../views/inbox/inbox_view.dart';

/// Listens to [PushNotificationService.notificationTapStream] and routes the
/// user to the correct screen. Also exposes reactive state for the unread badge.
class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  StreamSubscription<String>? _tapSubscription;

  // ── Reactive state ────────────────────────────────────────────────────────────

  /// Bump this whenever a notification arrives so widgets can react.
  final RxInt unreadCount = 0.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _listenToTapStream();
  }

  @override
  void onClose() {
    _tapSubscription?.cancel();
    super.onClose();
  }

  // ── Stream wiring ─────────────────────────────────────────────────────────────

  void _listenToTapStream() {
    // Import here to avoid a circular dep at the top of the file.
    // Push service is already registered before this controller is created.
    // We use a late import pattern to keep the dependency one-directional.
    _tapSubscription = _tapStream().listen(_onTapEvent);
  }

  Stream<String> _tapStream() {
    // Accessed via the static getter to avoid importing the service at the
    // top of this file (prevents a circular dependency).
    return _NotificationStreamBridge.stream;
  }

  void _onTapEvent(String event) {
    if (event != 'notification_tap') return;

    final raw = _NotificationStreamBridge.lastPayload;
    if (raw == null) return;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _route(data);
    } catch (e) {
      debugPrint('NotificationController: failed to decode payload — $e');
    }
  }

  // ── Routing ───────────────────────────────────────────────────────────────────

  void _route(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    switch (type) {
      case 'chat':
        debugPrint('Routing → InboxView');
        Get.toNamed(InboxView.routeName, arguments: data);
        break;
      // Add more cases as your notification types grow
      default:
        debugPrint('NotificationController: unhandled type "$type"');
    }
  }

  // ── Called by the service on foreground receive (no tap) ──────────────────────

  void onNotificationReceived() {
    unreadCount.value++;
    // TODO: call your UnreadCountService equivalent here, e.g.:
    // Get.find<UnreadCountService>().fetchUnreadCounts();
  }

  void resetUnreadCount() => unreadCount.value = 0;
}

// ── Bridge ─────────────────────────────────────────────────────────────────────
// Indirection so NotificationController doesn't import PushNotificationService
// (avoids circular deps). Wire this up in your binding or main.dart.

class _NotificationStreamBridge {
  _NotificationStreamBridge._();

  static Stream<String> get stream =>
      _PushServiceAccessor.tapStream;

  static String? get lastPayload =>
      _PushServiceAccessor.lastPayload;
}

// ── Accessor (thin shim — swap if you reorganise the service) ─────────────────
// Keep this in the same file so only this file has the import chain.

import 'package:your_app/data/services/push_notification/push_notification_service.dart'
    as _svc;

class _PushServiceAccessor {
  static Stream<String> get tapStream =>
      _svc.PushNotificationService.notificationTapStream.stream;

  static String? get lastPayload =>
      _svc.PushNotificationService.lastPayload;
}

*/
