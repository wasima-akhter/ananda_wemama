import 'package:we_mama/core/components/ui/feedback/ui_state/ui_state_card.dart';
import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/core/helpers/date_helper.dart';
import 'package:we_mama/core/helpers/string_helper.dart';
import 'package:we_mama/features/main_nav/controller/main_nav_controller.dart';
import 'package:we_mama/features/main_tabs/home/controller/home_controller.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../main_tabs/home/model/community_spotlight_model.dart';

class CommunitySpotlight extends StatelessWidget {
  final bool? isFromOnboardScreen;
  const CommunitySpotlight({super.key, this.isFromOnboardScreen});

  @override
  Widget build(BuildContext context) {
    if (isFromOnboardScreen == true) return const _CommunitySpotlightDummy();
    return const _CommunitySpotlightLive();
  }
}

// ─────────────────────────────
// 🔹 Dummy (Onboard Preview)
// ─────────────────────────────
class _CommunitySpotlightDummy extends StatelessWidget {
  const _CommunitySpotlightDummy();

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 10,
      hp: 10,
      boxShadow: boxShadowBottom(),
      contClr: newCardClr,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                child: Text(
                  Strings.communitySpotlight.capEachWord(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TxtStyle.outfitSemiB(fs: 18),
                ),
              ),
              Gap(itemGap * 1.5),
              ContainerBordered(
                hasBrdr: true,
                contClr: c.inputBackground,
                rad: 18,
                vp: 5,
                hp: 8,
                child: Text(
                  Strings.joinDiscussion.capEachWord(),
                  style: 12.titleMclrCusFSURB,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StackOfImages(),
              Gap(itemGap),
              Text("42 ${Strings.mumsAreDiscussingThis}", style: normRsmSecURB),
            ],
          ),
          Gap(itemGap),
          ContainerBordered(
            hp: 10,
            vp: 10,
            contClr: c.cardMood,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.emotionalPostpartumQuestion.capEachWord(),
                  style: normRsmPriURB,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.postpartumRecovery.capEachWord(),
                      style: titleBPriURB,
                    ),
                    Text(Strings.comments, style: normRsmPriURB),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────
// 🔹 Live (Real Data)
// ─────────────────────────────
class _CommunitySpotlightLive extends StatelessWidget {
  const _CommunitySpotlightLive();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hc = Get.find<HomeController>();
      final spotlightData = hc.spotLightData.value?.communitySpotlight;
      final isEmpty =
          spotlightData == null || (spotlightData.id ?? '').trim().isEmpty;
      final isLoading = hc.isSpotLightLoading_.value;
      final state = getUIStateDetail(isLoading: isLoading);
      final totalMembers = (spotlightData?.totalMember ?? 0).toString();
      final lastPostData = spotlightData?.lastPost;
      final commId = spotlightData?.id ?? '';
      final communityname = spotlightData?.name ?? '';

      print('lastPostData: $lastPostData');

