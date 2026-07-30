// notification_permission_dialog.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../../components/app_ui/popup_widgets/notification_permission_popup.dart';
import '../push_notification_service.dart';

class NotificationPermissionHelper {
  NotificationPermissionHelper._();

  static Future<void> askWithRationale({
    String title = 'Stay in the loop 🔔',
    String body =
        'Get notified about your orders, offers, and important updates. '
        'You can turn this off anytime in Settings.',
    String confirmLabel = 'Allow',
    String denyLabel = 'Not now',
  }) async {
    final service = PushNotificationService.to;

    await service.refreshNotificationPermissionStatus();

    final status = await service.getNotificationStatus();

    switch (status) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        return;

      case AuthorizationStatus.denied:
        return;

      case AuthorizationStatus.notDetermined:
        break;
    }
    final agreed = await Get.dialog<bool>(
      barrierDismissible: false,
      NotificationPermissionPopup(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        denyLabel: denyLabel,
      ),
    );

    if (agreed != true) {
      return;
    }

    await service.requestPermissionIfNeeded();

    // Refresh after the OS dialog closes.
    await service.refreshNotificationPermissionStatus();
  }

  //
}

// Small utility extension to avoid a temp variable above
extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
