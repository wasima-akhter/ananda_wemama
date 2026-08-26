import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/helpers/shapes/custom_divider.dart';
import '../../../core/components/ui/loaders/empty_widget.dart';
import '../../../gen/assets.gen.dart';
import '../controller/live_chat_controller.dart';
import '../modules/meet_comment_item.dart';

class LiveSessionCommentSection extends StatelessWidget {
  const LiveSessionCommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = LiveChatController.to;
    return Obx(() {
      if (cc.messages.isEmpty) {
        return SingleChildScrollView(
          // ← wraps fixed content so it scrolls if needed
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
        );
      }

      return ListView.separated(
        controller: cc.chatScrollCtrl,
        padding: EdgeInsets.only(top: itemGap * 1.5),
        itemCount: cc.messages.length,
        separatorBuilder: (_, _) => Gap(14),
        itemBuilder: (_, index) {
          final msg = cc.messages[index];
          return MeetCommentItem(message: msg);
        },
      ).get10cm;
    });
  }
}
