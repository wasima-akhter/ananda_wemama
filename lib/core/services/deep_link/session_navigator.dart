import 'dart:developer';

import 'package:get/get.dart';

import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';
import '../../../features/shared/subscription/subscription_access/premium_access_service.dart';
import '../../../features/video_meeting/controller/arg_model/meeting_ctrl_ag_model.dart';
import '../../../routes/route_paths.dart';

class SessionNavigator {
  const SessionNavigator._();

  static Future<void> openMeeting({
    required String channelName,
    required String sessionTitle,
    required String hostName,
  }) async {
    if (!PremiumAccessService.to.isPremiumUserNow) {
      Get.toNamed(RoutePaths.subscriptionUpgrade);
      return;
    }

    Get.toNamed(
      RoutePaths.meetingScreen,
      arguments: MeetingCtrlAgModel(
        channelname: channelName,
        sessionTitle: sessionTitle,
        hostName: hostName,
      ),
    );
  }

  static Future<void> open(Session session) async {
    log(
      "🎯 [SessionNavigator] open() → "
      "id=${session.id}, status=${session.status}",
    );

    // Premium gate
    if (!PremiumAccessService.to.isPremiumUserNow) {
      log("🔒 [SessionNavigator] User is not premium → promoCodeScreen");

      Get.offAllNamed(RoutePaths.subscriptionUpgrade);
      return;
    }

    switch (session.status) {
      case 'Ongoing':
        log('🔗 [DeepLinkService] → Ongoing → navigating to meetingScreen');
        Get.offAllNamed(
          RoutePaths.meetingScreen,
          arguments: MeetingCtrlAgModel(
            channelname: session.channelName,
            sessionTitle: session.title,
            hostName: session.expert?.name ?? '',
          ),
        );
        break;

      case 'Upcoming':
        log(
          '🔗 [DeepLinkService] → Upcoming → navigating to mainNav then tab 4',
        );
        await Get.offAllNamed(RoutePaths.upcomingSessions);
        await Future.microtask(() => null);
        log('🔗 [DeepLinkService] → calling upcomingSessions screen');
        // MainNavController.to.goToTab(4);
        break;

      default:
        log(
          "🔗 [DeepLinkService] → unhandled status '${session.status}' → mainNav",
        );
        Get.offAllNamed(RoutePaths.mainNav);
    }
  }
}
