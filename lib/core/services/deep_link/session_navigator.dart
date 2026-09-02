import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';
import '../../../features/shared/subscription/subscription_access/premium_access_service.dart';
import '../../../features/video_meeting/controller/arg_model/meeting_ctrl_ag_model.dart';
import '../../../routes/route_paths.dart';

class SessionNavigator {
  const SessionNavigator._();

  /// Returns true if successfully opened meeting, false otherwise
  /// Returns true if successfully opened meeting, false otherwise
  /// Returns true if successfully opened meeting, false otherwise
  static Future<bool> openMeeting({
    required String channelName,
    required String sessionTitle,
    required String hostName,
  }) async {
    final premiumService = PremiumAccessService.to;

    debugPrint('\n╔════════════════════════════════════════╗');
    debugPrint('║ [SessionNavigator.openMeeting] START    ║');
    debugPrint('╚════════════════════════════════════════╝');

    // ✅ Print current state
    premiumService.debugPrintFullState();

    // ✅ Wait for service to be ready
    if (!premiumService.isReady.value) {
      debugPrint(
        '⏳ [SessionNavigator.openMeeting] Service NOT ready, waiting...',
      );

      int attempts = 0;
      while (!premiumService.isReady.value && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      debugPrint('⏳ [SessionNavigator.openMeeting] Waited $attempts attempts');

      if (!premiumService.isReady.value) {
        debugPrint(
          '🔴 [SessionNavigator.openMeeting] Service initialization TIMEOUT',
        );
        premiumService.debugPrintFullState();
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        return false;
      }

      debugPrint('✅ [SessionNavigator.openMeeting] Service now READY');
      premiumService.debugPrintFullState();
    } else {
      debugPrint('✅ [SessionNavigator.openMeeting] Service already READY');
    }

    // ✅ Check if premium
    debugPrint('\n🔐 [SessionNavigator.openMeeting] Premium check:');
    debugPrint('   isPremiumUserNow: ${premiumService.isPremiumUserNow}');
    debugPrint('   isPremiumUser.value: ${premiumService.isPremiumUser.value}');

    if (!premiumService.isPremiumUserNow) {
      debugPrint('🔒 [SessionNavigator.openMeeting] ❌ User is NOT premium');
      premiumService.debugPrintFullState();

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.toNamed(RoutePaths.subscriptionUpgrade);
      return false;
    }

    debugPrint(
      '✅ [SessionNavigator.openMeeting] ✅ User IS premium - opening meeting!',
    );
    premiumService.debugPrintFullState();

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    Get.toNamed(
      RoutePaths.meetingScreen,
      arguments: MeetingCtrlAgModel(
        channelname: channelName,
        sessionTitle: sessionTitle,
        hostName: hostName,
      ),
    );

    debugPrint('╔════════════════════════════════════════╗');
    debugPrint('║ [SessionNavigator.openMeeting] SUCCESS  ║');
    debugPrint('╚════════════════════════════════════════╝\n');

    return true;
  }

  /// Returns true if successfully opened session, false otherwise
  /// Returns true if successfully opened session, false otherwise
  static Future<bool> open(Session session) async {
    debugPrint(
      "🎯 [SessionNavigator.open] → "
      "id=${session.id}, status=${session.status}",
    );

    final premiumService = PremiumAccessService.to;

    // ✅ Wait for service to be ready
    if (!premiumService.isReady.value) {
      debugPrint(
        '⏳ [SessionNavigator.open] Waiting for PremiumAccessService...',
      );

      int attempts = 0;
      while (!premiumService.isReady.value && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (!premiumService.isReady.value) {
        debugPrint('🔴 [SessionNavigator.open] Service initialization timeout');
        // ✅ Close dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        return false;
      }
    }

    // ✅ Premium gate
    if (!premiumService.isPremiumUserNow) {
      debugPrint("🔒 [SessionNavigator.open] User is not premium");

      // ✅ Close dialog BEFORE navigating
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.toNamed(RoutePaths.subscriptionUpgrade);
      return false;
    }

    switch (session.status) {
      case 'Ongoing':
        debugPrint('🔗 [SessionNavigator.open] → Ongoing → meetingScreen');

        // ✅ Close dialog before opening meeting
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.offAllNamed(
          RoutePaths.meetingScreen,
          arguments: MeetingCtrlAgModel(
            channelname: session.channelName,
            sessionTitle: session.title,
            hostName: session.expert?.name ?? '',
          ),
        );
        return true;

      case 'Upcoming':
        debugPrint('🔗 [SessionNavigator.open] → Upcoming → upcomingSessions');

        // ✅ Close dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        await Get.offAllNamed(RoutePaths.upcomingSessions);
        await Future.microtask(() => null);
        return true;

      default:
        debugPrint(
          "🔗 [SessionNavigator.open] → unhandled status '${session.status}'",
        );

        // ✅ Close dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.offAllNamed(RoutePaths.mainNav);
        return false;
    }
  }
}
