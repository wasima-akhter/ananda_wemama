import 'package:mama_app/core/common_widgets/cus_flexible_dropdown.dart';
import 'package:mama_app/core/common_widgets/empty_widget.dart';
import 'package:mama_app/core/helpers/widgets_helper.dart';
import 'package:mama_app/features/main_tabs/chat/widgets/chat_inbox_security_alert.dart';
import 'package:mama_app/features/main_tabs/chat/widgets/chat_input_row.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/chat_inbox_controller.dart';
import '../widgets/chat_bubble.dart';

class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cic = Get.find<ChatInboxController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: chatRefreshKey,
      onRefresh: () async {
        print("chat refreshed");
      },
      appBar: CommonAppBarContent(
        titleInLeft: true,
        title: cic.fakeChatInbox?.senderData.name ?? "Chat",
        titleLeftWidget: NetworkImageWidget(
          imageUrl: cic.fakeChatInbox?.senderData.imageUrl,
          isCircle: true,
          radius: 18,
        ),
        suffix: CusFlexibleDropdown(
          items: [
            CusDropdownItem(
              title: Strings.reportUser,
              onTap: () async {
                // open bottom sheeet of report info
                await showReportBottomSheet();
              },
            ),
          ],
          child: SvgIcon(iconPath: IconsPath.moreVertical, height: 22),
        ),
      ),

      bottomWidget: ChatInputRow(cic: cic),

      getcmLess: true,

      child: Builder(
        builder: (context) {
          final msgList = cic.fakeChatInbox?.msgList;

          if (msgList == null) return Text("Loading...");
          if (msgList.isEmpty) return EmptyWidget(title: "No messages yet");

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatInboxSecurityAlert(),
              Gap(itemGap * 2),
              ...msgList.map((e) => ChatBubbleCont(message: e)),
            ],
          );
        },
      ).getcm,
    );
  }
}
