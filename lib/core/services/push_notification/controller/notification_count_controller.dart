// notification_count_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:get/get.dart';

import '../../../network/helpers/network_helpers.dart';

class NotificationCountController extends GetxController {
  static NotificationCountController get to => Get.find();

  // 🔔 bell icon badge — "new" notifications since last screen open
  final RxInt newCount = 0.obs;

  // 📱 OS app icon badge — total unread
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  // in NotificationCountController
  void refreshFromStorage() {
    debugPrint(
      '🔄 [NotificationCountController] refreshing from storage on resume',
    );
    _restore();
  }

  void _restore() {
    unreadCount.value = storage.getUnreadNotifCount;
    newCount.value = storage.getNewNotifCount;
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
    storage.setNotificationCounts(
      unread: unreadCount.value,
      newCount: newCount.value,
    );
  }

  void _syncBadge() {
    try {
      if (unreadCount.value > 0) {
        FlutterNewBadger.setBadge(unreadCount.value);
      } else {
        FlutterNewBadger.removeBadge();
      }
      debugPrint(
        '📱 [NotificationCountController] app badge synced → ${unreadCount.value}',
      );
    } catch (e) {
      debugPrint('⚠️ [NotificationCountController] badge sync failed: $e');
    }
  }
}
