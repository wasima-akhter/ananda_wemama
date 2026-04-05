import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';
import 'package:mama_app/features/main_tabs/chat/widgets/chat_inbox_security_alert.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/services/socket/socket_status_banner.dart';
import '../controller/chat_inbox_controller.dart';
import '../model/chat_inbox_msg_item_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_row.dart';
import '../widgets/chat_screen_template.dart';

class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cic = Get.find<ChatInboxController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return ChatScreenTemplate(
      appBar: CommonAppBarContent(
        titleInLeft: true,
        title: '',
        titleLeftWidget: Obx(() {
          final user = cic.realChatInboxMsgItem.value.receiver;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NetworkImageWidget(imageUrl: user?.profileImage ?? '', isCircle: true, radius: 16),
              Gap(itemGap),
              SizedBox(
                width: S.w * 0.5,
                child: Text(
                  user?.name ?? 'Chat',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: 18.titleMclrCusFSOutfit,
                ),
              ),
            ],
          );
        }),
      ),
      inputRow: ChatInputRow(cic: cic).get10cm,
      child: CusRefreshIndicator(
        refreshKey: chatRefreshKey,
        onRefresh: () async {
          cic.getChatInboxMsgList();
        },
        child: SingleChildScrollView(
          controller: cic.scrollController,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatInboxSecurityAlert(),
              Gap(itemGap * 2),

              Obx(() {
                if (cic.isLoading_.value) {
                  return Text("Loading...");
                }
                final chatInboxMsgItem = cic.realChatInboxMsgItem;
                final itemMsgList = cic.realChatInboxMsgItem.value.messages ?? [];
                // final list = [...list_, ...list_, ...list_];
                final list = [...itemMsgList];
                if (list.isEmpty) {
                  return const EmptyWidget(title: "No Messages yet..!");
                }

                // final groupedList = cic.groupMessagesByDate(chatInboxMsgItem.value);

                // return Column(
                //   children: groupedList.map((item) {
                //     // 🟡 DATE HEADER
                //     if (item is String) {
                //       return Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           _dateVerLine(),
                //           Padding(
                //             padding: 10.ph,
                //             child: Text(
                //               item,
                //               style: TxtStyle.outfitSemiB(fs: 12, color: c.textSecondary),
                //             ),
                //           ),
                //           _dateVerLine(),
                //         ],
                //       ).mOnly(bottom: 12, top: 12);
                //     }

                //     // 💬 MESSAGE
                //     final e = item as Message;

                //     return
                //     //  Text("data");
                //     ChatBubbleCont(
                //       message: FakeMsgItemData(
                //         isSentByMe: (e.sender ?? '') == currentProfileId(),
                //         msg: e.text ?? '',
                //         time: DateHelper().formatUTCtimestamp(e.createdAt.toString()).time,
                //       ),
                //     );
                //   }).toList(),
                // );

                final grouped = cic.groupMessagesByDate(); // ✅ reactive call inside Obx
                return Column(
                  children: [
                    const SocketStatusBanner(),
                    ...grouped.map((item) {
                      if (item is String) {
                        return DateDivider(item: item); // your date label widget
                      }
                      final msg = item as Message;
                      return ChatBubbleCont(
                        message: FakeMsgItemData(
                          msg: msg.text ?? '',
                          time: DateHelper().formatTimeAgo(msg.createdAt?.toString() ?? '').date,
                          isSentByMe: msg.sender == currentProfileId(),
                        ),
                      );
                    }),
                  ],
                );
              }),

              // ...msgList.map((e) => ChatBubbleCont(message: e)),
              Gap(itemGap * 2),
            ],
          ).getcm,
        ),
      ),
    );
  }
}

class DateDivider extends StatelessWidget {
  final String item;
  const DateDivider({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dateVerLine(),
        Padding(
          padding: 10.ph,
          child: Text(item, style: TxtStyle.outfitSemiB(fs: 12, color: c.textSecondary)),
        ),
        _dateVerLine(),
      ],
    ).mOnly(bottom: 12, top: 12);
    ;
  }

  Widget _dateVerLine() {
    return Flexible(child: Container(height: 0.2, color: c.secondary));
  }
}
