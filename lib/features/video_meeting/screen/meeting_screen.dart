import 'package:we_mama/features/video_meeting/modules/meet_heart_widget.dart';

import '../../../app/helper_widgets_export.dart';
import '../controller/meeting_controller.dart';
import '../modules/meet_msg_input_row.dart';
import '../modules/top_content/meet_top_content.dart';
import '../widgets/live_bottom_actions.dart';
import '../widgets/live_session_comment_section.dart';
import '../widgets/meeting_screen_template.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = MeetingController.to;
    return Stack(
      children: [
        MeetingScreenTemplate(
          backgroundColor: c.cardPrimary,
          inputFocus: mc.inputMsgFocus,
          topContent: TopContent(),

          // ✅ Reactive comment list
          commentList: LiveSessionCommentSection(),

          inputRow: MsgInputRow(),

          bottomActions: LiveBottomActions(),
        ),

        // ── Floating emoji overlay (above everything, near react button) ──
        Positioned(
          bottom: 100.h, // sits just above the bottom action bar
          right: 80.w, // aligns roughly over the react button
          child: MeetHeartWidget(),
        ),
      ],
    );
  }
}

// extract top section as its own widget

////
