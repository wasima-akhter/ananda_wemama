import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../core/models/single_post_data.dart';
import '../../detail/controller/community_detail_controller.dart';
import '../controller/post_details_controller.dart';
import 'post_item_widget.dart';

class PostDetailsPostSection extends StatelessWidget {
  const PostDetailsPostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = PostDetailsController.to;
    final cc = CommunityDetailController.to;
    if (!pcc.hasValidPostId.value) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      // Show post skeleton while fetching single post
      if (pcc.isGetSinglePostLoading.value) {
        return const PostItemShimmer();
      }

      final postItem = pcc.singlePost.value;

      if (postItem == null) {
        return EmptyNoSearchWidgetScrollable(
          title: "This post couldn't be found",
          subTitle: "It may have been deleted or removed.",

          assetPath: Assets.images.noCommentIcon.path,
        );
      }

      final communityData = Community(
        id: postItem.community?.id ?? pcc.postDetailArg.value?.communityId,
        name: postItem.community?.name,
      );

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
          postItem: postItem.toAllPost(),
          btnState: cc.btnState.value,
          postId: postItem.id ?? '',
          userName: postItem.creator?.name ?? '',
          postCreatorId: postItem.creator?.id ?? '',
          showActions: false,
        ),
      );
    });
  }
}

extension SinglePostModelMapper on SinglePostModel {
  AllPost toAllPost() {
    return AllPost(
      id: id,
      content: content,
      totalLike: totalLike,
      totalComment: totalComment,
      isAnonymous: isAnonymous,
      isPinned: isPinned,
      isCommentLocked: isCommentLocked,
      isLiked: isLiked,
      creator: creator == null
          ? null
          : Creator(
              id: creator?.id ?? '',
              name: creator?.name,
              profileImage: creator?.profileImage,
              city: creator?.city,
            ),
      createdAt: createdAt,
    );
  }
}
