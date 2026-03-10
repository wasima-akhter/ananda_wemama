/*
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

import '../controller/meeting_controller.dart';



class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MeetingController>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.live,

        // suffix: IconButton(
        //   icon: const Icon(Icons.link),
        //   tooltip: "Copy Meeting Link",
        //   onPressed: () {
        //     final link = mc.generateMeetingLink();
        //     Clipboard.setData(ClipboardData(text: link));
        //     Get.snackbar(
        //       "Meeting Link",
        //       "Copied to clipboard!",
        //       snackPosition: SnackPosition.BOTTOM,
        //       backgroundColor: Colors.black87,
        //       colorText: Colors.white,
        //     );
        //   },
        // ).mR(30),
      ),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (!mc.isEngineReady.value || mc.agoraEngine == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Stack(
                children: [
                  // Remote Users Grid
                  mc.remoteUids.isEmpty
                      ? const Center(
                          child: Text(
                            "Waiting for participants...",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : GridView.builder(
                          itemCount: mc.remoteUids.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (_, index) {
                            final uid = mc.remoteUids[index];
                            return Container(
                              margin: const EdgeInsets.all(4),
                              color: Colors.black54,
                              child: AgoraVideoView(
                                controller: VideoViewController.remote(
                                  rtcEngine: mc.agoraEngine!,
                                  canvas: VideoCanvas(uid: uid),
                                  connection: RtcConnection(channelId: mc.channelName),
                                ),
                              ),
                            );
                          },
                        ),

                  // Local Video Preview
                  Positioned(
                    top: 20,
                    right: 20,
                    width: 120,
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: mc.agoraEngine!,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  ),

                  // Controls
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Audio Toggle
                        Obx(
                          () => CircleAvatar(
                            radius: 28,
                            backgroundColor: mc.isLocalAudioMuted.value ? Colors.red : Colors.white,
                            child: IconButton(
                              icon: Icon(
                                mc.isLocalAudioMuted.value ? Icons.mic_off : Icons.mic,
                                color: Colors.black,
                              ),
                              onPressed: mc.toggleAudio,
                            ),
                          ),
                        ),

                        // Leave Call
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.red,
                          child: IconButton(
                            icon: const Icon(Icons.call_end, color: Colors.white),
                            onPressed: () {
                              mc.leaveMeeting();
                              Get.back();
                            },
                          ),
                        ),

                        // Video Toggle
                        Obx(
                          () => CircleAvatar(
                            radius: 28,
                            backgroundColor: mc.isLocalVideoMuted.value ? Colors.red : Colors.white,
                            child: IconButton(
                              icon: Icon(
                                mc.isLocalVideoMuted.value ? Icons.videocam_off : Icons.videocam,
                                color: Colors.black,
                              ),
                              onPressed: mc.toggleVideo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chat Input
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: mc.chatController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black54,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            // final text = mc.chatController.text.trim();
                            // if (text.isNotEmpty) {
                            //   mc.sendMessage(text);
                            //   mc.chatController.clear();
                            // }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/core/common_widgets/common_components/community_spotlight.dart';
import 'package:mama_app/core/helpers/widgets_helper.dart';

import '../../../core/common_widgets/cus_des_type_text_form_field.dart';
import '../../../core/common_widgets/cus_flexible_dropdown.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenTemplate(
      isScrollable: false,
      backgroundColor: c.cardPrimary,

      floatingActionButton:
          /// BOTTOM ACTIONS
          /// BOTTOM ACTIONS
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(8),
              _MsgInputRow().get10cm,
              Gap(itemGap * 1.5),

              // ← hide when keyboard is open
              // if (S.bottomInset == 0)
              Container(
                padding: 20.pa,
                decoration: BoxDeco.decRadiusUpBrderAll(30, brdrClr: ctransp, clr: c.cardPrimary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CusGestureDetector(
                      onTap: () => Get.back(),
                      child: _BottomAction(
                        iconPath: IconsPath.closeWhite,
                        backgroundColor: Colors.red,
                        size: 13,
                        text: "Leave",
                        color: white,
                      ),
                    ),
                    _BottomAction(iconPath: IconsPath.mutedAudio, text: "Mute Audio"),
                    _BottomAction(iconPath: IconsPath.likeHeartFilled, text: "React"),
                    _BottomAction(iconPath: IconsPath.handRaise, text: "Ask Questions"),
                  ],
                ).getcm,
              ),
            ],
          ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(50.h),
          //// title + LIVE badge
          /// LIVE BADGE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gap(50.w),

                  /// TITLE
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

              /// TOP HOST CARD
              ContainerBordered(
                rad: 20,
                hp: 0,
                vp: 0,

                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    NetworkImageWidget(
                      imageUrl: Strings.fakeImageUrl,
                      width: double.infinity,
                      height: S.h * 0.26,
                    ),

                    /// VIEWERS
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

              /// AVATAR LIST
              StackOfImages(numOfImage: 6),
            ],
          ).get10cm,

          Gap(itemGap * 1.5),

          Expanded(
            child: Container(
              color: bgClr,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: itemGap * 1.5),
                      itemCount: 10,
                      separatorBuilder: (_, __) => Gap(14),
                      itemBuilder: (_, index) {
                        return _CommentItem();
                      },
                    ).get10cm,
                  ),

                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MsgInputRow extends StatelessWidget {
  const _MsgInputRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CusDesTypeTextFormField(
            controller: TextEditingController(),
            focusNode: FocusNode(),
            hintText: Strings.typeSomething,
            minLines: 1,
            minHeight: 40,
            bgClr: c.textOnPrimary,
            suffix: CusCircleIconButton(
              radius: 15,
              backgroundColor: c.primary,
              onTap: () async {
                // open picker for image or file
              },
              child: SvgIcon(iconPath: IconsPath.sendLargeWhite, height: 20),
            ).mAll(4),
          ),
        ),
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkImageWidget(imageUrl: Strings.fakeImageUrl, isCircle: true, radius: 18),

        Gap(10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Darrell Steward", style: TxtStyle.outfit(fs: 13, w: 600)),
                  Gap(6),
                  Text("11:16 pm", style: TxtStyle.outfit(fs: 11, color: c.textSecondary)),
                ],
              ),

              Gap(4),

              Text(
                "However Rare Side Effects Observed Among Children Can Be Metabolic Acidosis, Coma, Respiratory Depression",
                style: TxtStyle.outfit(fs: 12),
              ),
            ],
          ),
        ),

        CusFlexibleDropdown(
          items: [
            CusDropdownItem(
              title: Strings.reportContent,
              onTap: () async => await showReportBottomSheet(),
            ),
          ],
          child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
        ),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color? color;
  final double? size;
  final Color? backgroundColor;

  const _BottomAction({
    required this.iconPath,
    required this.text,
    this.color,
    this.backgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: 0.circleBrdr(brdrClr: c.secondary),
          child: CircleAvatar(
            radius: 18.r,
            backgroundColor: (backgroundColor ?? c.scaffoldBackground),

            child: SvgIconColored(
              iconPath: iconPath,

              height: size ?? 22,
              iconColor: color ?? c.primary,
            ),
          ),
        ),
        Gap(6),
        Text(text, style: TxtStyle.inter(fs: 11)),
      ],
    );
  }
}
