import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../../detail/controller/community_detail_controller.dart';
import '../controller/comment_controller.dart';

class CommentsBottomSheet extends StatelessWidget {
  final int postId; // ← add
  const CommentsBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommentController>();
    final cc = CommunityDetailController.to;

    return SafeArea(
      top: false,
      child: Container(
        padding: 12.pv,
        decoration: BoxDecoration(color: bgClr, borderRadius: 30.brdrRad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.comment, style: TxtStyle.outfitxSmNor).mR(S.w * 0.12),
            Gap(itemGap * 2.5),

            // Flexible(
            //   child: ListView.separated(
            //     padding: EdgeInsets.zero,
            //     shrinkWrap: true,
            //     itemCount: controller.comments.length,
            //     separatorBuilder: (_, __) => Gap(itemGap * 0.9),
            //     itemBuilder: (context, index) {
            //       final item = controller.comments[index];
            //       return ContainerBordered(
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             NetworkImageWidget(imageUrl: Strings.fakeImageUrl, radius: 20),
            //             Gap(itemGap),
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     item.userName,
            //                     style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary),
            //                   ),
            //                   Text(item.comment, style: TxtStyle.outfit(fs: 13, w: 400)),
            //                   CusGestureDetector(
            //                     onTap: () => controller.showChildren.value = true,
            //                     child: Text(Strings.reply, style: TxtStyle.outfitSmSecNor500),
            //                   ),
            //                   CommentItem(item: item),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Gap(itemGap),

            // ── Hide input if this post's comments are locked ──
            Obx(() {
              final isLocked = false; // ← per post check

              if (isLocked) return const SizedBox.shrink();

              return CusDesTypeTextFormField(
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
                        child: SvgIcon(
                          iconPath: IconsPath.sendSmallWhite,
                          height: 20,
                        ),
                      ),
                    ).mAll(5),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
