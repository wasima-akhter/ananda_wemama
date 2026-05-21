import 'package:mama_app/core/components/ui/dialogs/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../core/components/ui/scroll/cus_scrollbar_widget.dart';
import '../controller/community_controller.dart';
import '../widgets/community_item.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityController>();

    return AppScreenTemplate(
      appBar: _buildAppBar(),
      isScrollable: false,
      child: Column(
        children: [
          // ── Sticky tab bar ──────────────────────────────────────────
          Obx(() {
            final selTab = cc.selTab.value;
            return Row(
              children: [
                _buildTabItem(
                  title: Strings.myCommunity,
                  isSelected: selTab == CommunityTab.myCommunities,
                  onTap: () => cc.changeTab(CommunityTab.myCommunities),
                ),
                Gap(itemGap),
                _buildTabItem(
                  title: Strings.manage,
                  isSelected: selTab == CommunityTab.manage,
                  onTap: () => cc.changeTab(CommunityTab.manage),
                ),
              ],
            ).getcm;
          }),

          Gap(itemGap * 0.5),

          // ── Scrollable content per tab ──────────────────────────────
          Obx(() {
            final isJoinedLoading = cc.isJoinedCommunityLoading_.value;
            final displayListJoined = cc.joinedCommunityList;

            final uiStateMyCommunities = getUIStateList(
              isLoading: isJoinedLoading,
              list: displayListJoined,
            );

            final isManagedLoading = cc.isManagedCommunityLoading_.value;
            final displayListManaged = cc.managedCommunityList;

            final uiStateManaged = getUIStateList(
              isLoading: isManagedLoading,
              list: displayListManaged,
            );

            final selTab = cc.selTab.value;

            return selTab == CommunityTab.myCommunities
                ? Expanded(
                    child: UIStateHandler(
                      onRefresh: () async {
                        await cc.getMyCommunityList();
                      },
                      state: uiStateMyCommunities,

                      loading: () => CusScrollbarWidget(
                        controller: cc.myCommunityScrlCtrl,
                        child:
                            //  ListView.builder(itemCount: 10, itemBuilder: (context, index) => Text("data")),
                            ListView.separated(
                              controller: cc.myCommunityScrlCtrl,
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: EdgeInsets.only(bottom: itemGap * 2),
                              itemCount: 10,
                              separatorBuilder: (_, _) => Gap(itemGap * 0.6),
                              itemBuilder: (_, index) => CommunityItemShimmer(),
                            ).getcm,
                      ),

                      empty: () => const EmptyNoSearchWidgetScrollable(
                        title: "No Communities yet",
                      ).getcm,

                      data: () => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _CommunityListView(
                          key: const ValueKey(CommunityTab.myCommunities),
                          scrollController: cc.myCommunityScrlCtrl,
                          itemCount: displayListJoined.length,
                          itemBuilder: (index) => CommunityItem(
                            item: displayListJoined[index],
                            btnTxt: Strings.visit,
                            isLoading: false,
                            onTapItem: () => cc.onTapItem(
                              btnState: MyCommunityBtnState.visit,
                              communityItemId:
                                  displayListJoined[index].id ?? '',
                            ),
                            onTapItemBtn: () => cc.onTapItemBtn(
                              btnState: MyCommunityBtnState.visit,
                              communityItemId:
                                  displayListJoined[index].id ?? '',
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: UIStateHandler(
                      onRefresh: () async {
                        await cc.getManagedCommunityList();
                      },
                      state: uiStateManaged,

                      loading: () => CusScrollbarWidget(
                        controller: cc.manageCommunityScrlCtrl,
                        child:
                            //  ListView.builder(itemCount: 10, itemBuilder: (context, index) => Text("data")),
                            ListView.separated(
                              controller: cc.manageCommunityScrlCtrl,
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: EdgeInsets.only(bottom: itemGap * 2),
                              itemCount: 10,
                              separatorBuilder: (_, _) => Gap(itemGap * 0.6),
                              itemBuilder: (_, index) => CommunityItemShimmer(),
                            ).getcm,
                      ),

                      empty: () => const EmptyNoSearchWidgetScrollable(
                        title: "No Communities yet",
                      ).getcm,

                      data: () => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _CommunityListView(
                          key: const ValueKey(CommunityTab.manage),
                          scrollController: cc.manageCommunityScrlCtrl,
                          itemCount: displayListManaged.length,
                          itemBuilder: (index) => CommunityItem(
                            item: displayListManaged[index],
                            btnTxt: Strings.manage,
                            isLoading: false,
                            onTapItem: () => cc.onTapItem(
                              btnState: MyCommunityBtnState.manage,
                              communityItemId:
                                  displayListManaged[index].id ?? '',
                            ),
                            onTapItemBtn: () => cc.onTapItemBtn(
                              btnState: MyCommunityBtnState.manage,
                              communityItemId:
                                  displayListManaged[index].id ?? '',
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBarContent(
      title: Strings.community,
      hasBackNavArrow: false,
      suffix: Row(
        children: [
          CusGestureDetector(
            onTap: () => Get.toNamed(RoutePaths.communitySearch),
            child: SvgIcon(iconPath: IconsPath.search, height: 25),
          ),
          Gap(itemGap * 1.5),
          CusGestureDetector(
            onTap: () => communityGuidlineDialog(
              isLoading: false,
              onTapAction: () async {
                Get.back();
                Get.toNamed(RoutePaths.createCommunity);
              },
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContainerBordered(
                  rad: 8,
                  vp: 2,
                  hp: 2,
                  contClr: c.primary,
                  child: SvgIconColored(
                    iconPath: IconsPath.addPlus,
                    iconColor: white,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
}

// ── Scrollable list with scrollbar ─────────────────────────────────────────────
class _CommunityListView extends StatelessWidget {
  final ScrollController scrollController;
  final int itemCount;
  final CommunityItem Function(int index) itemBuilder;

  const _CommunityListView({
    super.key,
    required this.scrollController,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CusScrollbarWidget(
      controller: scrollController,
      child:
          //  ListView.builder(itemCount: 10, itemBuilder: (context, index) => Text("data")),
          ListView.separated(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.only(bottom: itemGap * 2),
            itemCount: itemCount,
            separatorBuilder: (_, _) => Gap(itemGap * 0.6),
            itemBuilder: (_, index) => itemBuilder(index).getcm,
          ),
    );
  }
}

// ── Tab item ───────────────────────────────────────────────────────────────────
Widget _buildTabItem({
  required String title,
  required bool isSelected,
  void Function()? onTap,
}) {
  final selClr = c.primary;
  final unselClr = c.inputBackground;
  final selTxtClr = white;
  final unselTxtClr = c.primary;

  return CusGestureDetector(
    onTap: onTap,
    child: ContainerBordered(
      rad: 8,
      hp: 12,
      vp: 6,
      hasBrdr: isSelected ? null : true,
      contClr: isSelected ? selClr : unselClr,
      child: TextFit(
        title,
        style: TxtStyle.outfitSemiB(
          fs: 14,
          w: 500,
          color: isSelected ? selTxtClr : unselTxtClr,
        ),
      ),
    ),
  );
}

Widget buildCommunityListNoScroll({
  required ScrollController scrollController,
  required int itemCount,
  required CommunityItem Function(int index) itemBuilder,
}) {
  return Column(
    children: List.generate(
      12,
      (index) => itemBuilder(index).getcm.mB(itemGap * 0.5),
    ),
  );
  //  CusScrollbarWidget(
  //   controller: scrollController,
  //   child: Column(children: List.generate(itemCount, (index) => itemBuilder(index).mB(itemGap))),
  // );
}

//
// Manage

//
