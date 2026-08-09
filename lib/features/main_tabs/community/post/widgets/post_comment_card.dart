import '../../../../../app/helper_widgets_export.dart';
import '../../core/models/all_comments_of_post_model.dart';
import '../controller/post_details_controller.dart';
import '../screen/post_details_screen.dart';

class PostCommentCard extends StatelessWidget {
  final CommentModelOfPost item;

  const PostCommentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final pcc = PostDetailsController.to;
    return ContainerBordered(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageWidget(
            imageUrl: item.creator?.profileImage ?? '',
            isCircle: true,
            radius: 16,
            isUser: true,
            name: item.creator?.name,
            enablePreview: true,
          ),

          // Gap(itemGap),
          Expanded(
            child: CommentItemInPostDetail(item: item, pcc: pcc),
          ),
        ],
      ),
    );
  }
}
