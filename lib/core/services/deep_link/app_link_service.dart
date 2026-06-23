import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

import '../../../routes/route_paths.dart';
import '../../network/helpers/network_helpers.dart';

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  Uri? pendingUri;

  Future<void> init() async {
    try {
      final initialUri = await _appLinks.getInitialLink();

      if (initialUri != null) {
        _handleUri(initialUri);
      }

      _subscription = _appLinks.uriLinkStream.listen(
        _handleUri,
        onError: (e) {
          log('Deep link error: $e');
        },
      );
    } catch (e) {
      log('Deep link init error: $e');
    }
  }

  void _handleUri(Uri uri) {
    log('Deep link received: $uri');

    pendingUri = uri;

    _route(uri);
  }

  void _route(Uri uri) {
    if (uri.pathSegments.isEmpty) return;

    if (uri.pathSegments.first == 'live') {
      final liveId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;

      if (liveId == null) return;

      _openLive(liveId);
    }
  }

  Future<void> _openLive(String liveId) async {
    if (!storage.getLoggedIn) {
      Get.offAllNamed(RoutePaths.signin, arguments: {'redirectLiveId': liveId});

      return;
    }

    Get.toNamed(RoutePaths.mainNav);
    // Get.toNamed(RoutePaths.mainNav, arguments: {'liveId': liveId});
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
