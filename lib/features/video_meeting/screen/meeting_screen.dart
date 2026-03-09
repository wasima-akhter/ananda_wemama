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

import '../../../core/helpers/widgets_helper.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenTemplate(
      isScrollable: false,
      backgroundColor: black,
      appBar: CommonAppBarContent(title: Strings.live, isBgTransp: true),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TopComponent(text: "24:01:45", iconPath: IconsPath.liveDot),
              _TopComponent(text: "520", iconPath: IconsPath.visibilityOn),
              _TopComponent(text: "380", iconPath: IconsPath.likeFilled),
            ],
          ),

          Gap(itemGap * 3),
          Expanded(
            child: Stack(
              children: [
                // ── Remote Users Grid (fake) ──
                // GridView.builder(
                //   itemCount: 4,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                //   itemBuilder: (_, index) {
                //     return Container(
                //       margin: const EdgeInsets.all(4),
                //       decoration: BoxDecoration(
                //         color: Colors.grey.shade400,
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: Stack(
                //         children: [
                //           // fake avatar
                //           Center(
                //             child: CircleAvatar(
                //               radius: 30,
                //               backgroundColor: c.primary.withOpacity(0.3),
                //               child: Icon(Icons.person, size: 36, color: c.primary),
                //             ),
                //           ),
                //           // name tag
                //           Positioned(
                //             bottom: 8,
                //             left: 8,
                //             child: Container(
                //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //               decoration: BoxDecoration(
                //                 color: Colors.black54,
                //                 borderRadius: BorderRadius.circular(8),
                //               ),
                //               child: Text(
                //                 "User ${index + 1}",
                //                 style: TxtStyle.outfit(fs: 11, w: 500, color: white),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),

                // ── Local Video Preview (fake) ──
                Positioned(
                  top: 20,
                  right: 20,
                  width: 100,
                  height: 140,
                  child: Container(
                    decoration: BoxDecoration(
                      color: c.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: white, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: c.primary.withOpacity(0.4),
                          child: Icon(Icons.person, size: 26, color: white),
                        ),
                        Gap(6),
                        Text("You", style: TxtStyle.outfit(fs: 11, w: 500, color: white)),
                      ],
                    ),
                  ),
                ),

                // ── Controls ──
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: ContainerBordered(
                    vp: 20,
                    hp: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Comments ← new
                        _ControlBtn(
                          iconPath: IconsPath.chatCircleOutlined,
                          color: c.primary,
                          onTap: () async => await showLiveCommentsBottomSheet(postId: 0),
                        ),

                        // Camera
                        _ControlBtn(iconPath: IconsPath.handRaise, color: c.primary, onTap: () {}),

                        // Mic
                        _ControlBtn(iconPath: IconsPath.mutedAudio, color: c.primary, onTap: () {}),

                        // End Call
                        _ControlBtn(
                          iconPath: IconsPath.leave,
                          color: c.error,
                          onTap: () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ).getcm,
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final String iconPath;
  final Color? color;
  final Color? bgColor;
  final double size;
  final VoidCallback onTap;

  const _ControlBtn({
    required this.iconPath,
    this.color,
    required this.onTap,
    this.bgColor,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: onTap,
      child: Container(
        decoration: 0.circleBrdr(brdrClr: c.primary),
        child: CircleAvatar(
          radius: size,
          backgroundColor: bgColor ?? Colors.white24,
          child: SvgIconColored(iconPath: iconPath, iconColor: color, height: size * 0.75),
        ),
      ),
    );
  }
}

class _TopComponent extends StatelessWidget {
  final String text;
  final String iconPath;
  const _TopComponent({super.key, required this.text, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: white.withOpacity(0.3),
      rad: 30,
      hp: 12,

      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: white,
            child: SvgIconColored(iconPath: iconPath),
          ),

          Gap(8),

          Text(text, style: TxtStyle.inter(fs: 14, color: white)),
        ],
      ),
    );
  }
}
