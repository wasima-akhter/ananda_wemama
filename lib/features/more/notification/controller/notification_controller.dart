import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controller_export.dart';
import '../model/notifications_model.dart';
import '../service/notification_service.dart';

class NotificationController extends GetxController {
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
      final isSuccess = await _service.updateIsSeen(notificationId: notificationId);
      if (isSuccess) {
        final index = notifications.indexWhere((e) => e.id == notificationId);
        if (index != -1) {
          notifications[index] = notifications[index].copyWith(isSeen: true);
        }
      }
    } catch (e) {
      log("Error updateIsSeen: $e");
    } finally {
      isupdateIsSeenLoading_.value = false;
    }
  }
}
