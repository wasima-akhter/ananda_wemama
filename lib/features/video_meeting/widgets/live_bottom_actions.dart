import '../../../app/helper_widgets_export.dart';
import '../../../core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import '../../../core/components/ui/dialogs/popups.dart';
import '../controller/live_chat_controller.dart';
import '../controller/meeting_controller.dart';
import '../modules/meet_bottom_action.dart';
import '../modules/meet_react_button.dart';

class LiveBottomActions extends StatelessWidget {
  const LiveBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = MeetingController.to;
    final cc = LiveChatController.to;
    return ClipRRect(
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
            // ✅ MUTE/SPEAK Button
            // User can MUTE (when speaking)
            // User CANNOT UNMUTE (when muted) — host must unmute
            Expanded(
              child: Obx(
                () => CusGestureDetector(
                  onTap: mc.isSpeaking.value
                      ? () =>
                            mc.toggleSpeak(cc) // ✅ Allow mute
                      : () {
                          // ❌ Block unmute — show feedback
                          Get.snackbar(
                            'Not Allowed',
                            'Only the host can unmute you',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        },
                  child: BottomAction(
                    color: mc.isSpeaking.value ? white : c.primary,
                    iconPath: mc.isSpeaking.value
                        ? IconsPath
                              .unmutedAudio // show "stop speaking" icon
                        : IconsPath
                              .mutedAudio, // show "muted" icon (disabled state)
                    text: mc.isSpeaking.value ? "Speaking" : "Muted",
                    backgroundColor: mc.isSpeaking.value ? c.primary : null,
                    opacity: mc.isSpeaking.value
                        ? 1.0
                        : 0.5, // ← dim when muted to show it's disabled
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
    );
  }
}
