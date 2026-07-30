// lib/features/main_tabs/community/modules/post_item_widget.dart

import 'package:we_mama/core/models/ui/common_data_models.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/dialogs/popups.dart';
import '../../../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import '../../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../detail/controller/community_detail_controller.dart';
import 'user_short_detail_widget.dart';

class PostItemWidget extends StatelessWidget {
  final Community communityData;
  final MyCommunityBtnState btnState;
  final String postId;

  final String postCreatorId;
  final String userName;
  final bool showActions;
  final AllPost postItem;

  const PostItemWidget({
    super.key,
    required this.btnState,
    required this.postId,
    this.showActions = true,

    required this.postItem,
    required this.userName,
    required this.postCreatorId,
    required this.communityData,
  });

  @override
  Widget build(BuildContext context) {
    final cc = CommunityDetailController.to;
    return Obx(() {
      final isDeleted = cc.deleteLockFlag(postId).value;
      final isDeleting = cc.flagsOf(postId)?.isdeleteLoading.value ?? false;

      // 🔥 CASE 1: deleting → show shimmer
      if (isDeleting) {
        return const PostItemShimmer();
      }

      // 🔥 CASE 2: deleted → remove from UI
      if (isDeleted) {
        return const SizedBox.shrink();
      }

      // ✅ NORMAL UI
      return ContainerBordered(
        vp: 12,
        hp: 12,
        hasBrdr: true,
        brdrClr: c.inputBorder.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(
              postId: postId,
              btnState: btnState,
              postCreatorId: postCreatorId,
              postItem: postItem,
            ),
            Gap(itemGap * 1.5),

            _PostContent(postItem: postItem),

            if (showActions) ...[
              Gap(itemGap * 2),
              _PostActions(
                communityData: communityData,
                postItem: postItem,
                postId: postId,
                userName: userName,
                btnState: btnState,
              ),
            ],
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────
class _PostHeader extends StatelessWidget {
  final String postId;
  final String postCreatorId;
  final MyCommunityBtnState btnState;
  final AllPost postItem;

  const _PostHeader({
    required this.postId,
    required this.btnState,
    required this.postItem,
    required this.postCreatorId,
  });

  @override
  Widget build(BuildContext context) {
    final cc = CommunityDetailController.to;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: UserShortDetailWidget(postItem: postItem)),

        // ✅ Obx wraps only the reactive trailing section
        Obx(() {
          final isPinned = cc.pinFlag(postId).value;
          final isLocked =
              (postItem.isCommentLocked ?? false) ||
              cc.commentLockFlag(postId).value;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pin indicator
              if (isPinned)
                SvgIcon(iconPath: IconsPath.pin, height: 22)
              else
                const SizedBox.shrink(),

              // Visitor dropdown
              if (btnState == MyCommunityBtnState.visit
              // & currentProfileId() == postCreatorId
              )
                CusFlexibleDropdown(
                  items: [
                    CusDropdownItem(
                      title: Strings.reportContent.capEachWord(),
                      onTap: () => cc.onTapReportContent(postId: postId),
                    ),
                  ],
                  child: SvgIconColored(
                    iconPath: IconsPath.moreVertical,
                    height: 20,
                  ),
                ),

              // Manager dropdown
              if (btnState == MyCommunityBtnState.manage)
                CusFlexibleDropdown(
                  items: [
                    CusDropdownItem(
                      title: isPinned
                          ? Strings.unpinPost.capEachWord()
                          : Strings.pinPost.capEachWord(),
                      // onTap: () => cc.togglePin(postId),
                      onTap: () => cc.togglePinApi(postId),
                    ),
                    CusDropdownItem(
                      title: isLocked
                          ? Strings.unlockComment.capEachWord()
                          : Strings.lockComment.capEachWord(),
                      onTap: () async {
                        showLockCommentialog(isLocked: isLocked);
                        await Future.delayed(const Duration(seconds: 1));
                        Get.back();
                        Get.back();
                        // cc.toggleCommentLock(postId);
                        await cc.toggleLockApi(postId);
                      },
                    ),
                    CusDropdownItem(
                      title: Strings.deletePost.capEachWord(),
                      onTap: () async => deletePostConfirmDialog(
                        onConfirm: () async {
                          Get.back();
                          Get.back();
                          cc.deletePostApi(postId);
                        },
                        isLoading: cc.deleteLoadingFlag(postId),
                      ),
                    ),
                  ],
                  child: SvgIconColored(
                    iconPath: IconsPath.moreVertical,
                    height: 20,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

// ─────────────────────────────
class _PostContent extends StatelessWidget {
  final AllPost postItem;
  const _PostContent({required this.postItem});

  @override
  Widget build(BuildContext context) {
    return Text(
      (postItem.content ?? '').cap,
      style: TxtStyle.outfit(fs: 14, w: 400),
    );
  }
}

// ─────────────────────────────
class _PostActions extends StatelessWidget {
  final Community communityData;
  final AllPost postItem;
  final String postId;
  final String userName;
  final MyCommunityBtnState btnState;

  const _PostActions({
    required this.postId,
    required this.btnState,
    required this.userName,
    required this.communityData,
    required this.postItem,
  });

  @override
  Widget build(BuildContext context) {
    final cc = CommunityDetailController.to;
    return Obx(() {
      // ✅ _ensureFlags guarantees a valid RxBool — Obx always has a subscription
      final isLiked = cc.likeFlag(postId).value;

      final isLocked =
          (postItem.isCommentLocked ?? false) ||
          cc.commentLockFlag(postId).value;
      final canSeeLockedComment =
          ((btnState == MyCommunityBtnState.manage) &&
              (communityData.creator ?? '') == currentProfileId())
          ? true
          : false;

      //
      final post = cc.communityItemDetail.value.allPost?.firstWhere(
        (e) => e.id == postId,
      );

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CusGestureDetector(
            onTap: () => cc.toggleLikeApi(postId, userName),
            child: Row(
              children: [
                SvgIcon(
                  iconPath: isLiked
                      ? IconsPath.likeHeartFilled
                      : IconsPath.like,
                  height: 22,
                ),
                Gap(4),
                TextFit(
                  "${post?.totalLike ?? 0} ${Strings.like}",
                  style: TxtStyle.outfitSmNor500,
                ),
              ],
            ),
          ),
          Gap(itemGap * 2),
          CusGestureDetector(
            onTap: () => isLocked && !canSeeLockedComment
                ? null
                : Get.toNamed(
                    RoutePaths.postDetails,
                    arguments: PostDetailArgModel(
                      communityData: communityData,
                      postItem: postItem,
                    ),
                  ),
            child: Row(
              children: [
                SvgIcon(iconPath: IconsPath.chatCircleOutlined, height: 22),
                Gap(4),
                TextFit(
                  "${postItem.totalComment ?? 0} ${Strings.comment}",
                  style: TxtStyle.outfitSmNor500,
                ),
                Gap(4),
                isLocked
                    ? SvgIcon(iconPath: IconsPath.lock, height: 12)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────
class PostItemShimmer extends StatelessWidget {
  const PostItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 12,
      hp: 12,
      hasBrdr: true,
      brdrClr: c.inputBorder.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerWidget.circular(width: 40, height: 40),
                  const Gap(8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectangular(height: 10, width: 100),
                      const Gap(6),
                      ShimmerWidget.rectangular(height: 8, width: 60),
                    ],
                  ),
                ],
              ),
              ShimmerWidget.circular(width: 20, height: 20),
            ],
          ),

          const Gap(16),

          ShimmerWidget.rectangular(height: 10, width: double.infinity),
          const Gap(6),
          ShimmerWidget.rectangular(height: 10, width: double.infinity),
          const Gap(6),
          ShimmerWidget.rectangular(height: 10, width: 200),

          const Gap(20),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerWidget.circular(width: 20, height: 20),
              const Gap(6),
              ShimmerWidget.rectangular(height: 10, width: 40),
              const Gap(20),
              ShimmerWidget.circular(width: 20, height: 20),
              const Gap(6),
              ShimmerWidget.rectangular(height: 10, width: 60),
            ],
          ),
        ],
      ),
    );
  }
}
