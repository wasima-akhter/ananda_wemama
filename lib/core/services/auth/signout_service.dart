import 'package:get/get.dart';

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

// class SignoutService {
//   void signOut() {
//     // ── 1. Clear local storage ──
//     AppStorage.to.logout();

//     // ── 2. Clear stale profile data ──
//     if (Get.isRegistered<ProfileController>()) {
//       Get.find<ProfileController>().userProfileData.value = null;
//     }

//     // ── 3. Disconnect socket ──
//     if (Get.isRegistered<SocketService>()) {
//       Get.find<SocketService>().disconnectSocket();
//     }

//     // ── 4. Navigate to login ──
//     // Get.offAllNamed(RoutePaths.login);
//   }
// }

class SignoutService {
  void signOut() {
    // Disconnect socket FIRST
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().disconnectSocket();
    }

    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().clearData();
    }

    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().notifications.clear();
    }

    if (Get.isRegistered<WaveRequestController>()) {
      Get.find<WaveRequestController>().newWaveList.clear();
    }

    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().userProfileData.value = null;
    }
    // Delete user-scoped controllers
    final controllersToDelete = [
      ChatController,
      ChatInboxController,
      NotificationController,
      ProfileController,
      MatchController,
      WaveRequestController,
      HomeController,
      ExpertsController,
      CommunityController,
    ];

    for (final controller in controllersToDelete) {
      if (Get.isRegistered(tag: controller.toString())) {
        Get.delete(tag: controller.toString(), force: true);
      }
    }
    // Clear storage
    AppStorage.to.logout();

    // Navigate
    // Get.offAllNamed(RoutePaths.login);
  }
}
