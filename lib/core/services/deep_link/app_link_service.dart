import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';
import '../../../routes/route_paths.dart';
import '../../network/helpers/network_helpers.dart';
import '../auth/verification_gate.dart';
import '../session/session_service.dart';
import 'session_navigator.dart';

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  String? pendingLiveId;
  bool _appReady = false;

  // ── Cold start ────────────────────────────────────────────────────────────

  Future<void> captureInitialLink() async {
    print('🔧 [DeepLinkService] captureInitialLink() START');
    try {
      final initialUri = await _appLinks.getInitialLink();
      print('🔗 [DeepLinkService] raw initial URI: $initialUri');

      if (initialUri == null) {
        print('ℹ️ [DeepLinkService] no initial link — skipping');
        return;
      }

      // ✅ Notification intents arrive here on cold-start tap — ignore them
      if (_isNotificationIntent(initialUri)) {
        print(
          'ℹ️ [DeepLinkService] initial URI is a notification intent — '
          'ignoring (handled by PushNotificationController)',
        );
        return;
      }

      // Store only — zero navigation here
      pendingLiveId = _extractLiveId(initialUri);
      print(
        '🔗 [DeepLinkService] captureInitialLink() → pendingLiveId: $pendingLiveId',
      );
    } catch (e, st) {
      print('❌ [DeepLinkService] captureInitialLink() error: $e');
      print('❌ [DeepLinkService] $st');
    }
    print('🔧 [DeepLinkService] captureInitialLink() END');
  }

  // ── App ready (called by SplashController after navigation settles) ───────

  void markAppReady() {
    if (_appReady) {
      print(
        'ℹ️ [DeepLinkService] markAppReady() called but already ready — skipping',
      );
      return;
    }
    _appReady = true;
    print('✅ [DeepLinkService] markAppReady() → stream starting now');
    _startListening();
  }

  void _startListening() {
    print(
      '🔧 [DeepLinkService] _startListening() — subscribing to uriLinkStream',
    );
    _subscription = _appLinks.uriLinkStream.listen(
      (uri) {
        print('🔗 [DeepLinkService] stream event → raw URI: $uri');

        // ✅ Notification taps (background/foreground) fire SELECT_NOTIFICATION
        // intent which app_links picks up — ignore them here
        if (_isNotificationIntent(uri)) {
          print(
            'ℹ️ [DeepLinkService] stream URI is a notification intent — '
            'ignoring (handled by PushNotificationController)',
          );
          return;
        }

        _handleUri(uri);
      },
      onError: (e, st) {
        print('❌ [DeepLinkService] stream error: $e');
        print('❌ [DeepLinkService] $st');
      },
    );
    print('✅ [DeepLinkService] uriLinkStream subscribed');
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

    print(
      '🔍 [DeepLinkService] _isNotificationIntent($uri) → $isNotification '
      '| scheme: ${uri.scheme}',
    );

    return isNotification;
  }

  // ── Handler ───────────────────────────────────────────────────────────────

  void _handleUri(Uri uri) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔗 [DeepLinkService] _handleUri() START → $uri');

    //
    if (uri.host == 'verification') return;
    final liveId = _extractLiveId(uri);
    print('🔗 [DeepLinkService] _handleUri() → extracted liveId: $liveId');

    if (liveId == null) {
      print(
        '⚠️ [DeepLinkService] _handleUri() → no liveId extracted — ignoring',
      );
      return;
    }

    _openLive(liveId);
    print('🔗 [DeepLinkService] _handleUri() END');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openLive(String liveId) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print("🔗 [DeepLinkService] _openLive() START → liveId='$liveId'");
    print(
      "🔗 [DeepLinkService] _openLive() → currentRoute='${Get.currentRoute}'",
    );
    print(
      "🔗 [DeepLinkService] _openLive() → loggedIn='${storage.getLoggedIn}'",
    );

    if (!storage.getLoggedIn) {
      pendingLiveId = liveId;
      print(
        '🔗 [DeepLinkService] _openLive() → user NOT logged in — pendingLiveId stored',
      );

      if (Get.currentRoute == RoutePaths.signin) {
        print(
          '🔗 [DeepLinkService] _openLive() → already on signin — skipping navigation',
        );
        return;
      }

      print(
        '🔗 [DeepLinkService] _openLive() → navigating to signin with redirectLiveId',
      );
      Get.offAllNamed(RoutePaths.signin, arguments: {'redirectLiveId': liveId});
      return;
    }

    //
    if (!await VerificationGate.ensureVerified()) {
      pendingLiveId = liveId; // opened after approval via goHome()
      return;
    }
    //
    print(
      '🔗 [DeepLinkService] _openLive() → user IS logged in — navigating to session',
    );
    await navigateToSession(liveId);

    print("🔗 [DeepLinkService] _openLive() END");
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── URI parsing ───────────────────────────────────────────────────────────

  String? _extractLiveId(Uri uri) {
    print('🔍 [DeepLinkService] _extractLiveId() START');
    print('├─ URI:            $uri');
    print('├─ Scheme:         ${uri.scheme}');
    print('├─ Host:           ${uri.host}');
    print('├─ Path:           ${uri.path}');
    print('├─ Path Segments:  ${uri.pathSegments}');
    print('├─ Query Params:   ${uri.queryParameters}');

    if (uri.scheme == 'wemama') {
      final liveId = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.first
          : null;
      print('📱 [DeepLinkService] custom scheme (wemama) → liveId: $liveId');
      return liveId;
    }

    if (uri.scheme == 'https' || uri.scheme == 'http') {
      final index = uri.pathSegments.indexOf('session');
      print('🌐 [DeepLinkService] https scheme → session index: $index');

      if (index != -1 && uri.pathSegments.length > index + 1) {
        final liveId = uri.pathSegments[index + 1];
        print('🎯 [DeepLinkService] extracted liveId: $liveId');
        return liveId;
      }

      print('⚠️ [DeepLinkService] no liveId found after "session" segment');
      return null;
    }

    print(
      '⚠️ [DeepLinkService] unsupported scheme: ${uri.scheme} — returning null',
    );
    return null;
  }

  // ── Post-login redirect ───────────────────────────────────────────────────

  Future<void> handlePostLoginRedirect() async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔄 [DeepLinkService] handlePostLoginRedirect() START');

    if (pendingLiveId == null) {
      print('ℹ️ [DeepLinkService] no pendingLiveId — skipping redirect');
      return;
    }

    final liveId = pendingLiveId!;
    print('🎯 [DeepLinkService] pendingLiveId: $liveId');

    pendingLiveId = null;
    print('🧹 [DeepLinkService] pendingLiveId cleared');

    try {
      print('🚀 [DeepLinkService] navigating to session: $liveId');
      await navigateToSession(liveId);
      print('✅ [DeepLinkService] navigated to session: $liveId');
    } catch (e, st) {
      print('❌ [DeepLinkService] handlePostLoginRedirect() error: $e');
      print('❌ [DeepLinkService] $st');
    }

    print('🔄 [DeepLinkService] handlePostLoginRedirect() END');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── Session navigation ────────────────────────────────────────────────────

  Future<void> navigateToSession(String liveId) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print("🔗 [DeepLinkService] navigateToSession() START → liveId='$liveId'");

    try {
      print(
        "🔗 [DeepLinkService] → calling SessionService().getSessionById('$liveId')...",
      );
      final Session? session = await SessionService().getSessionById(
        sessionId: liveId,
      );

      print(
        "🔗 [DeepLinkService] → API returned. session = "
        "${session == null ? '[NULL]' : 'id=${session.id} status=${session.status}'}",
      );

      if (session == null || session.id.isEmpty) {
        print(
          '🔗 [DeepLinkService] → session null or empty — navigating to mainNav',
        );
        Get.offAllNamed(RoutePaths.mainNav);
        return;
      }
      await SessionNavigator.open(session);

      print("🔗 [DeepLinkService] → session.status = '${session.status}'");
    } catch (e, st) {
      print('❌ [DeepLinkService] navigateToSession() ERROR: $e');
      print('❌ [DeepLinkService] STACK: $st');
      Get.offAllNamed(RoutePaths.mainNav);
    }

    print('🔗 [DeepLinkService] navigateToSession() END');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────

  @override
  void onClose() {
    print('🔧 [DeepLinkService] onClose() — cancelling stream subscription');
    _subscription?.cancel();
    super.onClose();
  }
}
