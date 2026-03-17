import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/local/app_storage.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../routes/route_paths.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find<SplashController>();

  Future<void> splashScreenFunctions(BuildContext context) async {
    print("splash controller function called");

    final hasNetwork = await NetworkManager().checkConnection();

    // ❌ No internet → go immediately
    if (!hasNetwork) {
      Get.toNamed(RoutePaths.offlineScreen);
      return;
    }

    // ✅ Has internet → wait 2 seconds
    await Future.delayed(const Duration(seconds: 1));

    print("seenOnboarding: ${AppStorage.to.getSeenOnboarding}");
    print("loggedIn: ${AppStorage.to.getLoggedIn}");
    print("token: ${AppStorage.to.getToken}");

    // Check if user has seen onboarding
    if (AppStorage.to.getSeenOnboarding) {
      // Already seen + signed in → go to Sign In
      if (AppStorage.to.getLoggedIn) {
        Get.offNamed(RoutePaths.mainNav);
      } else {
        // Already seen + not signed in → go to Sign In
        Get.offNamed(RoutePaths.signin);
      }
    } else {
      // Not seen → go to Onboarding
      Get.offNamed(RoutePaths.onboardScreen);
    }
  }
}
