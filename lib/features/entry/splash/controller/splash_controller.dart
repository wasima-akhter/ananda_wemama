import '../../../../app/controller_export.dart';
import '../../../../core/local/app_storage.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/services/socket/socket_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find<SplashController>();
  final socketService = Get.find<SocketService>();
  @override
  // void onInit() {
  //   ever(socketService.status, (status) {
  //     if (status == SocketStatus.failed) {
  //       Get.snackbar(
  //         "Connection issue",
  //         "Live updates are currently unavailable. Trying again in background.",
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //     }
  //   });
  //   super.onInit();
  // }
  Future<void> splashScreenFunctions(BuildContext context) async {
    log("splash controller function called");

    final hasNetwork = await NetworkManager().checkConnection();

    // ❌ No internet → go immediately
    if (!hasNetwork) {
      Get.toNamed(RoutePaths.offlineScreen);
      return;
    }

    // ✅ Has internet → wait 2 seconds
    await Future.delayed(const Duration(seconds: 1));

    log("seenOnboarding: ${AppStorage.to.getSeenOnboarding}");
    log("loggedIn: ${AppStorage.to.getLoggedIn}");
    log("token: ${AppStorage.to.getToken}");

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
