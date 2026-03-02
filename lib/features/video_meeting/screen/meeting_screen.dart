import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:mama_app/app/helper_widgets_export.dart';

import '../controller/meeting_controller.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MeetingController>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("We Mama App"),

          actions: [
            IconButton(
              icon: const Icon(Icons.link),
              tooltip: "Copy Meeting Link",
              onPressed: () {
                final link = mc.generateMeetingLink();
                Clipboard.setData(ClipboardData(text: link));
                Get.snackbar(
                  "Meeting Link",
                  "Copied to clipboard!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                );
              },
            ).mR(30),
          ],
        ),
        body: Column(
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
                              backgroundColor: mc.isLocalAudioMuted.value
                                  ? Colors.red
                                  : Colors.white,
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
                              backgroundColor: mc.isLocalVideoMuted.value
                                  ? Colors.red
                                  : Colors.white,
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
      ),
    );
  }
}
