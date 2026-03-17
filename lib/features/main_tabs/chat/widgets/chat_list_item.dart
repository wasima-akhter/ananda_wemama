import '../../../../app/helper_widgets_export.dart';
import '../controller/chat_controller.dart';
import 'chat_user_image.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.chatModel});

  final FakeChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: () => Get.toNamed(RoutePaths.chatInbox, arguments: chatModel.id),
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
                  Text(
                    chatModel.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TxtStyle.outfitSmSecNor,
                  ),
                ],
              ),
            ),
            Gap(itemGap),
            Text(chatModel.time.cap, style: TxtStyle.outfitSmSecNor500),
          ],
        ),
      ).mL(8),
    );
  }
}
