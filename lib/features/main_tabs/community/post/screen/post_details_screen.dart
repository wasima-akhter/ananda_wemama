import 'package:we_mama/core/components/ui/dialogs/popups.dart';
import 'package:we_mama/core/components/ui/helpers/shapes/custom_divider.dart';
import 'package:we_mama/core/helpers/date_helper.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../../gen/assets.gen.dart';
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
      onRefresh: () async => print("refreshed"),
      // isScrollable: false,
      appBar: CommonAppBarContent(title: Strings.post),

      floatingActionButton: PostDetailsFloatingCommentInput(),

      child: Obx(() {
        if (!pcc.hasValidPostId.value) {
          return _InvalidPostPlaceholder();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10.h),

            PostDetailsPostSection(),

            Gap(itemGap),

            CustomDivider(
              isFullWidth: true,
              clr: c.inputBorder.withValues(alpha: 0.8),
              h: 0.5,
            ),

            Gap(itemGap),

            Flexible(child: PostDetailsCommentsSection()),
          ],
        ).getcm;
      }),
    );
  }
}

class _InvalidPostPlaceholder extends StatelessWidget {
  const _InvalidPostPlaceholder();

  @override
  Widget build(BuildContext context) {
    return EmptyNoSearchWidgetScrollable(
      isScrollable: false,
      assetPath: Assets.images.noCommentIcon.path,
      title: "Post unavailable",
      subTitle: "The post you're looking for is unavailable.",
    ).getcm;
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

    print(
      'childCommentList: ${childCommentList.isNotEmpty ? childCommentList[0].id : ''}',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainComment(),
        Gap(2),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      // NetworkImageWidget(
                      //   imageUrl: item.creator?.profileImage ?? '',
                      //   isCircle: true,
                      //   radius: 16,
                      //   isUser: true,
                      //   name: item.creator?.name,
                      // ),
                      Gap(8),
                      CusGestureDetector(
                        onTap: () {
                          showProfileDetailsPopup(
                            userId: item.creator?.id ?? '',
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5),

                          child: Text(
                            (item.creator?.name?.capEachWord() ?? 'Unknown')
                                .capEachWord(),
                            style: TxtStyle.outfitSemiB(
                              fs: 14,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  _buildCommentTime(createdAt: item.createdAt, fontSize: 9),
                ],
              ),
              Row(
                children: [
                  // Gap(35.r),
                  Gap(8),
                  Expanded(
                    child: Text(
                      item.content ?? '--',
                      style: TxtStyle.outfit(fs: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyButton() {
    return Row(
      children: [
        // Gap(35.r),
        Gap(8),
        CusGestureDetector(
          onTap: () {
            pcc.replyingToCommentId.value = item.id;
            pcc.replyingToUserName.value = item.creator?.name ?? '';

            pcc.commentFocus.requestFocus();
          },
          child: Text(Strings.reply, style: TxtStyle.outfitSmSecNor500),
        ),
      ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Name + Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CusGestureDetector(
                    onTap: () {
                      showProfileDetailsPopup(userId: item.creator?.id ?? '');
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 5),

                      child: Text(
                        (child.creator?.name?.capEachWord() ??
                            'Unknown'.capEachWord()),
                        style: TxtStyle.outfitSemiB(
                          fs: 13,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  _buildCommentTime(createdAt: child.createdAt, fontSize: 9),
                ],
              ),

              // Row 2: Content
              Text(child.content ?? '--', style: TxtStyle.outfit(fs: 12)),
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
