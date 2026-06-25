import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

import '../../../features/main_nav/controller/main_nav_controller.dart';
import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';
import '../../../features/video_meeting/controller/arg_model/meeting_ctrl_ag_model.dart';
import '../../../routes/route_paths.dart';
import '../../network/helpers/network_helpers.dart';
import '../session/session_service.dart';
// import your session API and model

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  String? pendingLiveId;
  bool _appReady = false;

  // Called from main() — only captures, zero navigation
  Future<void> captureInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        // Store only — never call _handleUri or _openLive here
        pendingLiveId = _extractLiveId(initialUri);
        log('Captured initial liveId: $pendingLiveId');
      }
    } catch (e) {
      log('Deep link capture error: $e');
    }
  }

  // Called by SplashController AFTER it finishes navigating
  void markAppReady() {
    if (_appReady) return;
    _appReady = true;
    _startListening(); // stream only starts now — impossible to race splash
  }

  void _startListening() {
    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (e) => log('Deep link error: $e'),
    );
  }

  // Only called when app is fully ready (stream fires after markAppReady)
  void _handleUri(Uri uri) {
    log('Deep link received: $uri');
    final liveId = _extractLiveId(uri);
    if (liveId == null) return;
    _openLive(liveId); // safe — app is always ready here
  }

  // DeepLinkService

  Future<void> _openLive(String liveId) async {
    log("🔗 [DEEPLINK] _openLive() → liveId='$liveId'");
    log("🔗 [DEEPLINK] _openLive() → currentRoute='${Get.currentRoute}'");
    log("🔗 [DEEPLINK] _openLive() → loggedIn='${storage.getLoggedIn}'");

    if (!storage.getLoggedIn) {
      pendingLiveId = liveId;
      log(
        "🔗 [DEEPLINK] _openLive() → User NOT logged in. Stored pendingLiveId.",
      );

      // ✅ KEY FIX: if already on signin, don't navigate again — just store
      if (Get.currentRoute == RoutePaths.signin) {
        log(
          "🔗 [DEEPLINK] _openLive() → Already on signin. Skipping navigation. pendingLiveId stored for post-login.",
        );
        return;
      }

      log(
        "🔗 [DEEPLINK] _openLive() → Navigating to signin with redirectLiveId arg.",
      );
      Get.offAllNamed(RoutePaths.signin, arguments: {'redirectLiveId': liveId});
      return;
    }

    log(
      "🔗 [DEEPLINK] _openLive() → User IS logged in. Navigating to session.",
    );
    await navigateToSession(liveId);
  }

  String? _extractLiveId(Uri uri) {
    log('🔗 Deep Link Received');
    log('├─ URI: $uri');
    log('├─ Scheme: ${uri.scheme}');
    log('├─ Host: ${uri.host}');
    log('├─ Path: ${uri.path}');
    log('├─ Path Segments: ${uri.pathSegments}');
    log('├─ Query Params: ${uri.queryParameters}');

    if (uri.scheme == 'wemama') {
      final liveId = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.first
          : null;

      log('📱 Custom Scheme Detected (wemama)');
      log('🎯 Extracted Live ID: $liveId');

      return liveId;
    } else if (uri.scheme == 'https') {
      final index = uri.pathSegments.indexOf('session');

      log('🌐 HTTPS Deep Link Detected');
      log('🔍 Session Index: $index');

      if (index != -1 && uri.pathSegments.length > index + 1) {
        final liveId = uri.pathSegments[index + 1];

        log('🎯 Extracted Live ID: $liveId');

        return liveId;
      }

      log('⚠️ No Live ID found after "session" segment');
    } else {
      log('⚠️ Unsupported scheme: ${uri.scheme}');
    }

    log('❌ Failed to extract Live ID');
    return null;
  }

  Future<void> handlePostLoginRedirect() async {
    log('🔄 handlePostLoginRedirect() called');

    if (pendingLiveId == null) {
      log('⚠️ No pendingLiveId found. Skipping redirect.');
      return;
    }

    final liveId = pendingLiveId!;

    log('🎯 Found pendingLiveId: $liveId');
    log('🧹 Clearing pendingLiveId before navigation');

    pendingLiveId = null;

    try {
      log('🚀 Navigating to session: $liveId');

      await navigateToSession(liveId);

      log('✅ Successfully navigated to session: $liveId');
    } catch (e, stackTrace) {
      log('❌ Failed to navigate to session: $liveId');
      log('🐞 Error: $e');
      log('📚 StackTrace: $stackTrace');

      // Optional: restore for retry
      // pendingLiveId = liveId;
    }
  }

  Future<void> navigateToSession(String liveId) async {
    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    log("🔗 [DEEPLINK] navigateToSession() START → liveId='$liveId'");

    try {
      log(
        "🔗 [DEEPLINK] → Calling SessionService().getSessionById('$liveId')...",
      );
      final Session? session = await SessionService().getSessionById(
        sessionId: liveId,
      );

      log(
        "🔗 [DEEPLINK] → API returned. session = ${session == null ? '[NULL]' : 'id=${session.id} status=${session.status}'}",
      );

      if (session == null || session.id.isEmpty) {
        log("🔗 [DEEPLINK] → Session null or empty id → Navigating to mainNav");
        Get.offAllNamed(RoutePaths.mainNav);
        return;
      }

      log("🔗 [DEEPLINK] → session.status = '${session.status}'");

      if (session.status == 'Ongoing') {
        log("🔗 [DEEPLINK] → Status=Ongoing → Navigating to meetingScreen");
        Get.offAllNamed(
          RoutePaths.meetingScreen,
          arguments: MeetingCtrlAgModel(
            channelname: session.channelName,
            sessionTitle: session.title,
            hostName: session.expert?.name ?? '',
          ),
        );
      } else if (session.status == 'Upcoming') {
        log("🔗 [DEEPLINK] → Status=Upcoming → Navigating to mainNav first...");
        await Get.offAllNamed(RoutePaths.mainNav);
        log(
          "🔗 [DEEPLINK] → mainNav navigation done. Waiting microtask for route to mount...",
        );
        await Future.microtask(() => null);
        log("🔗 [DEEPLINK] → Calling MainNavController.to.goToTab(4)...");
        MainNavController.to.goToTab(4);
        log("🔗 [DEEPLINK] → goToTab(4) called.");
      } else {
        log(
          "🔗 [DEEPLINK] → Status='${session.status}' (unhandled) → Navigating to mainNav",
        );
        Get.offAllNamed(RoutePaths.mainNav);
      }
    } catch (e, stack) {
      log("❌ [DEEPLINK] navigateToSession() ERROR: $e");
      log("❌ [DEEPLINK] STACK: $stack");
      Get.offAllNamed(RoutePaths.mainNav);
    }

    log("🔗 [DEEPLINK] navigateToSession() END");
    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
