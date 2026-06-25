import '../../../../app/controller_export.dart';
import '../../../../core/local/app_storage.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/services/deep_link/app_link_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find<SplashController>();

  Future<void> splashScreenFunctions() async {
    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    log("🚀 [SPLASH] splashScreenFunctions() START");
    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // ─── STEP 1: Network check ───────────────────────────────────────
    log("📡 [SPLASH] STEP 1 → Checking network...");
    final hasNetwork = await NetworkManager().checkConnection();
    log("📡 [SPLASH] STEP 1 → hasNetwork = $hasNetwork");

    if (!hasNetwork) {
      log(
        "❌ [SPLASH] STEP 1 → No internet. Current route: ${Get.currentRoute}",
      );
      if (Get.currentRoute != RoutePaths.offlineScreen) {
        log("❌ [SPLASH] STEP 1 → Navigating to offlineScreen");
        Get.toNamed(RoutePaths.offlineScreen);
      } else {
        log(
          "❌ [SPLASH] STEP 1 → Already on offlineScreen. Skipping navigation.",
        );
      }
      log("❌ [SPLASH] STEP 1 → Returning early due to no network.");
      return;
    }

    // ─── STEP 2: Delay ──────────────────────────────────────────────
    log("⏳ [SPLASH] STEP 2 → Has internet. Starting 2s delay...");
    await Future.delayed(const Duration(seconds: 2));
    log("⏳ [SPLASH] STEP 2 → Delay complete.");

    // ─── STEP 3: Read storage state ─────────────────────────────────
    log("💾 [SPLASH] STEP 3 → Reading storage state...");
    final seenOnboarding = AppStorage.to.getSeenOnboarding;
    final loggedIn = AppStorage.to.getLoggedIn;
    final token = AppStorage.to.getToken;
    log("💾 [SPLASH] STEP 3 → seenOnboarding : $seenOnboarding");
    log("💾 [SPLASH] STEP 3 → loggedIn       : $loggedIn");
    log(
      "💾 [SPLASH] STEP 3 → token           : ${token.isEmpty ? '[EMPTY]' : '[PRESENT] ${token.substring(0, token.length.clamp(0, 20))}...'}",
    );

    // ─── STEP 4: DeepLinkService lookup ─────────────────────────────
    log("🔗 [SPLASH] STEP 4 → Looking up DeepLinkService...");
    DeepLinkService deepLinkService;
    try {
      deepLinkService = Get.find<DeepLinkService>();
      log("🔗 [SPLASH] STEP 4 → DeepLinkService found ✅");
    } catch (e) {
      log("🔗 [SPLASH] STEP 4 → ❌ DeepLinkService NOT found in GetX: $e");
      log("🔗 [SPLASH] STEP 4 → Falling through to normal nav flow.");
      _navigateNormally(seenOnboarding, loggedIn);
      return;
    }

    final pendingLiveId = deepLinkService.pendingLiveId;
    log(
      "🔗 [SPLASH] STEP 4 → pendingLiveId = ${pendingLiveId ?? '[NULL — no deep link]'}",
    );

    // ─── STEP 5: Mark app ready ──────────────────────────────────────
    log("✅ [SPLASH] STEP 5 → Calling deepLinkService.markAppReady()...");
    deepLinkService.markAppReady();
    log("✅ [SPLASH] STEP 5 → markAppReady() done. Stream is now active.");

    // ─── STEP 6: Deep link branch ────────────────────────────────────
    if (pendingLiveId != null) {
      deepLinkService.pendingLiveId = null;

      if (!loggedIn) {
        deepLinkService.pendingLiveId = pendingLiveId;
        Get.offAllNamed(
          RoutePaths.signin,
          arguments: {'redirectLiveId': pendingLiveId},
        );
      } else {
        await deepLinkService.navigateToSession(pendingLiveId);
      }

      // ✅ Mark ready AFTER navigation is done
      log("✅ [SPLASH] → Calling markAppReady() after deep link navigation.");
      deepLinkService.markAppReady();
      return;
    }

    // ─── STEP 7: Normal navigation flow ────────────────────────────
    log(
      "🧭 [SPLASH] STEP 7 → No deep link. Entering normal navigation flow...",
    );
    _navigateNormally(seenOnboarding, loggedIn);

    // ✅ Mark ready AFTER normal navigation is done
    log("✅ [SPLASH] → Calling markAppReady() after normal navigation.");
    deepLinkService.markAppReady();
    log("✅ [SPLASH] → Stream is now active. Route is stable.");

    // ─── STEP 7: Normal navigation flow ─────────────────────────────
    log(
      "🧭 [SPLASH] STEP 7 → No deep link. Entering normal navigation flow...",
    );
    _navigateNormally(seenOnboarding, loggedIn);

    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    log("🏁 [SPLASH] splashScreenFunctions() END");
    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  // SplashController._navigateNormally()

  void _navigateNormally(bool seenOnboarding, bool loggedIn) {
    log(
      "🧭 [SPLASH] _navigateNormally() → seenOnboarding=$seenOnboarding | loggedIn=$loggedIn",
    );

    if (!seenOnboarding) {
      log("🧭 [SPLASH] _navigateNormally() → Navigating to onboardScreen");
      Get.offAllNamed(RoutePaths.onboardScreen);
    } else if (!loggedIn) {
      log("🧭 [SPLASH] _navigateNormally() → Navigating to signin");
      Get.offAllNamed(RoutePaths.signin);
    } else {
      log("🧭 [SPLASH] _navigateNormally() → Navigating to mainNav");
      Get.offAllNamed(RoutePaths.mainNav);
    }

    log(
      "🧭 [SPLASH] _navigateNormally() → Current route after nav: ${Get.currentRoute}",
    );
  }
}
