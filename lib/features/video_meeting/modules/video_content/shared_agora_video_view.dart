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

      // ------------------------------------------------------------
      // HOST HAS NOT JOINED
      // ------------------------------------------------------------
      if (mc.hostUid.value == null) {
        return _buildPlaceholder(
          child: Text(
            "Live starting soon...",
            style: TxtStyle.inter(fs: 14, color: Colors.white70),
          ),
        );
      }

      // ------------------------------------------------------------
      // HOST JOINED BUT VIDEO IS OFF
      // ------------------------------------------------------------

      if (mc.isHostVideoOn.value == VideoStatus.loading) {
        return _buildPlaceholder(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.grey.shade300,
                ),
              ),
              const Gap(10),
              Text(
                "Connecting video...",
                style: TxtStyle.inter(fs: 15, color: Colors.white70),
              ),
            ],
          ),
        );
      } else if (mc.isHostVideoOn.value == VideoStatus.frozen) {
        return _buildPlaceholder(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white54,
                ),
              ),
              const Gap(10),
              Text(
                "Buffering...",
                style: TxtStyle.inter(fs: 15, color: Colors.white70),
              ),
            ],
          ),
        );
      } else if (mc.isHostVideoOn.value == VideoStatus.off) {
        return _buildPlaceholder(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.videocam_off_outlined,
                color: Colors.white54,
                size: 40,
              ),
              const Gap(10),
              Text(
                "Camera is off",
                style: TxtStyle.inter(fs: 15, color: Colors.white70),
              ),
            ],
          ),
        );
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

      // return AgoraVideoView(
      //   key: ValueKey(
      //     'video_${mc.hostUid.value}_${mc.isFullscreen.value}_${mc.videoViewGeneration.value}',
      //   ),
      //   controller: VideoViewController.remote(
      //     rtcEngine: mc.agoraEngine!,
      //     canvas: VideoCanvas(
      //       uid: mc.hostUid.value!,
      //       renderMode: RenderModeType.renderModeFit,
      //     ),
      //     connection: RtcConnection(channelId: mc.channelName.value),
      //   ),
      // );

      return Stack(
        fit: StackFit.expand,
        children: [
          // Always keep a safe black background
          Container(
            color: Colors.black,
            child: _buildPlaceholder(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white54,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    "Loading...",
                    style: TxtStyle.inter(fs: 15, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Agora video layer
          AgoraVideoView(
            key: ValueKey(
              'video_${mc.hostUid.value}_${mc.isFullscreen.value}_${mc.videoViewGeneration.value}',
            ),
            controller: VideoViewController.remote(
              rtcEngine: mc.agoraEngine!,
              canvas: VideoCanvas(
                uid: mc.hostUid.value!,
                renderMode: RenderModeType.renderModeFit,
                sourceType: VideoSourceType.videoSourceRemote,
                setupMode: VideoViewSetupMode.videoViewSetupAdd,
              ),
              connection: RtcConnection(channelId: mc.channelName.value),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPlaceholder({required Widget child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      alignment: Alignment.center,
      child: child,
    );
  }
}
