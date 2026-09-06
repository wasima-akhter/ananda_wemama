import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/helpers/shapes/custom_divider.dart';
import '../../../core/components/ui/loaders/empty_widget.dart';
import '../../../gen/assets.gen.dart';
import '../controller/live_chat_controller.dart';
import '../controller/meeting_controller.dart';
import '../modules/meet_comment_item.dart';

class LiveSessionCommentSection extends StatelessWidget {
  const LiveSessionCommentSection({super.key});

  void _dismissKeyboard() {
    final focusNode = MeetingController.to.inputMsgFocus;

    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cc = LiveChatController.to;

    return Obx(() {
      if (cc.messages.isEmpty) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              _dismissKeyboard();
            }

            return false;
          },
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                CustomDivider(isFullWidth: true),
                Gap(itemGap),
                EmptyNoSearchWidgetScrollable(
                  isSmaller: true,
                  title: "No Comments Yet",
                  assetPath: Assets.images.noCommentIcon.path,
                  subTitle:
                      "Be the first to share your thoughts! \nLeave a comment and join the conversation.",
                ),
              ],
            ).getcm,
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            _dismissKeyboard();
          }

          return false;
        },
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          controller: cc.chatScrollCtrl,
          padding: EdgeInsets.only(top: itemGap * 1.5),
          itemCount: cc.messages.length,
          separatorBuilder: (_, _) => Gap(14),
          itemBuilder: (_, index) {
            final msg = cc.messages[index];
            return MeetCommentItem(message: msg);
          },
        ).get10cm,
      );
    });
  }
}
