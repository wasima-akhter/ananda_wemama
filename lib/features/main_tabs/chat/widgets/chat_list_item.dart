import '../../../../app/helper_widgets_export.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../controller/chat_inbox_controller.dart';
import 'chat_ui_models.dart';
import 'chat_user_image.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.chatModel});

  final FakeChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    print(' passed chat id: ${chatModel.id}');
    print(' passed chatModel.isblocked: ${chatModel.isblocked}');
    print(' passed chatModel.lastMessage: ${chatModel.lastMessage}');
    return CusGestureDetector(
      onTap: () {
        if (Get.isRegistered<ChatInboxController>()) {
          Get.delete<ChatInboxController>(force: true);
        }
        Get.toNamed(
          RoutePaths.chatInbox,
          arguments: ChatInboxArgPassModel(
            chatId: chatModel.id,
            isBlocked: chatModel.isblocked,
          ),
        );
      },
      child: ContainerBordered(
        mv: 10,
        vp: 0,
        hp: 0,
        child: Row(
          children: [
            ChatUserImage(imageUrl: chatModel.imageUrl, name: chatModel.name),
            Gap(itemGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TxtStyle.outfitSmTitle,
                  ),
                  if (chatModel.lastMessage.isNotEmpty)
                    Text(
                      chatModel.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TxtStyle.outfit(
                        fs: chatModel.isNewMatch ? 12 : 13,
                        color: chatModel.isNewMatch
                            ? Colors.grey.shade600
                            : c.strokePrimary,
                      ),
                    ),
                ],
              ),
            ),
            Gap(itemGap * 3),
            Column(
              children: [
                if (chatModel.time.isNotEmpty)
                  Text(chatModel.time.cap, style: TxtStyle.outfitSmSecNor500),
                if (chatModel.isblocked)
                  Text(Strings.blocked.cap, style: TxtStyle.outfitSmSecNor500),
              ],
            ),
          ],
        ),
      ).mL(8),
    );
  }
}
