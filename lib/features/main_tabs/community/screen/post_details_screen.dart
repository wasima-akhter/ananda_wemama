import 'package:mama_app/core/common_widgets/custom_divider.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_des_type_text_form_field.dart';
import '../../../../core/common_widgets/items/comment_item_w_reply.dart';
import '../controller/community_detail_controller.dart';
import '../controller/post_details_controller.dart';
import '../widgets/post_item_widget.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = Get.find<PostDetailsController>();
    final cc = Get.find<CommunityDetailController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    final args = Get.arguments as Map<String, dynamic>;
    final postId = args['postId'] as int;
    final btnState = args['btnState'] as MyCommunityBtnState;

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
        final isLocked = cc.posts.firstWhere((p) => p.id == postId).isCommentLocked.value;

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
                onTap: () {},
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
          PostItemWidget(postId: postId, btnState: btnState, showActions: false),

          Gap(itemGap * 3),
          CustomDivider(isFullWidth: true, clr: c.secondary),
          Gap(itemGap),

          // ── Comments list (not independently scrollable) ──
          Flexible(
            child: Column(
              children: [
                ...List.generate(pcc.comments.length, (index) {
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
                                item.userName,
                                style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary),
                              ),
                              Text(item.comment, style: TxtStyle.outfit(fs: 13, w: 400)),
                              CusGestureDetector(
                                onTap: () => pcc.showChildren.value = true,
                                child: Text(Strings.reply, style: TxtStyle.outfitSmSecNor500),
                              ),
                              CommentItem(item: item),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  ;
                }),
              ],
            ),
          ),
        ],
      ).getcm,
    );
  }
}
