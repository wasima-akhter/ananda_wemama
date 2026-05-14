import '../../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
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
                  // return CommentItem(item: item);
                  return Text("comment");
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
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CusGestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: c.primary,
                      child: SvgIcon(iconPath: IconsPath.sendSmallWhite, height: 20),
                    ),
                  ).mAll(5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
