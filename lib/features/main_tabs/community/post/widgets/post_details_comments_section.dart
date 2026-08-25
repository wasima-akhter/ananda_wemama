import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../shared/comments/widget/comment_item_w_reply.dart';
import '../controller/post_details_controller.dart';
import 'post_comment_card.dart';

class PostDetailsCommentsSection extends StatelessWidget {
  const PostDetailsCommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = PostDetailsController.to;
    if (!pcc.hasValidPostId.value) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      return UIStateHandler(
        state: pcc.commentState,

        onRefresh: () async {
          await pcc.getCommentsList();
        },

        loading: () => ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: itemGap),
          itemCount: 6,
          separatorBuilder: (_, _) => Gap(itemGap * 0.6),
          itemBuilder: (_, _) => const CommentItemShimmer(),
        ),

        empty: () => EmptyNoSearchWidgetScrollable(
          isScrollable: false,
          assetPath: Assets.images.noCommentIcon.path,
          title: "No comments yet",
          subTitle:
              "Be the first to share some love \nor start the conversation!",
        ),

        data: () => ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: itemGap * 2),
          itemCount: pcc.comments.length,
          separatorBuilder: (_, _) => Gap(itemGap * 0.6),
          itemBuilder: (_, index) {
            return PostCommentCard(item: pcc.comments[index]);
          },
        ),
      );
    });
  }
}
