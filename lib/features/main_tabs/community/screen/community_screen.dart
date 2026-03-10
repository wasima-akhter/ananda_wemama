import 'package:mama_app/core/common_widgets/common_components/small_outlined_btn.dart';
import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_scrollbar_widget.dart';
import '../../../../core/common_widgets/cus_search_bar.dart';
import '../controller/community_controller.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      isScrollable: false, // ← ADD THIS
      refreshKey: refreshKey,
      onRefresh: () async {
        print("communities refreshed");
      },
      appBar: CommonAppBarContent(
        title: Strings.community,
        hasBackNavArrow: false,

        suffix: CusGestureDetector(
          onTap: () {
            communityGuidlineDialog(
              isLoading: false,
              onTapAction: () async {
                Get.back();
                Get.toNamed(RoutePaths.createCommunity);
              },
            );
          },
          child: SvgIcon(iconPath: IconsPath.addPlus, height: 30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CusSearchBar(controller: cc.searchController),
          Gap(itemGap),

          TextFit(Strings.myCommunity, style: TxtStyle.outfitSmTitle),
          Gap(itemGap),

          Expanded(
            child: CusScrollbarWidget(
              controller: cc.myCommunityScrlCtrl,

              child: Column(
                children: [
                  ...List.generate(
                    10,
                    (index) => CommunityItem(
                      btnTxt: index < 2 ? Strings.manage : Strings.visit,
                      isLoading: false,
                      onTapItem: () => cc.onTapItem(
                        // ← item tap
                        index < 2 ? MyCommunityBtnState.manage : MyCommunityBtnState.visit,
                      ),
                      onTapItemBtn: () => cc.onTapItemBtn(
                        // ← button tap
                        index < 2 ? MyCommunityBtnState.manage : MyCommunityBtnState.visit,
                      ),
                    ).mB(itemGap),
                  ),
                ],
              ),
            ),
          ),

          Gap(itemGap * 2),

          TextFit(Strings.suggestedCommunity, style: TxtStyle.outfitSmTitle),
          Gap(itemGap),
          Expanded(
            child: CusScrollbarWidget(
              controller: cc.suggCommunityScrlCtrl,
              child: Column(
                children: [
                  ...List.generate(
                    10,
                    (index) => // suggested list:
                    CommunityItem(
                      btnTxt: Strings.join,
                      isLoading: false,
                      onTapItem: () => cc.onTapItem(MyCommunityBtnState.join), // ← item tap
                      onTapItemBtn: () => cc.onTapItemBtn(MyCommunityBtnState.join), // ← button tap
                    ).mB(itemGap),
                  ),
                ],
              ),
            ),
          ),
        ],
      ).getcm,
    );
  }
}

class CommunityItem extends StatelessWidget {
  final void Function()? onTapItemBtn;
  final void Function()? onTapItem;
  final bool isLoading;
  final String btnTxt;
  const CommunityItem({
    super.key,
    this.onTapItemBtn,
    required this.isLoading,
    required this.btnTxt,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    final stats = ["32", "656"];

    return CusGestureDetector(
      onTap: onTapItem,
      child: ContainerBordered(
        vp: 12,
        hp: 12,
        hasBrdr: true,
        brdrClr: c.inputBorder.withOpacity(0.3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Make the text column expand naturally
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFit(
                    "Lagos Single Mom's Community dfgv dydfvb uhdfbvu dfgvy df",
                    style: TxtStyle.outfitSmTitle,
                  ),

                  Gap(6),

                  Row(
                    children: List.generate(stats.length, (index) {
                      final text = index == 0 ? "New post" : "Members";
                      return Padding(
                        padding: EdgeInsets.only(right: index == stats.length - 1 ? 0 : 12.w),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 4.r, backgroundColor: c.primary),
                            Gap(4),
                            Text("${stats[index]} $text", style: TxtStyle.outfitSmSecNor),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            Gap(12),

            SmallOutlinedBtn(isLoading: isLoading, btnTxt: btnTxt, onTap: onTapItemBtn),
          ],
        ),
      ),
    );
  }
}
// Manage

//
