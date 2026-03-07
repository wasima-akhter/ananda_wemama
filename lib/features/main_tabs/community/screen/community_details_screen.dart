import 'package:mama_app/core/common_widgets/popups.dart';
import 'package:mama_app/features/main_tabs/community/controller/community_detail_controller.dart';
import 'package:mama_app/features/main_tabs/community/modules/join_btn.dart';

import '../../../../app/helper_widgets_export.dart';
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
          Stack(
            children: [
              Positioned(
                top: itemGap * 5,
                right: 0,
                left: 0,
                child: CommunityTopbarContent(
                  suffix: CusGestureDetector(
                    onTap: () {
                      communityGuidlineDialog(isLoading: false, onTapAction: () async {});
                    },
                    child: CusCircleIconButton(
                      radius: 15.r,
                      child: SvgIcon(iconPath: IconsPath.info, height: 30),
                    ),
                  ),
                ),
              ),
              //
              Column(
                // ← Remove Flexible wrapper, AppScreenTemplate handles it via Expanded
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(itemGap * 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NetworkImageWidget(
                        imageUrl: Strings.fakeImageUrl,
                        width: double.infinity,
                        height: S.h * 0.2,
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
                                JoinBtn(isLoading: false, btnTxt: Strings.join),
                              ],
                            ),
                            Gap(itemGap * 3),
                            // post section:
                            CusNameTypeTextFormField(
                              controller: cc.postCtrl,
                              hintText: Strings.writeSomething,
                            ),
                          ],
                        ).get10cm,
                      ),
                    ],
                  ),

                  Gap(itemGap * 2),

                  // ── Posts list (scrollable, takes remaining space) ──
                  Column(
                    children: [...List.generate(10, (index) => _PostItem().mB(itemGap))],
                  ).getcm,
                  Gap(itemGap * 2),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostItem extends StatelessWidget {
  const _PostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 12,
      hp: 12,
      hasBrdr: true,
      brdrClr: c.inputBorder.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //row of user data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  NetworkImageWidget(imageUrl: Strings.fakeImageUrl, isCircle: true, radius: 25),

                  Gap(itemGap * 1.5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFit("Username, 30", style: TxtStyle.outfitSmNor500),

                      Row(
                        children: [
                          SvgIcon(iconPath: IconsPath.locationBold, height: 16),
                          TextFit("Lagos", style: TxtStyle.outfitxSmNor500),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              CusGestureDetector(
                onTap: () async {
                  await showReportBottomSheet();
                  print("object");
                },
                child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
              ),
            ],
          ),

          Gap(itemGap * 2),

          // text of post
          Text(
            "Is it normal for my 2-month-old to want to feed every hour at night? I feel exhausted and keep wondering if I'm doing something wrong 😔",
            style: TxtStyle.outfit(fs: 13, w: 400),
          ),

          Gap(itemGap * 2.5),

          // row of like comment
          Row(
            children: [
              Row(
                children: [
                  SvgIcon(iconPath: IconsPath.heartOutlined, height: 22),
                  Gap(4),
                  TextFit(Strings.like, style: TxtStyle.outfitSmNor500),
                ],
              ),
              Gap(itemGap * 2),
              Row(
                children: [
                  SvgIcon(iconPath: IconsPath.chatCircleOutlined, height: 22),
                  Gap(4),
                  CusGestureDetector(
                    onTap: () async {
                      await showCommentsBottomSheet();
                      print("object");
                    },
                    child: TextFit(Strings.comment, style: TxtStyle.outfitSmNor500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//
