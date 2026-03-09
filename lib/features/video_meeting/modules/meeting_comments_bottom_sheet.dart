import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_des_type_text_form_field.dart';
import '../controller/meeting_comment_controller.dart';

class MeetingCommentsBottomSheet extends StatelessWidget {
  final int postId; // ← add
  const MeetingCommentsBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MeetingCommentController>();

    return SafeArea(
      top: false,
      child: Container(
        padding: 12.pv,
        decoration: BoxDecoration(color: bgClr, borderRadius: 30.brdrRad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Strings.liveChat, style: TxtStyle.outfitSmTitle),
            Gap(itemGap * 2.5),

            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.comments.length,
                separatorBuilder: (_, __) => Gap(itemGap * 0.9),
                itemBuilder: (context, index) {
                  final item = controller.comments[index];
                  return CommentItem(item: item);
                },
              ),
            ),

            Gap(itemGap),

            // ──  comments  ──
            CusDesTypeTextFormField(
              minLines: 1,
              minHeight: 40,
              maxHeight: 65,
              rad: 30,
              style: TxtStyle.outfitSmNor,
              bgClr: ctransp,
              isPaddingLess: true,
              controller: controller.commentCtrl,
              focusNode: controller.commentFocus,
              hintText: Strings.writeSomething,
              suffix: IntrinsicWidth(
                child: CusGestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: c.primary,
                    child: SvgIcon(iconPath: IconsPath.sendSmallWhite, height: 20),
                  ),
                ).mAll(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final FakeCommentModel item;
  const CommentItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageWidget(imageUrl: Strings.fakeImageUrl, radius: 20),

          Gap(itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.userName, style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary)),

                    Gap(itemGap),
                    Text(item.time, style: TxtStyle.outfitxSmNor),
                  ],
                ),
                Text(item.comment, style: TxtStyle.outfit(fs: 13, w: 400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
