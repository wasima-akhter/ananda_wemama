import 'package:we_mama/core/components/ui/helpers/shapes/custom_divider.dart';
import 'package:we_mama/core/helpers/date_helper.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../core/models/all_comments_of_post_model.dart';
import '../controller/post_details_controller.dart';
import '../widgets/post_details_comments_section.dart';
import '../widgets/post_details_floating_comment_input.dart';
import '../widgets/post_details_post_section.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = PostDetailsController.to;
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pcc.commentFocus.requestFocus();

      Future.delayed(const Duration(milliseconds: 500), () {
        if (pcc.scrollController.hasClients) {
          pcc.scrollController.animateTo(
            pcc.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      });
    });

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async => log("refreshed"),
      isScrollable: false,
      appBar: CommonAppBarContent(title: Strings.post),

      floatingActionButton: PostDetailsFloatingCommentInput(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PostDetailsPostSection(),

          Gap(itemGap * 3),
          CustomDivider(isFullWidth: true, clr: c.primary, h: 0.5),
          Gap(itemGap),

          Flexible(child: PostDetailsCommentsSection()),
        ],
      ).getcm,
    );
  }
}

class CommentItemInPostDetail extends StatelessWidget {
  final CommentModelOfPost item;
  final PostDetailsController pcc;

  const CommentItemInPostDetail({
    super.key,
    required this.item,
    required this.pcc,
  });

  @override
  Widget build(BuildContext context) {
    final childCommentList = item.replies ?? [];

    log(
      'childCommentList: ${childCommentList.isNotEmpty ? childCommentList[0].id : ''}',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainComment(),
        _buildReplyButton(),
        _buildChildComments(childCommentList),
      ],
    );
  }

  Widget _buildMainComment() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.creator?.name ?? 'N/A',
                style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary),
              ),
              Text(item.content ?? '--', style: TxtStyle.outfit(fs: 13)),
            ],
          ),
        ),

        _buildCommentTime(createdAt: item.createdAt, fontSize: 10),
      ],
    );
  }

  Widget _buildReplyButton() {
    return CusGestureDetector(
      onTap: () {
        pcc.replyingToCommentId.value = item.id;
        pcc.replyingToUserName.value = item.creator?.name ?? '';

        pcc.commentFocus.requestFocus();
      },
      child: Text(Strings.reply, style: TxtStyle.outfitSmSecNor500),
    );
  }

  Widget _buildChildComments(List<ReplyModelOfPost> childCommentList) {
    return Column(
      children: [
        ...childCommentList.map((child) {
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildChildComment(child),
          ).mT(6);
        }),
      ],
    );
  }

  Widget _buildChildComment(ReplyModelOfPost child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkImageWidget(
          imageUrl: child.creator?.profileImage ?? '',
          isCircle: true,
          radius: 14,
          enablePreview: true,
          isUser: true,
          name: child.creator?.name ?? '',
        ),

        Gap(itemGap * 0.6),

        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.creator?.name ?? 'N/A',
                      style: TxtStyle.outfitSemiB(fs: 13, color: c.textPrimary),
                    ),
                    Text(child.content ?? '--', style: TxtStyle.outfit(fs: 12)),
                  ],
                ),
              ),

              _buildCommentTime(createdAt: child.createdAt, fontSize: 9),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTime({
    required dynamic createdAt,
    required double fontSize,
  }) {
    final formatted = DateHelper().formatUTCtimestamp(createdAt.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatted.time ?? 'N/A',
          style: TxtStyle.outfitSemiB(fs: fontSize, color: c.textPrimary),
        ).mT(5),
        Text(
          formatted.date ?? 'N/A',
          style: TxtStyle.outfitSemiB(fs: fontSize, color: c.textPrimary),
        ),
      ],
    );
  }
}
