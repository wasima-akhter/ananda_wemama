// features/meeting/view/fullscreen_video_page.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../app/helper_widgets_export.dart';
import '../controller/fullscreen_video_controller.dart';
import '../controller/meeting_controller.dart';

class FullscreenVideoPage extends StatefulWidget {
  final MeetingController mc;

  const FullscreenVideoPage({super.key, required this.mc});

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  final fsc = Get.put(FullscreenVideoController());

  @override
  void initState() {
    super.initState();
    fsc.enterFullscreen();
  }

  @override
  void dispose() {
    fsc.exitFullscreen();
    Get.delete<FullscreenVideoController>();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await fsc.exitFullscreen();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final mc = widget.mc;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Video fills entire screen ─────────────────────────
              Obx(() {
                if (!mc.isEngineReady.value ||
                    mc.agoraEngine == null ||
                    mc.remoteUids.isEmpty) {
                  return const Center(child: LoadingPrimary());
                }
                if (!mc.isHostVideoOn.value) {
                  return const Center(
                    child: Text(
                      "Camera off",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: mc.agoraEngine!,
                    canvas: VideoCanvas(uid: mc.hostUid.value!),
                    connection: RtcConnection(channelId: mc.channelName.value),
                  ),
                );
              }),

              // ── Exit button (top-left, safe tap target) ───────────
              Positioned(
                top: 12,
                left: 12,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () async {
                      await fsc.exitFullscreen();
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
