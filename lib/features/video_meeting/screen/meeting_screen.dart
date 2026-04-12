import 'package:mama_app/features/video_meeting/controller/meeting_controller.dart';

import '../../../app/helper_widgets_export.dart';
import '../modules/meet_bottom_action.dart';
import '../modules/meet_comment_item.dart';
import '../modules/meet_msg_input_row.dart';
import '../modules/meet_react_button.dart';
import '../modules/meet_top_content.dart';
import '../widgets/meeting_screen_template.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MeetingController>();

    return MeetingScreenTemplate(
      backgroundColor: c.cardPrimary,
      inputFocus: mc.inputMsgFocus,
      topContent: TopContent(mc: mc),

      commentList: ListView.separated(
        padding: EdgeInsets.only(top: itemGap * 1.5),
        itemCount: 10,
        separatorBuilder: (_, __) => Gap(14),
        itemBuilder: (_, index) => CommentItem(),
      ).get10cm,

      inputRow: MsgInputRow(inputMsgCtrl: mc.inputMsgCtrl, inputMsgFocus: mc.inputMsgFocus),

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
                  onTap: () => Get.back(),
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
                    onTap: () => mc.toggleSpeak(),
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
              Expanded(child: ReactButton()),
              Expanded(
                child: BottomAction(iconPath: IconsPath.handRaise, text: "Raise Hand"),
              ),
            ],
          ).getcm,
        ),
      ),
    );
  }
}

// extract top section as its own widget


////


