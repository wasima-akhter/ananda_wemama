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
                  if (!mc.isHostAudioOn.value) {
                    return _buildPlaceholder(child: Text("mic off"));
                  }

                  // ✅ No SizedBox wrapper — StackFit.expand handles sizing
                  return AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: mc.agoraEngine!,
                      canvas: VideoCanvas(uid: mc.remoteUids.first),
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

        /*
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
                    onAgoraVideoViewCreated: (viewId) {
                      debugPrint("Video view created: $viewId");
                    },
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
                    Obx(
                      () => _buildFloatingIcon(
                        text: "${cc.reactionCount.value}",
                        icon: Icons.thumb_up_sharp,
                      ),
                    ),

                    Gap(itemGap),

                    // View count
                    Obx(
                      () =>
                          _buildFloatingIcon(text: "${cc.viewCount.value}", icon: Icons.visibility),
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

        */
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
          Text(
            text,
            style: TxtStyle.inter(
              fs: 12,
              w: 600,
              color: white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveStackOfImages extends StatelessWidget {
  final RxList<ParticipantModel> participants;
  const LiveStackOfImages({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    const double radius = 15;
    const double overlap = 25;

    final listLength = participants.length < 10
        ? participants.length
        : participants.take(10).length;

    return SizedBox(
      width: (radius * 2) + (overlap * 2), // total visual width
      height: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: List.generate(listLength, (index) {
          String? path = participants[index].avatar ?? '';
          return Positioned(
            left: index * overlap,
            child: _buildImage(radius: radius, path: path),
          );
        }),
      ),
    );
  }

  Widget _buildImage({String? path, double? radius}) {
    return circledNetworkImageBgComponent(radius: radius, imagePath: path);
  }
}
