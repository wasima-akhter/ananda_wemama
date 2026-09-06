import 'package:we_mama/core/components/ui/feedback/ui_state/ui_state_card.dart';
import 'package:we_mama/core/components/ui/loaders/empty_widget.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../../../gen/assets.gen.dart';
import '../../core/models/community_item_detail_model.dart';
import '../../post/widgets/post_item_widget.dart';
import '../../shared_ui/join_btn.dart';
import '../controller/community_detail_controller.dart';

class CommunityDetailsScreen extends StatelessWidget {
  const CommunityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cdc = CommunityDetailController.to;
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: cdc.onRefresh,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─────────────────────────────────────────
          // HEADER
          // ─────────────────────────────────────────
          Obx(() {
            final isLoading = cdc.isLoading;
            final itemDetail = cdc.communityItemDetail.value;

            final state = getUIStateDetail(isLoading: isLoading);

            return Stack(
              children: [
                UIStateHandler(
                  onRefresh: cdc.onRefresh,
                  state: state,
                  // error: () => CustomErrorWidget(
                  //   message: cdc.errorMessage.value,
                  //   onRetry: cdc.getCommunityDetail,
                  // ),
                  loading: () => const CommunityDetailTopShimmer(),
                  data: () => CommunityDetailTopContent(itemDetail: itemDetail),
                ),

                // Topbar
                Positioned(
                  top: itemGap,
                  right: 0,
                  left: 0,
                  child: CommunityTopbarContent(
                    suffix: cdc.showCommunityGuidelineButton
                        ? CusGestureDetector(
                            onTap: cdc.onTapCommunityInfo,
                            child: CusCircleIconButton(
                              radius: 15.r,
                              child: Icon(
                                color: c.primary,
                                Icons.info_outline_rounded,
                                size: 22.h,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            );
          }),

          Gap(itemGap * 2),

          // ─────────────────────────────────────────
          // POSTS
          // ─────────────────────────────────────────
          Obx(() {
            final isLoading = cdc.isLoading;
            final itemPosts = cdc.posts;
            final communityData = cdc.communityData;

            final state = getUIStateList(isLoading: isLoading, list: itemPosts);

            return UIStateHandler(
              onRefresh: cdc.onRefresh,
              state: state,

              loading: () => Column(
                children: List.generate(
                  5,
                  (index) => const PostItemShimmer().mB(itemGap),
                ),
              ).getcm,

              empty: () => EmptyNoSearchWidgetScrollable(
                isScrollable: false,
                assetPath: Assets.images.postPlaceholder.path,
                title: "Let’s get the conversation started!",
                subTitle:
                    "This community is waiting for its first post.\n"
                    "Why not start the conversation?",
              ).get10cm,

              data: () => Column(
                children: List.generate(itemPosts.length, (index) {
                  final post = itemPosts[index];

                  return PostItemWidget(
                    communityData: communityData,
                    postItem: post,
                    btnState: cdc.btnState.value,
                    postId: post.id.toString(),
                    userName: post.creator?.name ?? '',
                    postCreatorId: communityData.id ?? '',
                  ).mB(itemGap);
                }),
              ).getcm,
            );
          }),

          Gap(itemGap * 2),
        ],
      ),
    );
  }
}

class CommunityDetailTopContent extends StatelessWidget {
  final CommunityItemDetailModel itemDetail;

  const CommunityDetailTopContent({super.key, required this.itemDetail});

  @override
  Widget build(BuildContext context) {
    final cdc = CommunityDetailController.to;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkImageWidget(
          imageUrl: cdc.communityImage,
          width: double.infinity,
          height: S.h * 0.25,
          radius: 0,
          isUser: false,
          enablePreview: true,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: TextFit(
                            cdc.communityName.capEachWord(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 7,
                            style: TxtStyle.outfitSemiB(
                              fs: 18,
                              w: 500,
                              color: white,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            SvgIcon(iconPath: IconsPath.userGroup, height: 22),
                            Gap(4),

                            TextFit(
                              cdc.totalMembersText,
                              style: TxtStyle.outfit(
                                fs: 12,
                                w: 400,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Gap(itemGap),

                  Obx(
                    () => JoinBtn(
                      isLoading: cdc.isJoinLoading.value,
                      btnTxt: cdc.getBtnTxt(),
                      onTap: cdc.onTapJoinButton,
                    ),
                  ),
                ],
              ),

              Gap(itemGap * 3),

              CusGestureDetector(
                onTap: cdc.onTapWriteSomething,
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
            ],
          ).get10cm,
        ),
      ],
    );
  }
}

class CommunityDetailTopShimmer extends StatelessWidget {
  const CommunityDetailTopShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerWidget.rectangular(height: S.h * 0.25, width: double.infinity),

        ContainerBordered(
          rad: 0,
          vp: 12,
          hp: 0,
          contClr: c.secondary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.rectangular(height: 16, width: 150),
              const Gap(8),
              ShimmerWidget.rectangular(height: 12, width: 100),
            ],
          ).get10cm,
        ),
      ],
    );
  }
}

//
