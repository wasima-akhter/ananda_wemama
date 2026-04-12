import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../app/helper_widgets_export.dart';
import '../../shared/community_spotlight/community_spotlight.dart';
import '../controller/meeting_controller.dart';

class TopContent extends StatelessWidget {
  final MeetingController mc;
  const TopContent({super.key, required this.mc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(50.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Gap(50.w),
            Column(
              children: [
                Text("Breastfeeding Basic", style: TxtStyle.outfit(fs: 16, w: 600)),
                Text("With Dr. Adebayo", style: TxtStyle.outfit(fs: 13, color: c.secondary)),
              ],
            ),
            ContainerBordered(
              rad: 8,
              hp: 16,
              hasBrdr: true,
              brdrClr: c.primary,
              vp: 6,
              contClr: c.error,

              child: Text("LIVE", style: TxtStyle.inter(fs: 12, w: 600, color: white)),
            ),
          ],
        ).get10cm,
        Gap(itemGap * 1.5),
        ContainerBordered(
          rad: 20,
          hp: 0,
          vp: 0,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // In TopContent — replace NetworkImageWidget with the Agora view

              // Where you have NetworkImageWidget, replace it with:
              Obx(() {
                if (!mc.isEngineReady.value || mc.agoraEngine == null) {
                  return _buildPlaceholder(child: const CircularProgressIndicator());
                }

                // ✅ Live has ended
                if (mc.hasLiveEnded.value) {
                  return _buildPlaceholder(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.live_tv_outlined, color: Colors.white54, size: 36),
                        const Gap(10),
                        Text(
                          "The live has ended \nThanks for joining!",
                          style: TxtStyle.inter(fs: 15, color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                // ✅ Live not started yet
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
                  // HostAvatarWidget(); // 👈 your custom UI
                }
                if (!mc.isHostAudioOn.value) {
                  return _buildPlaceholder(child: Text("mic off"));
                  // HostAvatarWidget(); // 👈 your custom UI
                }

                // ✅ Live is active
                return SizedBox(
                  height: S.h * 0.26,
                  width: S.w - 40.w,
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: mc.agoraEngine!,
                      canvas: VideoCanvas(uid: mc.remoteUids.first),
                      connection: RtcConnection(channelId: mc.channelName.value),
                    ),
                  ),
                );
              }),
              Positioned(
                right: 12,
                top: 12,
                child: Row(
                  children: [
                    _buildFloatingIcon(text: "235", icon: Icons.thumb_up_sharp),
                    Gap(itemGap),
                    _buildFloatingIcon(text: "520", icon: Icons.visibility),
                  ],
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: _buildFloatingIcon(text: "02:10:13", icon: Icons.circle),
              ),
            ],
          ),
        ),
        Gap(itemGap * 1.5),
        StackOfImages(numOfImage: 6),
        Gap(itemGap * 1.5),
      ],
    ).get10cm;
  }

  Widget _buildPlaceholder({required Widget child}) {
    return Container(
      width: double.infinity,
      height: S.h * 0.26,
      color: Colors.black,
      child: Center(child: child),
    );
  }

  Widget _buildFloatingIcon({required String text, required IconData icon}) {
    return ContainerBordered(
      rad: 30,
      hp: 10,
      vp: 4,
      contClr: Colors.grey.shade600,
      child: Row(
        children: [
          CircleAvatar(
            radius: 9.r,
            backgroundColor: white,
            child: Icon(icon, size: 12.h, color: c.secondary),
          ),
          Gap(6),
          Text(text, style: TxtStyle.inter(fs: 12, w: 600, color: white)),
        ],
      ),
    );
  }
}
