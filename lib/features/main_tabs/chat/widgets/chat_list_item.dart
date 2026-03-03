import '../../../../app/helper_widgets_export.dart';
import '../controller/chat_controller.dart';
import 'chat_user_image.dart';

class ChatListItem extends StatelessWidget {
  final FakeChatModel chatModel;

  const ChatListItem({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    final imageUrl = chatModel.imageUrl;
    final name = chatModel.name;
    final lastMessage = chatModel.lastMessage;
    final time = chatModel.time;
    final chatId = chatModel.id;

    return CusGestureDetector(
      onTap: () {
        Get.toNamed(RoutePaths.chatInbox, arguments: chatId);
      },
      child: ContainerBordered(
        mv: 10,
        vp: 0,
        hp: 0,
        child: Row(
          children: [
            ChatUserImage(imageUrl: imageUrl, name: name),
            Gap(itemGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    name,
                    style: TxtStyle.outfitLarTitle,
                  ),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    lastMessage,
                    style: TxtStyle.outfitSmSecNor,
                  ),
                ],
              ),
            ),

            Gap(itemGap),
            Text(time.cap, style: TxtStyle.outfitSmSecNor500),
          ],
        ),
      ).mL(8),
    );
  }
}
