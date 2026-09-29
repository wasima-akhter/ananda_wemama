import 'package:get/get.dart';

import '../../../features/verification/model/verification_model.dart';
import '../../../features/verification/service/verification_service.dart';
import '../../../routes/route_paths.dart';
import '../deep_link/app_link_service.dart';

class PostAuthNavigator {
  static Future<void> goHome() async {
    VerificationGate.verified = true; // ← add
    final deepLinkService = Get.find<DeepLinkService>();
    if (deepLinkService.pendingLiveId != null) {
      await deepLinkService.handlePostLoginRedirect();
    } else {
      Get.offAllNamed(RoutePaths.mainNav);
    }
  }
}

class VerificationGate {
  static bool verified = false; // in-memory; resets on app restart / sign-out

  static bool get isRequired => true; // TODO: user vs expert

  /// For flows that end in the app (login, splash, subscription, finish-profile)
  static Future<void> routeAfterAuth() async {
    if (!isRequired || verified) return PostAuthNavigator.goHome();

    final res = await VerificationService().getStatus();
    if (res.isSuccess && res.data?.status == VerificationStatus.approved) {
      return PostAuthNavigator.goHome();
    }
    Get.offAllNamed(RoutePaths.verification);
  }

  /// For flows that open a specific screen (deep link, notification tap)
  static Future<bool> ensureVerified() async {
    if (!isRequired || verified) return true;

    final res = await VerificationService().getStatus();
    if (res.isSuccess && res.data?.status == VerificationStatus.approved) {
      verified = true;
      return true;
    }
    if (Get.currentRoute != RoutePaths.verification) {
      Get.offAllNamed(RoutePaths.verification);
    }
    return false;
  }
}
