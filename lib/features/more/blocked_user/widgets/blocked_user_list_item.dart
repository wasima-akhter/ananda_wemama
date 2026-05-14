import '../../../../app/helper_widgets_export.dart';
import '../../../main_tabs/chat/widgets/chat_user_image.dart';
import '../controller/blocked_user_controller.dart';
import '../model/blocked_user_model.dart';

class BlockedUserListItem extends StatelessWidget {
  final BlockedUserController buc;
  final BlockedUserDataModel user; // ✅ real model

  const BlockedUserListItem({super.key, required this.user, required this.buc});

  @override
  Widget build(BuildContext context) {
    final image = user.blocked?.profileImage ?? '';
    final name = user.blocked?.name ?? '';
    return ContainerBordered(
      mv: 10,
      vp: 0,
      hp: 0,
      child: Row(
        children: [
          ChatUserImage(imageUrl: image, name: name),
          Gap(itemGap),
          Expanded(
            child: Text(
              name.cap,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.outfitSemiB(fs: 16, w: 500, color: c.primary),
            ),
          ),
          Gap(itemGap),

          // ─────────────────────────────
          // 🔹 Unblock button
          // ─────────────────────────────
          Obx(
            () => CustomBtnWTxt(
              isLoading: buc.isUnblockLoading.value,
              onTap: () => buc.onTapBlocked(userId: user.id ?? ''),
              isSmall: true,
              btnColor: ctransp,
              padding: EdgeInsets.zero,
              btnTxt: Strings.unblock.cap,
              style: TxtStyle.outfitSmSecNor500,
            ),
          ),
        ],
      ),
    ).get10cm.mR(10);
  }
}
