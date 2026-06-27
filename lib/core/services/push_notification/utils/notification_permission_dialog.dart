// notification_permission_dialog.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../push_notification_service.dart';

class NotificationPermissionHelper {
  NotificationPermissionHelper._();

  /// Shows your custom rationale dialog, then triggers the system prompt
  /// only if the user agrees. Call this from any screen at the right moment.
  ///
  /// Example:
  ///   After splash → home loads → first time user sees home screen:
  ///   await NotificationPermissionHelper.askWithRationale();
  static Future<void> askWithRationale({
    String title = 'Stay in the loop 🔔',
    String body =
        'Get notified about your orders, offers, and important updates. '
        'You can turn this off anytime in Settings.',
    String confirmLabel = 'Allow',
    String denyLabel = 'Not now',
  }) async {
    // 1. Check if already handled — skip dialog entirely if so
    final service = PushNotificationService.to;
    final alreadyGranted = await service.requestPermissionIfNeeded.let((
      _,
    ) async {
      final s = await FirebaseMessaging.instance.getNotificationSettings();
      return s.authorizationStatus == AuthorizationStatus.authorized ||
          s.authorizationStatus == AuthorizationStatus.provisional;
    });

    if (alreadyGranted) {
      debugPrint(
        'ℹ️ [NotificationPermissionHelper] already granted — no dialog needed',
      );
      return;
    }

    // 2. Show your own soft-ask UI
    final userAgreed = await Get.dialog<bool>(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Body
              Text(
                body,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(confirmLabel),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  denyLabel,
                  style: const TextStyle(color: Colors.black45),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (userAgreed != true) {
      debugPrint(
        'ℹ️ [NotificationPermissionHelper] user declined soft-ask — skipping system prompt',
      );
      return;
    }

    // 3. User agreed to your dialog → now trigger the real system prompt
    debugPrint(
      '🔧 [NotificationPermissionHelper] user agreed — triggering system prompt',
    );
    await service.requestPermissionIfNeeded();
  }
}

// Small utility extension to avoid a temp variable above
extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
