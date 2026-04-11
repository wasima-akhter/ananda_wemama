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
                  return Container(
                    width: double.infinity,
                    height: S.h * 0.26,
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (mc.remoteUids.isEmpty) {
                  return Container(
                    width: double.infinity,
                    height: S.h * 0.26,
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        "Live starting soon...",
                        style: TxtStyle.inter(fs: 14, color: Colors.white70),
                      ),
                    ),
                  );
                }

                // ✅ Show the host's video (first remote uid = the host/doctor)
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: mc.agoraEngine!,
                    canvas: VideoCanvas(uid: mc.remoteUids.first),
                    connection: RtcConnection(channelId: mc.channelName.value),
                  ),
                );
              }),
              Positioned(
                right: 12,
                top: 12,
                child: ContainerBordered(
                  rad: 30,
                  hp: 10,
                  vp: 6,
                  contClr: white.withOpacity(.9),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: c.secondary),
                      Gap(6),
                      Text("520", style: TxtStyle.inter(fs: 13, w: 600)),
                    ],
                  ),
                ),
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
}
