import '../../../../app/controller_export.dart';
import '../../../../core/local/app_storage.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/services/auth/verification_gate.dart';
import '../../../../core/services/deep_link/app_link_service.dart';
import '../../../../core/services/push_notification/push_notification_service.dart';
import '../../../shared/subscription/subscription_upgrade/service/purchase_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find<SplashController>();

  Future<void> splashScreenFunctions() async {
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    print("🚀 [SPLASH] splashScreenFunctions() START");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // ─── STEP 1: Network check ───────────────────────────────────────
    print("📡 [SPLASH] STEP 1 → Checking network...");
    final hasNetwork = await NetworkManager().checkConnection();
    print("📡 [SPLASH] STEP 1 → hasNetwork = $hasNetwork");

    if (!hasNetwork) {
      print(
        "❌ [SPLASH] STEP 1 → No internet. Current route: ${Get.currentRoute}",
      );
      if (Get.currentRoute != RoutePaths.offlineScreen) {
        print("❌ [SPLASH] STEP 1 → Navigating to offlineScreen");
        Get.toNamed(RoutePaths.offlineScreen);
      } else {
        print(
          "❌ [SPLASH] STEP 1 → Already on offlineScreen. Skipping navigation.",
        );
      }
      print("❌ [SPLASH] STEP 1 → Returning early due to no network.");
      return;
    }

    // ─── STEP 2: Delay ──────────────────────────────────────────────
    print("⏳ [SPLASH] STEP 2 → Has internet. Starting 2s delay...");
    await Future.delayed(const Duration(seconds: 2));
    print("⏳ [SPLASH] STEP 2 → Delay complete.");

    // ─── STEP 3: Read storage state ─────────────────────────────────
    print("💾 [SPLASH] STEP 3 → Reading storage state...");
    final seenOnboarding = AppStorage.to.getSeenOnboarding;
    final loggedIn = AppStorage.to.getLoggedIn;
    final token = AppStorage.to.getToken;
    print("💾 [SPLASH] STEP 3 → seenOnboarding : $seenOnboarding");
    print("💾 [SPLASH] STEP 3 → loggedIn       : $loggedIn");
    print(
      "💾 [SPLASH] STEP 3 → token           : ${token.isEmpty ? '[EMPTY]' : '[PRESENT] ${token.substring(0, token.length.clamp(0, 20))}...'}",
    );

    // ─── STEP 4: DeepLinkService lookup ─────────────────────────────
    print("🔗 [SPLASH] STEP 4 → Looking up DeepLinkService...");
    DeepLinkService deepLinkService;
    try {
      deepLinkService = Get.find<DeepLinkService>();
      print("🔗 [SPLASH] STEP 4 → DeepLinkService found ✅");
    } catch (e) {
      print("🔗 [SPLASH] STEP 4 → ❌ DeepLinkService NOT found in GetX: $e");
      print("🔗 [SPLASH] STEP 4 → Falling through to normal nav flow.");
      await _navigateNormally(seenOnboarding, loggedIn);
      return;
    }

    final pendingLiveId = deepLinkService.pendingLiveId;
    print(
      "🔗 [SPLASH] STEP 4 → pendingLiveId = ${pendingLiveId ?? '[NULL — no deep link]'}",
    );

    // ─── STEP 5: Deep link branch ────────────────────────────────────
    // markAppReady() is called ONCE, at the end of each branch, never before.
    if (pendingLiveId != null) {
      print("🔗 [SPLASH] STEP 5 → Deep link detected. Handling...");
      deepLinkService.pendingLiveId = null;

      if (!loggedIn) {
        print(
          "🔗 [SPLASH] STEP 5 → Not logged in. Storing pendingLiveId and going to signin.",
        );
        deepLinkService.pendingLiveId = pendingLiveId;
        Get.offAllNamed(
          RoutePaths.signin,
          arguments: {'redirectLiveId': pendingLiveId},
        );
      }

      // else {
      //   print(
      //     "🔗 [SPLASH] STEP 5 → Logged in. Navigating to session: $pendingLiveId",
      //   );
      //   await deepLinkService.navigateToSession(pendingLiveId);
      // }

      print("🔗 [SPLASH] STEP 5 → Logged in. Gate, then open session.");
      // keep pendingLiveId: goHome() opens it once verified
      deepLinkService.pendingLiveId = pendingLiveId;
      await VerificationGate.routeAfterAuth();

      // ✅ markAppReady() called ONCE — after navigation is fully done
      print("✅ [SPLASH] STEP 5 → Navigation done. Calling markAppReady().");
      deepLinkService.markAppReady();
      print("✅ [SPLASH] STEP 5 → Stream is now active.");

      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("🏁 [SPLASH] splashScreenFunctions() END (deep link path)");
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      return;
    }

    // ─── STEP 6: Normal navigation flow ─────────────────────────────
    print(
      "🧭 [SPLASH] STEP 6 → No deep link. Entering normal navigation flow...",
    );
    await _navigateNormally(seenOnboarding, loggedIn);

    if (loggedIn) {
      await _maybeUploadFcmToken(); // ✅ added — already-logged-in path
      await _maybeLoginRevenueCat(); // NEW
    }

    // ✅ markAppReady() called ONCE — after navigation is fully done
    print("✅ [SPLASH] STEP 6 → Navigation done. Calling markAppReady().");
    deepLinkService.markAppReady();
    print("✅ [SPLASH] STEP 6 → Stream is now active. Route is stable.");

    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    print("🏁 [SPLASH] splashScreenFunctions() END (normal path)");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  Future<void> _navigateNormally(bool seenOnboarding, bool loggedIn) async {
    print(
      "🧭 [SPLASH] _navigateNormally() → seenOnboarding=$seenOnboarding | loggedIn=$loggedIn",
    );

    if (!seenOnboarding) {
      print("🧭 [SPLASH] _navigateNormally() → Navigating to onboardScreen");
      Get.offAllNamed(RoutePaths.onboardScreen);
    } else if (!loggedIn) {
      print("🧭 [SPLASH] _navigateNormally() → Navigating to signin");
      Get.offAllNamed(RoutePaths.signin);
    } else {
      print("🧭 [SPLASH] _navigateNormally() → gate → mainNav");
      await VerificationGate.routeAfterAuth();
    }

    // else {
    //   print("🧭 [SPLASH] _navigateNormally() → Navigating to mainNav");
    //   Get.offAllNamed(RoutePaths.mainNav);
    // }

    print(
      "🧭 [SPLASH] _navigateNormally() → Current route after nav: ${Get.currentRoute}",
    );
  }

  //
  Future<void> _maybeUploadFcmToken() async {
    if (Get.isRegistered<PushNotificationService>()) {
      print("🔧 [SPLASH] Uploading FCM token for already-logged-in user...");
      await PushNotificationService.to.uploadTokenAfterLogin();
    } else {
      print(
        "⚠️ [SPLASH] PushNotificationService not registered — skipping FCM upload",
      );
    }
  }

  Future<void> _maybeLoginRevenueCat() async {
    final userId = AppStorage.to.getUserId;
    if (userId.isEmpty) return;
    if (Get.isRegistered<PurchaseService>()) {
      print("🔧 [SPLASH] Logging in RevenueCat user: $userId");
      await PurchaseService.to.loginRevenueCatUser(userId);
    } else {
      print("⚠️ [SPLASH] PurchaseService not registered — skipping RC login");
    }
  }
}
