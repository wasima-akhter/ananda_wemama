import 'package:mama_app/core/components/ui/dialogs/popups.dart';
import 'package:mama_app/core/components/ui/feedback/ui_state/ui_state_card.dart';
import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';
import 'package:mama_app/features/main_tabs/community/controller/community_detail_controller.dart';
import 'package:mama_app/features/main_tabs/community/model/community_item_detail_model.dart';
import 'package:mama_app/features/main_tabs/community/widgets/post_item_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';

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
        cc.getCommunityDetail();
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header with overlaid topbar ──
          Stack(
            children: [
              // ── Base content ──
              Obx(() {
                final isLoading = cc.isLoading_.value;
                final itemDetail = cc.communityItemDetail.value;

                final state = getUIStateDetail(isLoading: isLoading);

                debugPrint('itemDetail  : ${itemDetail.community?.name} ');

                return UIStateHandler(
                  onRefresh: () async {
                    cc.getCommunityDetail();
                  },
                  state: state,
                  loading: () => Column(
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
                  ),

                  data: () => CommunityDetailTopContent(itemDetail: itemDetail),
                );

                // your real header
              }),

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
          Obx(() {
            final isLoading = cc.isLoading_.value;
            final itemDetail = cc.communityItemDetail.value;
            final itemPosts = itemDetail.allPost ?? [];

            final state = getUIStateList(isLoading: isLoading, list: itemPosts);

            debugPrint('itemDetail  : ${itemDetail.community?.name} ');

            return UIStateHandler(
              onRefresh: () async {
                cc.getCommunityDetail();
              },
              state: state,
              loading: () => Column(
                children: List.generate(5, (index) => const PostItemShimmer().mB(itemGap)),
              ).getcm,
              empty: () => const EmptyWidget(title: "No Posts yet"),

              data: () => Column(
                children: List.generate(
                  itemPosts.length,
                  (index) =>
                      // Text("data")
                      PostItemWidget(
                        postItem: itemPosts[index],
                        cc: cc,
                        btnState: cc.args.value,
                        postId: itemPosts[index].id.toString(),
                      ).mB(itemGap),
                ),
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
    final community = itemDetail.community;
    final communityName = community?.name ?? '';
    final membersNum = (community?.totalMember ?? 0).toString();
    final communityImg = community?.image ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkImageWidget(
          imageUrl: communityImg,
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
                        communityName.capEachWord(),
                        style: TxtStyle.outfitSemiB(fs: 18, w: 500, color: white),
                      ),
                      Row(
                        children: [
                          SvgIcon(iconPath: IconsPath.userGroup, height: 22),
                          Gap(4),
                          TextFit(
                            "${Strings.members.capEachWord()} $membersNum",
                            style: TxtStyle.outfit(fs: 12, w: 400, color: white),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // wrap JoinBtn with Obx
                  // Obx(
                  //   () => JoinBtn(
                  //     isLoading: false,

                  //     onTap: () {
                  //       if (cc.args.value == MyCommunityBtnState.manage) {
                  //         Get.toNamed(RoutePaths.manageCommunity);
                  //       }
                  //       if (cc.args.value == MyCommunityBtnState.join) {
                  //         communityGuidlineDialog(
                  //           isLoading: false,
                  //           onTapAction: () async {
                  //             Get.back();
                  //             // Get.toNamed(
                  //             //   RoutePaths.communityDetail,
                  //             //   arguments: {
                  //             //     'btnState': MyCommunityBtnState.join,
                  //             //     "communityItemId": "123",
                  //             //   },
                  //             // );
                  //           },
                  //         );
                  //       }
                  //     },
                  //     btnTxt: cc.getBtnTxt(),
                  //   ),
                  // ),
                ],
              ),
              Gap(itemGap * 3),

              CusGestureDetector(
                onTap: () {
                  Get.toNamed(RoutePaths.postInCommunity, arguments: community?.id ?? '');
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
    );
  }
}
 
 //