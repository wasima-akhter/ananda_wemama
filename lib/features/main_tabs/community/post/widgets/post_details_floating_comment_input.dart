import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../controller/post_details_controller.dart';

class PostDetailsFloatingCommentInput extends StatelessWidget {
  const PostDetailsFloatingCommentInput({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = PostDetailsController.to;

    if (!pcc.hasValidPostId.value) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final replyingTo = pcc.replyingToUserName.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyingTo.isNotEmpty)
            ContainerBordered(
              hp: 10,
              vp: 6,
              mh: 20,
              mv: 4,
              contClr: c.backgroundSecondary,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Replying to $replyingTo",
                    style: TxtStyle.outfit(fs: 14),
                  ),
                  Gap(6),
                  CusGestureDetector(
                    onTap: () {
                      pcc.replyingToCommentId.value = null;
                      pcc.replyingToUserName.value = '';
                    },
                    child: SvgIconColored(iconPath: IconsPath.closeCircle),
                  ),
                ],
              ),
            ),

          CusDesTypeTextFormField(
            controller: pcc.commentCtrl,
            focusNode: pcc.commentFocus,
            hintText: replyingTo.isNotEmpty
                ? "Reply to $replyingTo"
                : Strings.writeSomething,
            minLines: 1,
            minHeight: 40,
            maxHeight: 65,
            suffix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CusGestureDetector(
                  onTap: () async => await pcc.onTapAddComment(),
                  child: CircleAvatar(
                    backgroundColor: c.primary,
                    child: Obx(
                      () => pcc.isAddCommentLoading.value
                          ? LoadingWhite()
                          : Container(
                              padding: EdgeInsets.all(
                                ScreenSizeX.isTablet ? 10 : 0,
                              ),
                              child: SvgIcon(
                                iconPath: IconsPath.sendSmallWhite,
                                height: 20,
                              ),
                            ),
                    ),
                  ),
                ).mAll(5),
              ],
            ),
          ).getcm,
        ],
      );
    });
  }
}
