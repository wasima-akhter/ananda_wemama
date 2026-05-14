import 'package:mama_app/core/components/ui/helpers/shapes/custom_divider.dart';
import 'package:mama_app/features/main_tabs/community/controller/community_detail_controller.dart';
import 'package:mama_app/features/main_tabs/community/model/community_item_detail_model.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../shared/comments/widget/comment_item_w_reply.dart';
import '../controller/post_details_controller.dart';
import '../model/all_comments_of_post_model.dart';
import '../widgets/post_item_widget.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = Get.find<PostDetailsController>();
    final cc = Get.find<CommunityDetailController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    // ← scroll to bottom + open keyboard after first frame
    // Replace current addPostFrameCallback with:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pcc.commentFocus.requestFocus(); // ← focus first, keyboard opens

      // Wait for keyboard to fully open, then scroll
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
      isScrollable: false,
      appBar: CommonAppBarContent(title: Strings.post),

      // ── Pinned input at bottom ──
      floatingActionButton: Obx(() {
        final replyingTo = pcc.replyingToUserName.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyingTo.isNotEmpty)
              ContainerBordered(
                hp: 10,
                vp: 6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Replying to $replyingTo", style: TxtStyle.outfit(fs: 14)),
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
              hintText: replyingTo.isNotEmpty ? "Reply to $replyingTo" : Strings.writeSomething,
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
                            : SvgIcon(iconPath: IconsPath.sendSmallWhite, height: 20),
                      ),
                    ),
                  ).mAll(5),
                ],
              ),
            ).getcm,
          ],
        );
      }),

      // ── Scrollable body ──
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Post at top ──
          Builder(
            builder: (context) {
              final communityData = pcc.postDetailArg.value?.communityData ?? Community();

              final postItem = pcc.postDetailArg.value?.postItem ?? AllPost();
              return PostItemWidget(
                communityData: communityData,
                postItem: postItem,
                cc: cc,
                btnState: cc.btnState.value,
                postId: postItem.id.toString(),
                userName: postItem.creator?.name ?? '',
                postCreatorId: communityData.id ?? '',
                showActions: false,
              ).mB(itemGap);
            },
          ),

          Gap(itemGap * 3),
          CustomDivider(isFullWidth: true, clr: c.primary, h: 0.5),
          Gap(itemGap),

          // ── Comments list (not independently scrollable) ──
          Flexible(
            child: Obx(() {
              final state = pcc.commentState;

              return UIStateHandler(
                state: state,

                onRefresh: () async {
                  await pcc.getCommentsList();
                },

                loading: () => ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: itemGap),
                  itemCount: 6,
                  separatorBuilder: (_, __) => Gap(itemGap * 0.6),
                  itemBuilder: (_, index) => const CommentItemShimmer(),
                ),

                empty: () => const EmptyNoSearchWidgetScrollable(title: "No comments yet"),

                data: () => ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: itemGap * 2),
                  itemCount: pcc.comments.length,
                  separatorBuilder: (_, __) => Gap(itemGap * 0.6),
                  itemBuilder: (_, index) {
                    final item = pcc.comments[index];

                    return ContainerBordered(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NetworkImageWidget(
                            imageUrl: item.creator?.profileImage ?? '',
                            isCircle: true,
                            radius: 16,
                          ),
                          Gap(itemGap),

                          Expanded(
                            child: CommentItemInPostDetail(item: item, pcc: pcc),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ).getcm,
    );
  }
}

class CommentItemInPostDetail extends StatelessWidget {
  final CommentModelOfPost item;
  final PostDetailsController pcc;
  const CommentItemInPostDetail({super.key, required this.item, required this.pcc});

  @override
  Widget build(BuildContext context) {
    final childCommentList = item.replies ?? [];
    print('childCommentList: ${childCommentList.isNotEmpty ? childCommentList[0]?.id : ''}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.creator?.name ?? 'N/A',
          style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary),
        ),
        Text(item.content ?? '--', style: TxtStyle.outfit(fs: 13)),
        CusGestureDetector(
          onTap: () {
            pcc.replyingToCommentId.value = item.id;
            pcc.replyingToUserName.value = item.creator?.name ?? '';

            pcc.commentFocus.requestFocus(); // open keyboard
          },
          child: Text(Strings.reply, style: TxtStyle.outfitSmSecNor500),
        ),

        Column(
          children: [
            ...childCommentList.map((child) {
              return Padding(
                padding: EdgeInsets.only(left: 20), // 👈 indent
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NetworkImageWidget(
                      imageUrl: child.creator?.profileImage ?? '',
                      isCircle: true,
                      radius: 14, // 👈 smaller avatar
                    ),
                    Gap(itemGap * 0.6),

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
                  ],
                ),
              ).mT(6);
            }),
          ],
        ),
      ],
    );
  }
}
