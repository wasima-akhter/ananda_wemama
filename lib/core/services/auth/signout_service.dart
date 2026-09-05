import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../app/service_export.dart';
import '../../../features/main_tabs/chat/controller/chat_controller.dart';
import '../../../features/main_tabs/chat/controller/chat_inbox_controller.dart';
import '../../../features/main_tabs/community/feed/controller/community_controller.dart';
import '../../../features/main_tabs/experts/controller/experts_controller.dart';
import '../../../features/main_tabs/home/controller/home_controller.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../features/main_tabs/match/controller/match_controller.dart';
import '../../../features/more/notification/controller/notification_controller.dart';
import '../../../features/shared/wave_request/controller/wave_request_controller.dart';
import '../../local/app_storage.dart';
import '../socket/socket_service.dart';

class SignoutService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<bool> signoutFromBackend({required String fcmToken}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.logout.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
        data: {"fcmToken": fcmToken},
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
  }

  Future<String?> getCurrentFcmToken() async {
    try {
      final token = await _fcm.getToken();

      debugPrint('🔑 [SignoutService] current FCM token: $token');

      return token;
    } catch (e, st) {
      debugPrint('❌ [SignoutService] failed to get FCM token: $e');
      debugPrint('$st');

      return null;
    }
  }

  Future<void> signOut() async {
    final fcmToken = await getCurrentFcmToken();

    if (fcmToken == null || fcmToken.isEmpty) {
      debugPrint(
        '⚠️ [SignoutService] FCM token unavailable. '
        'Logout cancelled to avoid logging out without removing the device token.',
      );
      return;
    }

    final res = await signoutFromBackend(fcmToken: fcmToken);

    if (!res) {
      debugPrint('❌ [SignoutService] backend logout failed');
      return;
    }

    debugPrint(
      '✅ [SignoutService] backend logout successful for current device',
    );

    // Disconnect socket FIRST
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().disconnectSocket();
    }

    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().clearData();
      Get.delete<ChatController>(force: true);
    }

    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().notifications.clear();
    }

    if (Get.isRegistered<WaveRequestController>()) {
      Get.find<WaveRequestController>().newWaveList.clear();
    }

    // Delete user-scoped controllers
    Get.delete<ChatInboxController>(force: true);
    Get.delete<NotificationController>(force: true);
    Get.delete<ProfileController>(force: true);
    Get.delete<MatchController>(force: true);
    Get.delete<WaveRequestController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<ExpertsController>(force: true);
    Get.delete<CommunityController>(force: true);

    // Clear storage
    AppStorage.to.logout();
  }

  Future<bool> deleteAccountFromBackend({required String password}) async {
    apiCall() {
      return ApiClient().delete(
        Endpoints.deleteAccount.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
        data: {"password": password},
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
  }
}
