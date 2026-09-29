import 'package:get/get.dart';

import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';
import '../../../features/main_tabs/match/controller/match_controller.dart';
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
    // final premiumService = PremiumAccessService.to;

    print('\n╔════════════════════════════════════════╗');
    print('║ [SessionNavigator.openMeeting] START    ║');
    print('╚════════════════════════════════════════╝');

    _openMeetingScreen(channelName, sessionTitle, hostName);
    return true;
    // premiumService.printFullState();

    // // ✅ Wait for ready
    // if (!premiumService.isReady.value) {
    //   int attempts = 0;
    //   while (!premiumService.isReady.value && attempts < 50) {
    //     await Future.delayed(const Duration(milliseconds: 100));
    //     attempts++;
    //   }

    //   if (!premiumService.isReady.value) {
    //     print('🔴 Service init TIMEOUT');
    //     if (Get.isDialogOpen ?? false) Get.back();
    //     return false;
    //   }
    // }

    // // ✅ CHECK 1: Quick check
    // if (premiumService.isPremiumUserNow) {
    //   print('✅ CHECK 1 PASSED: opening meeting');
    //   _openMeetingScreen(channelName, sessionTitle, hostName);
    //   return true;
    // }

    // // ✅ CHECK 2: Manual verification (iOS retry logic)
    // print('\n🔄 CHECK 1 FAILED: attempting verification...');
    // final verified = await premiumService.verifyPremiumStatusWithRetry(
    //   maxAttempts: 3,
    // );

    // if (verified) {
    //   print('✅ CHECK 2 PASSED: opening meeting');
    //   _openMeetingScreen(channelName, sessionTitle, hostName);
    //   return true;
    // }

    // // ❌ Not premium
    // print('❌ BOTH CHECKS FAILED: redirecting to upgrade');
    // if (Get.isDialogOpen ?? false) Get.back();
    // Get.toNamed(RoutePaths.subscriptionUpgrade);
    // return false;
  }

  static void _openMeetingScreen(
    String channelName,
    String sessionTitle,
    String hostName,
  ) {
    if (Get.isDialogOpen ?? false) Get.back();

    Get.toNamed(
      RoutePaths.meetingScreen,
      arguments: MeetingCtrlAgModel(
        channelname: channelName,
        sessionTitle: sessionTitle,
        hostName: hostName,
      ),
    );

    print('╔════════════════════════════════════════╗');
    print('║ [SessionNavigator] MEETING OPENED ✅    ║');
    print('╚════════════════════════════════════════╝\n');
  }

  // Same for open() method:
  ///// Returns true if successfully opened session, false otherwise

  static Future<bool> open(Session session) async {
    // final premiumService = PremiumAccessService.to;

    // if (!premiumService.isReady.value) {
    //   int attempts = 0;
    //   while (!premiumService.isReady.value && attempts < 50) {
    //     await Future.delayed(const Duration(milliseconds: 100));
    //     attempts++;
    //   }

    //   if (!premiumService.isReady.value) {
    //     if (Get.isDialogOpen ?? false) Get.back();
    //     return false;
    //   }
    // }

    // // ✅ First check
    // bool isPremium = premiumService.isPremiumUserNow;

    // // ✅ Fallback check if first failed (iOS)
    // if (!isPremium) {
    //   isPremium = await premiumService.verifyPremiumStatusManually();
    // }

    // if (!isPremium) {
    //   if (Get.isDialogOpen ?? false) Get.back();
    //   Get.toNamed(RoutePaths.subscriptionUpgrade);
    //   return false;
    // }

    // Proceed with session join
    if (Get.isDialogOpen ?? false) Get.back();

    switch (session.status) {
      case 'Ongoing':
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
        await Get.offAllNamed(RoutePaths.upcomingSessions);
        return true;

      default:
        Get.offAllNamed(RoutePaths.mainNav);
        return false;
    }
  }

  //
  // Manually test premium status
  static Future<void> debugTestPremiumStatus() async {
    final premium = PremiumAccessService.to;

    print('\n🧪 PREMIUM STATUS DEBUG TEST');
    premium.printFullState();

    print('\n🔄 Manually verifying...');
    final verified = await premium.verifyPremiumStatusManually();

    print('\n✅ Verification result: $verified');
    premium.printFullState();
  }
}

//----------------------------------------------------//
//-------------------  TESTING PLAN -----------------//
//---------------------------------------------------//

// Add a debug button to test both scenarios

// TEST 1: Premium Status
Future<void> debugTestPremiumIOS() async {
  final p = PremiumAccessService.to;

  print('\n═══ TESTING PREMIUM STATUS ═══');
  p.printFullState();

  print('\nRefreshing...');
  await p.refreshPremiumStatus();
  p.printFullState();

  print('\nVerifying with retry...');
  final verified = await p.verifyPremiumStatusWithRetry();
  print('Result: $verified\n');
}

// TEST 2: Wave Count
void debugTestWaveCount() {
  final mc = MatchController.to;

  print('\n═══ TESTING WAVE COUNT ═══');
  print('Premium ready: ${PremiumAccessService.to.isReady.value}');
  print('Is premium: ${PremiumAccessService.to.isPremiumUserNow}');
  print('Profile ready: ${mc.profile.value != null}');
  print('Remaining waves: ${mc.remainingWaves}');
  print('Is waveLimit reached: ${mc.isWaveLimitReached}\n');
}

// TEST 3: Session Join
Future<void> debugTestSessionJoin() async {
  final result = await SessionNavigator.openMeeting(
    channelName: 'test',
    sessionTitle: 'Test Session',
    hostName: 'Test Host',
  );
  print('Session join result: $result');
}
