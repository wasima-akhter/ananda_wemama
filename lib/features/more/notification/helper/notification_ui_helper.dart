import 'package:flutter/material.dart';

import '../../../../core/themes/color/colors.dart';
import '../model/notifications_model.dart';

class NotificationUiData {
  final Color color;
  final IconData icon;

  const NotificationUiData({required this.color, required this.icon});
}

class NotificationUiHelper {
  static NotificationUiData get(String type) {
    switch (type) {
      case NotificationTypes.likePost:
        return const NotificationUiData(
          color: AppPalette.snackError,
          icon: Icons.thumb_up_alt,
        );

      case NotificationTypes.commentPost:
        return const NotificationUiData(
          color: AppPalette.snackPurple,
          icon: Icons.message_rounded,
        );

      case NotificationTypes.approveCommunity:
        return const NotificationUiData(
          color: AppPalette.snackSuccess,
          icon: Icons.groups,
        );

      case NotificationTypes.sentMessage:
        return const NotificationUiData(
          color: Colors.teal,
          icon: Icons.chat_bubble,
        );

      case NotificationTypes.acceptWave:
        return const NotificationUiData(
          color: AppPalette.snackPurple,
          icon: Icons.waving_hand,
        );

      case NotificationTypes.sentWave:
        return const NotificationUiData(
          color: Colors.deepPurple,
          icon: Icons.back_hand_rounded,
        );

      case NotificationTypes.sessionReminder:
        return const NotificationUiData(
          color: Colors.orange,
          icon: Icons.notifications_active,
        );

      default:
        return const NotificationUiData(
          color: Colors.grey,
          icon: Icons.notifications,
        );
    }
  }
}
