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

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  String? pendingLiveId;
  bool _appReady = false;

  // ── Cold start ────────────────────────────────────────────────────────────

  Future<void> captureInitialLink() async {
    log('🔧 [DeepLinkService] captureInitialLink() START');
    try {
      final initialUri = await _appLinks.getInitialLink();
      log('🔗 [DeepLinkService] raw initial URI: $initialUri');

      if (initialUri == null) {
        log('ℹ️ [DeepLinkService] no initial link — skipping');
        return;
      }

      // ✅ Notification intents arrive here on cold-start tap — ignore them
      if (_isNotificationIntent(initialUri)) {
        log(
          'ℹ️ [DeepLinkService] initial URI is a notification intent — '
          'ignoring (handled by PushNotificationController)',
        );
        return;
      }

      // Store only — zero navigation here
      pendingLiveId = _extractLiveId(initialUri);
      log(
        '🔗 [DeepLinkService] captureInitialLink() → pendingLiveId: $pendingLiveId',
      );
    } catch (e, st) {
      log('❌ [DeepLinkService] captureInitialLink() error: $e');
      log('❌ [DeepLinkService] $st');
    }
    log('🔧 [DeepLinkService] captureInitialLink() END');
  }

  // ── App ready (called by SplashController after navigation settles) ───────

  void markAppReady() {
    if (_appReady) {
      log(
        'ℹ️ [DeepLinkService] markAppReady() called but already ready — skipping',
      );
      return;
    }
    _appReady = true;
    log('✅ [DeepLinkService] markAppReady() → stream starting now');
    _startListening();
  }

  void _startListening() {
    log(
      '🔧 [DeepLinkService] _startListening() — subscribing to uriLinkStream',
    );
    _subscription = _appLinks.uriLinkStream.listen(
      (uri) {
        log('🔗 [DeepLinkService] stream event → raw URI: $uri');

        // ✅ Notification taps (background/foreground) fire SELECT_NOTIFICATION
        // intent which app_links picks up — ignore them here
        if (_isNotificationIntent(uri)) {
          log(
            'ℹ️ [DeepLinkService] stream URI is a notification intent — '
            'ignoring (handled by PushNotificationController)',
          );
          return;
        }

        _handleUri(uri);
      },
      onError: (e, st) {
        log('❌ [DeepLinkService] stream error: $e');
        log('❌ [DeepLinkService] $st');
      },
    );
    log('✅ [DeepLinkService] uriLinkStream subscribed');
  }

  // ── Guard ─────────────────────────────────────────────────────────────────

  /// Returns true if the URI is a notification tap intent, not a real deep link.
  /// flutter_local_notifications fires SELECT_NOTIFICATION as the intent action,
  /// which app_links incorrectly surfaces as a URI event.
  ///
  /*
  Cold start tap  →  captureInitialLink()  →  _isNotificationIntent() → return (ignored)
Background tap  →  _startListening()     →  _isNotificationIntent() → return (ignored)
                                                  ↓
                                    PushNotificationController handles it instead
 */
  bool _isNotificationIntent(Uri uri) {
    final raw = uri.toString().toLowerCase();

    final isNotification =
        raw.contains('select_notification') ||
        raw == 'select_notification' ||
        uri.scheme == 'select_notification' ||
        raw.contains('com.google.firebase.messaging') ||
        // catch-all: not a wemama:// or https:// link
        (uri.scheme != 'wemama' &&
            uri.scheme != 'https' &&
            uri.scheme != 'http');

    log(
      '🔍 [DeepLinkService] _isNotificationIntent($uri) → $isNotification '
      '| scheme: ${uri.scheme}',
    );

    return isNotification;
  }

  // ── Handler ───────────────────────────────────────────────────────────────

  void _handleUri(Uri uri) {
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    log('🔗 [DeepLinkService] _handleUri() START → $uri');

    final liveId = _extractLiveId(uri);
    log('🔗 [DeepLinkService] _handleUri() → extracted liveId: $liveId');

    if (liveId == null) {
      log('⚠️ [DeepLinkService] _handleUri() → no liveId extracted — ignoring');
      return;
    }

    _openLive(liveId);
    log('🔗 [DeepLinkService] _handleUri() END');
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openLive(String liveId) async {
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    log("🔗 [DeepLinkService] _openLive() START → liveId='$liveId'");
    log(
      "🔗 [DeepLinkService] _openLive() → currentRoute='${Get.currentRoute}'",
    );
    log("🔗 [DeepLinkService] _openLive() → loggedIn='${storage.getLoggedIn}'");

    if (!storage.getLoggedIn) {
      pendingLiveId = liveId;
      log(
        '🔗 [DeepLinkService] _openLive() → user NOT logged in — pendingLiveId stored',
      );

      if (Get.currentRoute == RoutePaths.signin) {
        log(
          '🔗 [DeepLinkService] _openLive() → already on signin — skipping navigation',
        );
        return;
      }

      log(
        '🔗 [DeepLinkService] _openLive() → navigating to signin with redirectLiveId',
      );
      Get.offAllNamed(RoutePaths.signin, arguments: {'redirectLiveId': liveId});
      return;
    }

    log(
      '🔗 [DeepLinkService] _openLive() → user IS logged in — navigating to session',
    );
    await navigateToSession(liveId);

    log("🔗 [DeepLinkService] _openLive() END");
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── URI parsing ───────────────────────────────────────────────────────────

  String? _extractLiveId(Uri uri) {
    log('🔍 [DeepLinkService] _extractLiveId() START');
    log('├─ URI:            $uri');
    log('├─ Scheme:         ${uri.scheme}');
    log('├─ Host:           ${uri.host}');
    log('├─ Path:           ${uri.path}');
    log('├─ Path Segments:  ${uri.pathSegments}');
    log('├─ Query Params:   ${uri.queryParameters}');

    if (uri.scheme == 'wemama') {
      final liveId = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.first
          : null;
      log('📱 [DeepLinkService] custom scheme (wemama) → liveId: $liveId');
      return liveId;
    }

    if (uri.scheme == 'https' || uri.scheme == 'http') {
      final index = uri.pathSegments.indexOf('session');
      log('🌐 [DeepLinkService] https scheme → session index: $index');

      if (index != -1 && uri.pathSegments.length > index + 1) {
        final liveId = uri.pathSegments[index + 1];
        log('🎯 [DeepLinkService] extracted liveId: $liveId');
        return liveId;
      }

      log('⚠️ [DeepLinkService] no liveId found after "session" segment');
      return null;
    }

    log(
      '⚠️ [DeepLinkService] unsupported scheme: ${uri.scheme} — returning null',
    );
    return null;
  }

  // ── Post-login redirect ───────────────────────────────────────────────────

  Future<void> handlePostLoginRedirect() async {
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    log('🔄 [DeepLinkService] handlePostLoginRedirect() START');

    if (pendingLiveId == null) {
      log('ℹ️ [DeepLinkService] no pendingLiveId — skipping redirect');
      return;
    }

    final liveId = pendingLiveId!;
    log('🎯 [DeepLinkService] pendingLiveId: $liveId');

    pendingLiveId = null;
    log('🧹 [DeepLinkService] pendingLiveId cleared');

    try {
      log('🚀 [DeepLinkService] navigating to session: $liveId');
      await navigateToSession(liveId);
      log('✅ [DeepLinkService] navigated to session: $liveId');
    } catch (e, st) {
      log('❌ [DeepLinkService] handlePostLoginRedirect() error: $e');
      log('❌ [DeepLinkService] $st');
    }

    log('🔄 [DeepLinkService] handlePostLoginRedirect() END');
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── Session navigation ────────────────────────────────────────────────────

  Future<void> navigateToSession(String liveId) async {
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    log("🔗 [DeepLinkService] navigateToSession() START → liveId='$liveId'");

    try {
      log(
        "🔗 [DeepLinkService] → calling SessionService().getSessionById('$liveId')...",
      );
      final Session? session = await SessionService().getSessionById(
        sessionId: liveId,
      );

      log(
        "🔗 [DeepLinkService] → API returned. session = "
        "${session == null ? '[NULL]' : 'id=${session.id} status=${session.status}'}",
      );

      if (session == null || session.id.isEmpty) {
        log(
          '🔗 [DeepLinkService] → session null or empty — navigating to mainNav',
        );
        Get.offAllNamed(RoutePaths.mainNav);
        return;
      }

      log("🔗 [DeepLinkService] → session.status = '${session.status}'");

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
          await Get.offAllNamed(RoutePaths.mainNav);
          await Future.microtask(() => null);
          log('🔗 [DeepLinkService] → calling MainNavController.to.goToTab(4)');
          MainNavController.to.goToTab(4);
          break;

        default:
          log(
            "🔗 [DeepLinkService] → unhandled status '${session.status}' → mainNav",
          );
          Get.offAllNamed(RoutePaths.mainNav);
      }
    } catch (e, st) {
      log('❌ [DeepLinkService] navigateToSession() ERROR: $e');
      log('❌ [DeepLinkService] STACK: $st');
      Get.offAllNamed(RoutePaths.mainNav);
    }

    log('🔗 [DeepLinkService] navigateToSession() END');
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────

  @override
  void onClose() {
    log('🔧 [DeepLinkService] onClose() — cancelling stream subscription');
    _subscription?.cancel();
    super.onClose();
  }
}