      return UIStateHandler(
        loading: () => const CommunitySpotlightShimmer(),
        state: state,
        data: () {
          if (isEmpty) {
            return const _CommunitySpotlightEmpty();
          }

          return ContainerBordered(
            vp: 10,
            hp: 10,
            boxShadow: boxShadowBottom(),
            contClr: newCardClr,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        Strings.communitySpotlight.capEachWord(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TxtStyle.outfitSemiB(fs: 18),
                      ),
                    ),
                    Gap(itemGap * 1.5),
                    Opacity(
                      opacity: commId.trim().isEmpty ? 0.5 : 1,
                      child: IgnorePointer(
                        ignoring: commId.trim().isEmpty,
                        child: CusGestureDetector(
                          onTap: () {
                            Get.toNamed(
                              RoutePaths.communityDetail,
                              arguments: {
                                "btnState": MyCommunityBtnState.visit,
                                "communityItemId": commId,
                              },
                            );
                          },
                          child: ContainerBordered(
                            hasBrdr: true,
                            contClr: c.inputBackground,
                            rad: 18,
                            vp: 5,
                            hp: 8,
                            child: Text(
                              Strings.joinDiscussion.capEachWord(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: 12.titleMclrCusFSURB,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(2),
                if (spotlightData.totalMember != 0)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StackOfImages(),
                      Gap(itemGap * 2),

                      Expanded(
                        child: Container(
                          // color: Colors.amber,
                          child: Text(
                            "$totalMembers ${(spotlightData.totalMember ?? 0) > 1 ? Strings.mumsAreDiscussingThis : Strings.mumIsDiscussingThis}",
                            style: titleSmBPriURB,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Be the first mum to join this discussion!",
                        style: titleSmBPriURB,
                      ),
                    ],
                  ),
                Gap(itemGap),
                CommunitySpotlightInsideCard(
                  communityname: communityname,
                  key: ValueKey(
                    '${lastPostData?.id}_${lastPostData?.createdAt}',
                  ),
                  lastPostData: lastPostData,
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class StackOfImages extends StatelessWidget {
  final int? numOfImage;
  const StackOfImages({super.key, this.numOfImage});

  @override
  Widget build(BuildContext context) {
    const double radius = 15;
    const double overlap = 24;
    return SizedBox(
      width: (radius * 2) + (overlap * 2), // total visual width
      height: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: List.generate(numOfImage ?? 3, (index) {
          return Positioned(
            left: index * overlap,
            child: _buildImage(radius: radius),
          );
        }),
      ),
    );
  }

  Widget _buildImage({String? path, double? radius}) {
    return circledImageBgComponent(radius: radius, imagePath: path);
  }
}

class CommunitySpotlightInsideCard extends StatelessWidget {
  final LastPost? lastPostData;
  final String? communityname;
  const CommunitySpotlightInsideCard({
    super.key,
    this.lastPostData,
    this.communityname,
  });

  @override
  Widget build(BuildContext context) {
    if (lastPostData == null) {
      return ContainerBordered(
        hp: 10,
        vp: 10,
        contClr: cardBgDeep,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No discussion started yet.",
              style: TxtStyle.urbanistSemiB(
                fs: 12,
                w: 600,
                color: c.foregroundPrimary,
              ),
            ),

            Gap(6),

            Text(
              "Be the first to share a thought with this community.",
              style: TxtStyle.urbanist(
                fs: 11,
                w: 400,
                color: c.foregroundSecondary,
              ),
            ),

            Gap(10),

            Text(
              (communityname ?? '--').capEachWord(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleBPriURB,
            ),
          ],
        ),
      );
    }

    final content = lastPostData?.content ?? '';
    final totalComment = (lastPostData?.totalComment ?? 0).toString();
    final createdAt = DateHelper()
        .formatTimeAgo((lastPostData?.createdAt ?? '').toString())
        .date;
    return ContainerBordered(
      hp: 10,
      vp: 10,

      contClr: cardBgDeep,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.isNotEmpty) ...[
            Text(
              content.cap,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.urbanistSemiB(
                fs: 13,
                w: 600,
                color: c.foregroundPrimary,
              ),
            ),
            Gap(4),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  (communityname ?? '--').capEachWord(),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: titleBPriURB,
                ),
              ),
              Text(
                "$totalComment ${Strings.comments} | $createdAt",
                style: TxtStyle.urbanistSemiB(
                  fs: 12,
                  w: 600,
                  color: c.foregroundPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommunitySpotlightShimmer extends StatelessWidget {
  const CommunitySpotlightShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 10,
      hp: 10,
      boxShadow: boxShadowBottom(),
      contClr: c.cardOngoing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerWidget.rectangular(width: 140, height: 18),

              ShimmerWidget.rectangular(
                width: 110,
                height: 34,
                shimmerClr: c.inputBorder,
              ),
            ],
          ),

          const Gap(12),

          /// Avatar Stack + Text
          Row(
            children: [
              Row(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                    child: const ShimmerWidget.circular(width: 28, height: 28),
                  ),
                ),
              ),

              const Gap(10),

              const ShimmerWidget.rectangular(width: 130, height: 14),
            ],
          ),

          const Gap(12),

          /// Inner Spotlight Card Placeholder
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerWidget.rectangular(
                width: double.infinity,
                height: 120,
              ),

              const Gap(10),

              const ShimmerWidget.rectangular(width: 180, height: 16),

              const Gap(8),

              const ShimmerWidget.rectangular(
                width: double.infinity,
                height: 14,
              ),

              const Gap(6),

              const ShimmerWidget.rectangular(width: 220, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommunitySpotlightEmpty extends StatelessWidget {
  const _CommunitySpotlightEmpty();

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 10,
      hp: 10,
      boxShadow: boxShadowBottom(),
      contClr: newCardClr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  Strings.communitySpotlight.capEachWord(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TxtStyle.outfitSemiB(fs: 18),
                ),
              ),
              Gap(itemGap * 1.5),
              CusGestureDetector(
                onTap: () {
                  MainNavController.to.goToTab(3);
                },
                child: ContainerBordered(
                  hasBrdr: true,
                  contClr: Colors.transparent,
                  rad: 18,
                  vp: 4,
                  hp: ScreenSizeX.isTablet ? 4 : 5,
                  child: Text(
                    "Explore Communities",
                    style: (ScreenSizeX.isTablet ? 10 : 11).titleMclrCusFSURB
                        .copyWith(color: c.primary),
                  ),
                ),
              ),
            ],
          ),

          const Gap(12),

          /// HERO IMAGE
          SafeAssetImage(
            radius: 14,
            assetPath: Assets.images.spotlightPlaceholder.path,
            height: 170.h,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),

          const Gap(14),

          /// TITLE
          Text(
            "Find your village 🤎",
            style: TxtStyle.outfitSemiB(
              w: 600,
              color: c.foregroundSecondary,
              fs: 15,
            ),
          ),

          const Gap(6),

          /// DESCRIPTION
          Text(
            "Join one of our supportive communities to "
            "ask questions, share experiences, and "
            "connect with mums who truly understand.",
            style: TxtStyle.outfit(
              w: 500,
              color: c.foregroundSecondary,
              fs: 14,
            ),
          ),

          /// CTA
          // SizedBox(
          //   width: double.infinity,
          //   child: ContainerBordered(
          //     rad: 24,
          //     vp: 8,
          //     hp: 16,mv: 7
          //     contClr: c.primary,
          //     child: Center(
          //       child: Text(
          //         "Explore Communities",
          //         style: 14.titleMclrCusFSURB.copyWith(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

//
