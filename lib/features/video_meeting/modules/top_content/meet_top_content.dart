import '../../../../app/helper_widgets_export.dart';
import '../../controller/live_chat_controller.dart';
import '../../controller/meeting_controller.dart';
import '../../model/chat_message_live_model.dart';
import '../../screen/video_overlay.dart';
import '../video_content/shared_agora_video_view.dart';

class TopContent extends StatelessWidget {
  const TopContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = MeetingController.to;
    final cc = LiveChatController.to;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(50.h),

        // Text(mc.initAgora())
        Row(
          children: [
            Gap(50.w),

            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    // color: Colors.amber,
                    width: double.infinity,
                    child: Text(
                      mc.agrModel.sessionTitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TxtStyle.outfit(fs: 16, w: 600),
                    ),
                  ),
                  Text(
                    mc.agrModel.hostName,
                    style: TxtStyle.outfit(fs: 13, color: c.secondary),
                  ),
                ],
              ),
            ),

            Gap(12.w),

            ContainerBordered(
              rad: 8,
              hp: 16,
              hasBrdr: true,
              brdrClr: c.primary,
              vp: 6,
              contClr: c.error,

              child: Text(
                "LIVE",
                style: TxtStyle.inter(fs: 12, w: 600, color: white),
              ),
            ),
          ],
        ),

        Gap(itemGap * 1.5),

        // In TopContent.build(), replace the entire AspectRatio child with:
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ContainerBordered(
            rad: 20,
            hp: 0,
            vp: 0,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ✅ Use the shared video view
                Obx(() {
                  if (mc.hasVideoInitError.value) {
                    return _buildVideoErrorPlaceholder();
                  }
                  return CusGestureDetector(
                    onTap: () => Get.to(
                      () => FullscreenVideoPage(),
                      fullscreenDialog: true,
                      transition: Transition.fadeIn,
                    ),
                    child: SharedAgoraVideoView(fit: BoxFit.cover),
                  );
                }),

                //
                // ✅ Reaction + View counts
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

                // ✅ Live duration
                Positioned(
                  left: 12,
                  top: 12,
                  child: Obx(
                    () => _buildFloatingIcon(
                      text: mc.formattedDuration,
                      icon: Icons.circle,
                    ),
                  ),
                ),

                // Rest of overlays remain exactly the same...
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Obx(
                    () => mc.hasVideoInitError.value
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () => Get.to(
                              () => FullscreenVideoPage(),
                              transition: Transition.fadeIn,
                            ),
                            child: _buildFloatingIcon(
                              text: "",
                              icon: Icons.fullscreen,
                            ),
                          ),
                  ),
                ),
                // ... other overlays unchanged
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

  Widget _buildFloatingIcon({required String text, required IconData icon}) {
    return FittedBox(
      child: ContainerBordered(
        rad: 4,
        hp: 6,
        vp: 3,
        contClr: greyLoc.withValues(alpha: 0.5),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 7.r,
            //   backgroundColor: ctransp,
            //   child: Icon(icon, size: 12.h, color: icon == Icons.circle ? c.secondary : white),
            // ),
            Icon(
              icon,
              size: 12.h,
              color: icon == Icons.circle ? c.secondary : white,
            ),

            if (text.isNotEmpty) ...[
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
          ],
        ),
      ),
    );
  }

  //
  Widget _buildVideoErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: c.bottomSheetBackground,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: c.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.videocam_off_outlined,
                  size: 26.w,
                  color: c.primary,
                ),
              ),
              Gap(12.h),
              Text(
                'Unable to start the live session',
                textAlign: TextAlign.center,
                style: TxtStyle.outfit(fs: 15, w: 600),
              ),
              Gap(6.h),
              Text(
                'Please try again in a moment.',
                textAlign: TextAlign.center,
                style: TxtStyle.outfit(fs: 12, color: c.secondary),
              ),
            ],
          ),
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
              return Positioned(
                left: index * overlap,
                child: _buildCountBubble(remainder, radius),
              );
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
    return circledNetworkImageBgComponent(
      radius: radius,
      imagePath: path,
      isUser: true,
    );
  }
}
