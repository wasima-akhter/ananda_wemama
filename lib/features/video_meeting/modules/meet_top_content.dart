import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../app/helper_widgets_export.dart';
import '../controller/live_chat_controller.dart';
import '../controller/meeting_controller.dart';
import '../model/chat_message_live_model.dart';

class TopContent extends StatelessWidget {
  final MeetingController mc;
  final LiveChatController cc;
  const TopContent({super.key, required this.mc, required this.cc});

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
                Text(mc.agrModel.sessionTitle, style: TxtStyle.outfit(fs: 16, w: 600)),
                Text(mc.agrModel.hostName, style: TxtStyle.outfit(fs: 13, color: c.secondary)),
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

        AspectRatio(
          aspectRatio: 16 / 9, // ← single source of truth for size
          child: ContainerBordered(
            rad: 20,
            hp: 0,
            vp: 0,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand, // ← children fill the stack automatically
              children: [
                Obx(() {
                  if (!mc.isEngineReady.value || mc.agoraEngine == null) {
                    return _buildPlaceholder(child: const CircularProgressIndicator());
                  }
                  if (mc.hasLiveEnded.value) {
                    return _buildPlaceholder(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.live_tv_outlined, color: Colors.white54, size: 36),
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
                  // if (!mc.isHostAudioOn.value) {
                  //   return _buildPlaceholder(child: Text("mic off"));
                  // }

                  // ✅ No SizedBox wrapper — StackFit.expand handles sizing

                  return AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: mc.agoraEngine!,
                      canvas: VideoCanvas(uid: mc.hostUid.value!),

                      connection: RtcConnection(channelId: mc.channelName.value),
                    ),
                  );
                }),

                // Overlays stay exactly the same
                Positioned(
                  right: 12,
                  top: 12,
                  child: Row(
                    children: [
                      Obx(
                        () => _buildFloatingIcon(
                          text: "${cc.reactionCount.value}",
                          icon: Icons.thumb_up_sharp,
                        ),
                      ),
                      Gap(itemGap),
                      Obx(
                        () => _buildFloatingIcon(
                          text: "${cc.viewCount.value}",
                          icon: Icons.visibility,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Obx(
                    () => _buildFloatingIcon(text: mc.formattedDuration, icon: Icons.circle),
                  ),
                ),
              ],
            ),
          ),
        ),

        Gap(itemGap * 1.5),

        // Joiners list (short, max 5 avatars)
        LiveStackOfImages(participants: cc.participants),

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
    return FittedBox(
      child: ContainerBordered(
        rad: 30,
        hp: 6,
        vp: 3,
        contClr: greyLoc.withOpacity(0.5),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 7.r,
            //   backgroundColor: ctransp,
            //   child: Icon(icon, size: 12.h, color: icon == Icons.circle ? c.secondary : white),
            // ),
            Icon(icon, size: 12.h, color: icon == Icons.circle ? c.secondary : white),
            Gap(6.w),
            FittedBox(
              child: Text(
                text,
                style: TxtStyle.inter(
                  fs: 12,
                  w: 600,
                  color: white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveStackOfImages extends StatelessWidget {
  final RxList<ParticipantModel> participants;
  const LiveStackOfImages({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    const double radius = 12;
    const double overlap = 17;
    const int maxVisible = 5; // show 3 avatars + 1 count bubble

    return Obx(() {
      final list = [
        ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
        // ...participants,
      ];
      final total = list.length;

      if (total == 0) return const SizedBox.shrink();

      final visibleCount = total <= maxVisible ? total : maxVisible;
      final remainder = total - visibleCount;
      final itemCount = remainder > 0 ? visibleCount + 1 : visibleCount;

      return SizedBox(
        width: (radius * 2) + (overlap * (itemCount - 1)),
        height: radius * 2,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: List.generate(itemCount, (index) {
            // Last slot → show +N bubble
            if (remainder > 0 && index == itemCount - 1) {
              return Positioned(left: index * overlap, child: _buildCountBubble(remainder, radius));
            }

            final path = list[index].avatar ?? '';
            return Positioned(
              left: index * overlap,
              child: _buildImage(radius: radius, path: path),
            );
          }),
        ),
      );
    });
  }

  Widget _buildCountBubble(int count, double radius) {
    final size = (radius + 1) * 2;

    return CircleAvatar(
      radius: radius + 1,
      backgroundColor: c.primary,
      child: Center(
        child: SizedBox(
          width: size * 0.8, // keep padding inside circle
          height: size * 0.8,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '+${count.formatToK()}',
              maxLines: 1,
              softWrap: false,
              style: TxtStyle.interSemiB(fs: 10, w: 600, color: white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage({String? path, double? radius}) {
    return circledNetworkImageBgComponent(radius: radius, imagePath: path, isUser: true);
  }
}
