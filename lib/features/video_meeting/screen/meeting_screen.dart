import 'package:mama_app/core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import 'package:mama_app/core/components/ui/helpers/shapes/custom_divider.dart';
import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';
import 'package:mama_app/features/video_meeting/controller/live_chat_controller.dart';
import 'package:mama_app/features/video_meeting/controller/meeting_controller.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/dialogs/popups.dart';
import '../modules/meet_bottom_action.dart';
import '../modules/meet_comment_item.dart';
import '../modules/meet_msg_input_row.dart';
import '../modules/meet_react_button.dart';
import '../modules/meet_top_content.dart';
import '../widgets/heart_animation_widget.dart';
import '../widgets/meeting_screen_template.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MeetingController>();
    final cc = Get.find<LiveChatController>();

    return Stack(
      children: [
        MeetingScreenTemplate(
          backgroundColor: c.cardPrimary,
          inputFocus: mc.inputMsgFocus,
          topContent: TopContent(mc: mc, cc: cc),

          // ✅ Reactive comment list
          commentList: Obx(() {
            if (cc.messages.isEmpty) {
              return SingleChildScrollView(
                // ← wraps fixed content so it scrolls if needed
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CustomDivider(isFullWidth: true),
                    Gap(itemGap),
                    EmptyNoSearchWidget(title: Strings.noCommentsYet, isSmaller: true),
                  ],
                ),
              );
            }

            return ListView.separated(
              controller: cc.chatScrollCtrl,
              padding: EdgeInsets.only(top: itemGap * 1.5),
              itemCount: cc.messages.length,
              separatorBuilder: (_, __) => Gap(14),
              itemBuilder: (_, index) {
                final msg = cc.messages[index];
                return MeetCommentItem(message: msg);
              },
            ).get10cm;
          }),

          inputRow: MsgInputRow(
            inputMsgCtrl: mc.inputMsgCtrl,
            inputMsgFocus: mc.inputMsgFocus,
            onSend: () => cc.sendMessage(mc.inputMsgCtrl.text), // ✅ wire send
          ),

          bottomActions: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              color: c.cardPrimary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CusGestureDetector(
                      onTap: () {
                        // ← NO leaveMeeting() here
                        showLiveExitPopup(
                          LiveExitReason.voluntary,

                          onTapCancel: (cancelLeave) async {
                            if (cancelLeave) {
                              Get.back();
                            } else {
                              mc.isSessionExiting = true;
                              mc.exitReason = LiveExitReason.voluntary;

                              Get.back();
                              await mc.leaveSession();
                            }
                          },
                        );
                      },
                      child: BottomAction(
                        iconPath: IconsPath.closeWhite,
                        backgroundColor: Colors.red,
                        size: 13,
                        text: "Leave",
                        color: white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => CusGestureDetector(
                        onTap: () => mc.toggleSpeak(cc),
                        child: BottomAction(
                          color: mc.isSpeaking.value ? white : c.primary,
                          iconPath: mc.isSpeaking.value
                              ? IconsPath
                                    .unmutedAudio // show "stop speaking" icon
                              : IconsPath.mutedAudio, // show "speak" icon
                          text: mc.isSpeaking.value ? "Speaking" : "Muted",
                          backgroundColor: mc.isSpeaking.value ? c.primary : null,
                        ),
                      ),
                    ),
                  ),

                  // Reaction button
                  Expanded(
                    child: ReactButton(
                      count: cc.reactionCount.value,
                      sendReaction: (emoji) => cc.sendReaction(emoji),
                    ),
                  ),
                  // Raise hand button
                  Expanded(
                    child: Obx(
                      () => CusGestureDetector(
                        onTap: () => cc.toggleRaiseHand(),
                        child: BottomAction(
                          color: cc.isHandRaised ? white : c.primary,
                          iconPath: cc.isHandRaised
                              ? IconsPath
                                    .handRaise // put filled icon
                              : IconsPath.handRaise,
                          text: cc.isHandRaised ? "Raised Hand" : "Raise Hand",

                          backgroundColor: cc.isHandRaised ? c.primary : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ).getcm,
            ),
          ),
        ),

        // ── Floating emoji overlay (above everything, near react button) ──
        Positioned(
          bottom: 100.h, // sits just above the bottom action bar
          right: 80.w, // aligns roughly over the react button
          child: Obx(() {
            return Stack(
              clipBehavior: Clip.none,
              children: cc.hearts.map((heart) {
                return HeartAnimationWidget(key: ValueKey(heart.id), emoji: heart.emoji);
              }).toList(),
            );
          }),
        ),
      ],
    );
  }
}

// extract top section as its own widget


////


