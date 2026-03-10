// lib/features/main_tabs/community/modules/post_item_widget.dart

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_flexible_dropdown.dart';
import '../../../../core/common_widgets/popups.dart';
import '../../../../core/helpers/widgets_helper.dart';
import '../controller/community_detail_controller.dart';
import '../modules/user_short_detail_widget.dart';

class PostItemWidget extends StatelessWidget {
  final MyCommunityBtnState btnState;
  final int postId;
  final bool showActions; // ← add

  const PostItemWidget({
    super.key,
    required this.btnState,
    required this.postId,
    this.showActions = true, // ← default true (community detail shows it)
  });

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityDetailController>();

    return ContainerBordered(
      vp: 12,
      hp: 12,
      hasBrdr: true,
      brdrClr: c.inputBorder.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section 1: Header (user + pin + dropdown) ──
          _PostHeader(cc: cc, postId: postId, btnState: btnState),

          Gap(itemGap * 2),

          // ── Section 2: Post Content ──
          _PostContent(),

          // ── Section 3: Like/Comment Row (optional) ──
          if (showActions) ...[
            Gap(itemGap * 2.5),
            _PostActions(cc: cc, postId: postId, btnState: btnState),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────
class _PostHeader extends StatelessWidget {
  final CommunityDetailController cc;
  final int postId;
  final MyCommunityBtnState btnState;

  const _PostHeader({required this.cc, required this.postId, required this.btnState});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserShortDetailWidget(),
        Row(
          children: [
            Obx(() {
              final isPinned = cc.posts.firstWhere((p) => p.id == postId).isPinned.value;
              if (!isPinned) return const SizedBox.shrink();
              return SvgIcon(iconPath: IconsPath.pin, height: 22);
            }),

            if (btnState == MyCommunityBtnState.visit)
              CusFlexibleDropdown(
                items: [
                  CusDropdownItem(
                    title: Strings.reportContent,
                    onTap: () async => await showReportBottomSheet(),
                  ),
                ],
                child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
              ),

            if (btnState == MyCommunityBtnState.manage)
              Obx(
                () => CusFlexibleDropdown(
                  items: [
                    CusDropdownItem(
                      title: cc.getPinBtnTxt(postId),
                      onTap: () async => cc.togglePin(postId),
                    ),
                    CusDropdownItem(
                      title: cc.getLockBtnTxt(postId),
                      onTap: () async {
                        showLockCommentialog();
                        await Future.delayed(const Duration(seconds: 1));
                        Get.back();
                        cc.toggleCommentLock(postId);
                      },
                    ),
                    CusDropdownItem(
                      title: Strings.deletePost.capEachWord(),
                      onTap: () async => deletePostConfirmDialog(
                        onConfirm: () async => Get.back(),
                        isLoading: RxBool(false),
                      ),
                    ),
                  ],
                  child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────
class _PostContent extends StatelessWidget {
  const _PostContent();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Is it normal for my 2-month-old to want to feed every hour at night? I feel exhausted and keep wondering if I'm doing something wrong 😔",
      style: TxtStyle.outfit(fs: 13, w: 400),
    );
  }
}

// ─────────────────────────────
class _PostActions extends StatelessWidget {
  final CommunityDetailController cc;
  final int postId;
  final MyCommunityBtnState btnState;

  const _PostActions({required this.cc, required this.postId, required this.btnState});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final post = cc.posts.firstWhere((p) => p.id == postId);
      return Row(
        children: [
          CusGestureDetector(
            onTap: () => cc.toggleLike(postId),
            child: Row(
              children: [
                SvgIcon(
                  iconPath: post.isLiked.value ? IconsPath.likeHeartFilled : IconsPath.like,
                  height: 22,
                ),
                Gap(4),
                TextFit(Strings.like, style: TxtStyle.outfitSmNor500),
              ],
            ),
          ),
          Gap(itemGap * 2),
          Row(
            children: [
              SvgIcon(iconPath: IconsPath.chatCircleOutlined, height: 22),
              Gap(4),
              CusGestureDetector(
                onTap: () => Get.toNamed(
                  RoutePaths.postDetails,
                  arguments: {'postId': postId, 'btnState': btnState},
                ),
                child: TextFit(Strings.comment, style: TxtStyle.outfitSmNor500),
              ),
            ],
          ),
        ],
      );
    });
  }
}
