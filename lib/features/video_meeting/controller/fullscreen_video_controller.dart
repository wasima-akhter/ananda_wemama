// features/meeting/controller/fullscreen_video_controller.dart

import 'package:flutter/services.dart';

import '../../../app/controller_export.dart';

class FullscreenVideoController extends GetxController {
  final RxBool isFullscreen = false.obs;

  Future<void> enterFullscreen() async {
    if (isFullscreen.value) return;
    isFullscreen.value = true;

    // Allow landscape, then force it
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Hide system UI for true immersive video
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> exitFullscreen() async {
    if (!isFullscreen.value) return;
    isFullscreen.value = false;

    // Restore portrait lock
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Restore system UI
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void onClose() {
    // Safety net — never leave the app stuck in landscape if controller dies
    if (isFullscreen.value) {
      exitFullscreen();
    }
    super.onClose();
  }
}
