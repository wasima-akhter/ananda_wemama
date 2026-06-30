// notification_count_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationCountController extends GetxController {
  static NotificationCountController get to => Get.find();

  // 🔔 bell icon badge — "new" notifications since last screen open
  final RxInt newCount = 0.obs;

  // 📱 OS app icon badge — total unread
  final RxInt unreadCount = 0.obs;

  final _storage = GetStorage();
  static const _keyUnread = 'notif_unread_count';
  static const _keyNew = 'notif_new_count';

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    unreadCount.value = _storage.read<int>(_keyUnread) ?? 0;
    newCount.value = _storage.read<int>(_keyNew) ?? 0;
    _syncBadge();
    debugPrint(
      '🔢 [NotificationCountController] restored — unread: ${unreadCount.value}, new: ${newCount.value}',
    );
  }

  /// Called whenever a push arrives in ANY app state (foreground/background/terminated)
  /// Pass counts straight from NotificationPayload.
  void onPushReceived({required int unread, required int newN}) {
    debugPrint(
      '🔢 [NotificationCountController] onPushReceived — unread: $unread, new: $newN',
    );

    unreadCount.value = unread;
    newCount.value = newN;

    _persist();
    _syncBadge();
  }

  /// Called from API response when fetching notification list / count endpoint
  void syncFromApi({required int unread, required int newN}) {
    debugPrint(
      '🔢 [NotificationCountController] syncFromApi — unread: $unread, new: $newN',
    );
    unreadCount.value = unread;
    newCount.value = newN;
    _persist();
    _syncBadge();
  }

  /// Call when user opens the notification screen — clears bell dot only
  void onNotificationScreenOpened() {
    debugPrint(
      '🔢 [NotificationCountController] screen opened — clearing newCount',
    );
    newCount.value = 0;
    _persist();
    // unreadCount + app badge stay until items are actually marked read
  }

  /// Call after marking all/some as read via API
  void onMarkedRead({required int remainingUnread}) {
    debugPrint(
      '🔢 [NotificationCountController] marked read — remaining unread: $remainingUnread',
    );
    unreadCount.value = remainingUnread;
    _persist();
    _syncBadge();
  }

  void _persist() {
    _storage.write(_keyUnread, unreadCount.value);
    _storage.write(_keyNew, newCount.value);
  }

  void _syncBadge() {
    try {
      if (unreadCount.value > 0) {
        FlutterAppBadger.updateBadgeCount(unreadCount.value);
      } else {
        FlutterAppBadger.removeBadge();
      }
      debugPrint(
        '📱 [NotificationCountController] app badge synced → ${unreadCount.value}',
      );
    } catch (e) {
      debugPrint('⚠️ [NotificationCountController] badge sync failed: $e');
    }
  }

  /// For the background isolate — static version since GetX isn't available there
  static Future<void> syncBadgeFromStorage(int unreadCount) async {
    try {
      if (unreadCount > 0) {
        await FlutterAppBadger.updateBadgeCount(unreadCount);
      } else {
        await FlutterAppBadger.removeBadge();
      }
      debugPrint('📱 [BGIsolate] app badge synced → $unreadCount');
    } catch (e) {
      debugPrint('⚠️ [BGIsolate] badge sync failed: $e');
    }
  }
}
