// features/meeting/widgets/shared_agora_video_view.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:we_mama/features/video_meeting/controller/meeting_controller.dart';

import '../../../../app/helper_widgets_export.dart';

class SharedAgoraVideoView extends StatelessWidget {
  final BoxFit fit;

  const SharedAgoraVideoView({super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final mc = MeetingController.to;
    return Obx(() {
      if (!mc.isEngineReady.value || mc.agoraEngine == null) {
        return _buildPlaceholder(child: const LoadingPrimary());
      }
      if (mc.hasLiveEnded.value) {
        return _buildPlaceholder(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.live_tv_outlined,
                color: Colors.white54,
                size: 36,
              ),
              const Gap(10),
              Text(
                "The live has ended\nThanks for joining!",
                style: TxtStyle.inter(fs: 15, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      if (mc.remoteUids.isEmpty) {
        return _buildPlaceholder(
          child: Text(
            "Live starting soon...",
            style: TxtStyle.inter(fs: 14, color: Colors.white70),
          ),
        );
      }
      if (!mc.isHostVideoOn.value) {
        return _buildPlaceholder(child: Text("camera off"));
      }

      // 🔴 REMOVED: if (!mc.hasReceivedFirstHostFrame.value) check
      // This was blocking video render on iOS because onFirstRemoteVideoFrame
      // doesn't fire reliably (or fires with significant delay)
      //
      // ✅ NEW: Render video immediately once:
      // - Engine is ready
      // - Host UID is assigned
      // - setupRemoteVideo() was called in onUserJoined
      //
      // The video renderer will display once frames start arriving.
      // Don't wait for the onFirstRemoteVideoFrame callback on iOS.

      return AgoraVideoView(
        key: ValueKey(
          'video_${mc.hostUid.value}_${mc.isFullscreen.value}_${mc.videoViewGeneration.value}',
        ),
        controller: VideoViewController.remote(
          rtcEngine: mc.agoraEngine!,
          canvas: VideoCanvas(
            uid: mc.hostUid.value!,
            renderMode: RenderModeType.renderModeFit,
          ),
          connection: RtcConnection(channelId: mc.channelName.value),
        ),
      );
    });
  }

  Widget _buildPlaceholder({required Widget child}) {
    return Container(
      color: Colors.black,
      child: Center(child: child),
    );
  }
}
