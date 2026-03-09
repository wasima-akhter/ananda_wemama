import '../../../../app/helper_widgets_export.dart';
import '../../../main_tabs/chat/widgets/chat_user_image.dart';
import '../controller/blocked_user_controller.dart';

class BlockedUserListItem extends StatelessWidget {
  final BlockedUserController buc;
  final FakeBlockedUserModel chatModel;

  const BlockedUserListItem({super.key, required this.chatModel, required this.buc});

  @override
  Widget build(BuildContext context) {
    final imageUrl = chatModel.imageUrl;
    final name = chatModel.name;

    return ContainerBordered(
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
                  name.cap,
                  style: TxtStyle.outfitSemiB(fs: 16, w: 500, color: c.primary),
                ),
              ],
            ),
          ),

          Gap(itemGap),
          CustomBtnWTxt(
            isLoading: buc.isUnblockLoading.value,
            onTap: buc.onTapBlocked,
            isSmall: true,
            btnColor: ctransp,
            padding: EdgeInsets.zero,
            btnTxt: Strings.blocked.cap,
            style: TxtStyle.outfitSmSecNor500,
          ),
        ],
      ),
    ).get10cm.mR(10);
  }
}
