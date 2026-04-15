import 'package:mama_app/core/components/ui/helpers/shapes/custom_divider.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../shared/comments/widget/comment_item_w_reply.dart';
import '../controller/post_details_controller.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = Get.find<PostDetailsController>();
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
      appBar: CommonAppBarContent(title: Strings.post),
      scrollController: pcc.scrollController,

      // ── Pinned input at bottom ──
      floatingActionButton: Obx(() {
        final isLocked = false.obs.value;

        if (isLocked) return const SizedBox.shrink();

        return CusDesTypeTextFormField(
          minLines: 1,
          minHeight: 40,
          maxHeight: 65,
          rad: 30,
          style: TxtStyle.outfitSmNor,
          bgClr: c.inputBackground,
          isPaddingLess: true,
          controller: pcc.commentCtrl,
          focusNode: pcc.commentFocus,
          hintText: Strings.writeSomething,
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CusGestureDetector(
                onTap: () => pcc.onTapAddComment(),
                child: CircleAvatar(
                  backgroundColor: c.primary,
                  child: SvgIcon(iconPath: IconsPath.sendSmallWhite, height: 20),
                ),
              ).mAll(5),
            ],
          ),
        ).getcm;
      }),

      // ── Scrollable body ──
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Post at top ──
          // PostItemWidget(cc: cc,
          // postItem: ,
          //  postId: postId, btnState: btnState, showActions: false),
          Gap(itemGap * 3),
          CustomDivider(isFullWidth: true, clr: c.secondary),
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

                empty: () => const EmptyWidget(title: "No comments yet"),

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
                          NetworkImageWidget(imageUrl: Strings.fakeImageUrl, radius: 20),
                          Gap(itemGap),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.creator?.name ?? '',
                                  style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary),
                                ),
                                Text(item.content ?? '', style: TxtStyle.outfit(fs: 13)),
                                CusGestureDetector(
                                  onTap: () => pcc.showChildren.value = true,
                                  child: Text(Strings.reply, style: TxtStyle.outfitSmSecNor500),
                                ),
                              ],
                            ),
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
