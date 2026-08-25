import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../detail/controller/community_detail_controller.dart';
import '../controller/post_details_controller.dart';
import 'post_item_widget.dart';

class PostDetailsPostSection extends StatelessWidget {
  const PostDetailsPostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = PostDetailsController.to;
    final cc = CommunityDetailController.to;
    return Obx(() {
      if (pcc.isResolvingPost.value) {
        return const LoadingPrimary();
      }

      if (pcc.resolveFailed.value) {
        return EmptyNoSearchWidgetScrollable(
          title: "This post couldn't be found",
          subTitle: "It may have been deleted or removed.",
        );
      }

      final communityData =
          pcc.postDetailArg.value?.communityData ?? Community();

      final postItem = pcc.postDetailArg.value?.postItem ?? AllPost();

      return Container(
        decoration: BoxDecoration(
          color: c.scaffoldBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: PostItemWidget(
          communityData: communityData,
          postItem: postItem,
          btnState: cc.btnState.value,
          postId: postItem.id.toString(),
          userName: postItem.creator?.name ?? '',
          postCreatorId: communityData.id ?? '',
          showActions: false,
        ),
      );
    });
  }
}
