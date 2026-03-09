import 'package:mama_app/core/common_widgets/popups.dart';
import 'package:mama_app/features/main_tabs/community/controller/community_detail_controller.dart';
import 'package:mama_app/features/main_tabs/community/modules/join_btn.dart';
import 'package:mama_app/features/main_tabs/community/modules/user_short_detail_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_flexible_dropdown.dart';
import '../../../../core/helpers/widgets_helper.dart';

class CommunityDetailsScreen extends StatelessWidget {
  const CommunityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityDetailController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async {
        print("communities refreshed");
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header with overlaid topbar ──
          Stack(
            children: [
              // ── Base content ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NetworkImageWidget(
                    imageUrl: Strings.fakeImageUrl,
                    width: double.infinity,
                    height: S.h * 0.25,
                    radius: 0,
                  ),
                  ContainerBordered(
                    rad: 0,
                    vp: 12,
                    hp: 0,
                    contClr: c.secondary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFit(
                                  "lagos Mom's Community".capEachWord(),
                                  style: TxtStyle.outfitSemiB(fs: 18, w: 500, color: white),
                                ),
                                Row(
                                  children: [
                                    SvgIcon(iconPath: IconsPath.userGroup, height: 22),
                                    Gap(4),
                                    TextFit(
                                      "${Strings.members.capEachWord()} 2.5K",
                                      style: TxtStyle.outfit(fs: 12, w: 400, color: white),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // wrap JoinBtn with Obx
                            Obx(
                              () => JoinBtn(
                                isLoading: false,

                                onTap: () {
                                  if (cc.args.value == MyCommunityBtnState.manage) {
                                    Get.toNamed(RoutePaths.manageCommunity);
                                  }
                                  if (cc.args.value == MyCommunityBtnState.join) {
                                    communityGuidlineDialog(
                                      isLoading: false,
                                      onTapAction: () async {
                                        Get.back();
                                        Get.toNamed(
                                          RoutePaths.communityDetail,
                                          arguments: MyCommunityBtnState.join,
                                        );
                                      },
                                    );
                                  }
                                },
                                btnTxt: cc.getBtnTxt(),
                              ),
                            ),
                          ],
                        ),
                        Gap(itemGap * 3),

                        CusGestureDetector(
                          onTap: () {
                            Get.toNamed(RoutePaths.postInCommunity);
                          },
                          child: ContainerBordered(
                            rad: 30,
                            contClr: bgClr,
                            vp: 10,
                            hp: 14,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Strings.writeSomething.capEachWord(),
                              style: TxtStyle.outfit(color: c.secondary, fs: 12),
                            ),
                          ),
                        ),

                        //   CusNameTypeTextFormField(
                        //   controller: cc.postCtrl,
                        //   hintText: Strings.writeSomething,
                        // ),
                      ],
                    ).get10cm,
                  ),
                ],
              ),

              // ── Topbar overlaid on top of image ──
              Positioned(
                top: itemGap,
                right: 0,
                left: 0,
                child: CommunityTopbarContent(
                  suffix: CusGestureDetector(
                    onTap: () =>
                        communityGuidlineDialog(isLoading: false, onTapAction: () async {}),
                    child: CusCircleIconButton(
                      radius: 15.r,
                      child: SvgIcon(iconPath: IconsPath.info, height: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Gap(itemGap * 2),

          // ── Posts ──
          Obx(
            () => Column(
              children: List.generate(
                cc.posts.length,
                (index) => _PostItem(
                  btnState: cc.args.value,
                  postId: cc.posts[index].id, // ← pass postId
                ).mB(itemGap),
              ),
            ).getcm,
          ),

          Gap(itemGap * 2),
        ],
      ),
    );
  }
}

class _PostItem extends StatelessWidget {
  final MyCommunityBtnState btnState;
  final int postId; // ← add
  const _PostItem({super.key, required this.btnState, required this.postId});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityDetailController>(); // ← find here

    return ContainerBordered(
      vp: 12,
      hp: 12,
      hasBrdr: true,
      brdrClr: c.inputBorder.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserShortDetailWidget(),

              Row(
                children: [
                  // at top of post content, after the user row
                  Obx(() {
                    final isPinned = cc.posts.firstWhere((p) => p.id == postId).isPinned.value;
                    if (!isPinned) return const SizedBox.shrink();
                    return SvgIcon(iconPath: IconsPath.smallTickBold, height: 22);
                  }),

                  ///
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
                            title: cc.getPinBtnTxt(postId), // ← reactive pin text
                            onTap: () async {
                              cc.togglePin(postId); // ← toggle pin
                            },
                          ),
                          CusDropdownItem(
                            title: cc.getLockBtnTxt(postId),
                            onTap: () async {
                              showLockCommentialog();
                              Future.delayed(Duration(seconds: 1));
                              Get.back();
                              cc.toggleCommentLock(postId);
                            },
                          ),
                          CusDropdownItem(
                            title: Strings.deletePost.capEachWord(),
                            onTap: () async {
                              deletePostConfirmDialog(
                                onConfirm: () async => Get.back(),
                                isLoading: RxBool(false),
                              );
                            },
                          ),
                        ],
                        child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
                      ),
                    ),
                ],
              ),
            ],
          ),

          Gap(itemGap * 2),

          Text(
            "Is it normal for my 2-month-old to want to feed every hour at night? I feel exhausted and keep wondering if I'm doing something wrong 😔",
            style: TxtStyle.outfit(fs: 13, w: 400),
          ),

          Gap(itemGap * 2.5),

          // ── Like & Comment row ──
          Obx(() {
            final post = cc.posts.firstWhere((p) => p.id == postId);
            return Row(
              children: [
                CusGestureDetector(
                  onTap: () => cc.toggleLike(postId),
                  child: Row(
                    children: [
                      // ← swap icon based on isLiked
                      SvgIcon(
                        iconPath: post.isLiked.value
                            ? IconsPath
                                  .likeHeartFilled // ← filled
                            : IconsPath.like, // ← outlined
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
                      onTap: () async => await showCommentsBottomSheet(postId: postId),
                      child: TextFit(Strings.comment, style: TxtStyle.outfitSmNor500),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

//
