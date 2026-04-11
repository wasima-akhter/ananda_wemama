import 'package:mama_app/core/components/ui/dialogs/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../../../../core/components/ui/scroll/cus_scrollbar_widget.dart';
import '../controller/community_controller.dart';
import '../widgets/community_item.dart';
/*
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityController>();

    return AppScreenTemplate(
      isScrollable: true,
      resizeToAvoidBottomInset: false,
      onRefresh: () async {},
      appBar: _buildAppBar(),
      child:
          //  Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Text("data"),
          //     Expanded(child: Text("dhfvhdbf")),
          //   ],
          // ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CusSearchBar(
                rad: 12,
                controller: cc.searchController,
                focusNode: cc.searchFocus,

                onEditingComplete: () {
                  // show the searched tag , and on clearing that tag, show the previous contents
                  cc.showSearchedTag.value = true;
                  cc.searchedTxt.value = cc.searchController.text; // ← set
                  cc.clearAll();
                  //
                  debugPrint(' search editing complete with query: ${cc.searchController.text} ');
                  cc.unFocusAll();
                },
              ).getcm,
              Gap(itemGap),

              // Container(
              //   color: Colors.amber,
              //   child: Column(
              //     children: [
              //       Column(
              //         children: [
              //           ListView.builder(
              //             shrinkWrap: true,
              //             // controller: scrollController,
              //             physics: const BouncingScrollPhysics(),
              //             itemCount: 10,
              //             itemBuilder: (context, index) {
              //               return Container(
              //                 height: 50,
              //                 color: Colors.primaries[index % Colors.primaries.length],
              //                 child: Center(child: Text("Item $index")),
              //               );
              //             },
              //           ),
              //         ],
              //       ),

              //       Text("data"),
              //     ],
              //   ),
              // ),
              Obx(() {
                final showTag = cc.showSearchedTag.value;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),

                  child: showTag
                      ?
                        //  Text("data")
                        _buildSearchResultList(cc) // ✅ SHOW SEARCH RESULTS
                      : _buildDefaultContent(cc), // ✅ SHOW NORMAL UI
                );
              }),
            ],
          ),
    );
  }

  Widget _buildSearchResultList(CommunityController cc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey("search"),

      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: c.primary, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFit(
                cc.searchedTxt.value,
                style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: white),
              ),
              Gap(8),
              CusGestureDetector(
                onTap: () {
                  cc.showSearchedTag.value = false;
                  cc.clearAll();
                },
                child: Icon(Icons.close, size: 16, color: white),
              ),
            ],
          ),
        ).getcm,
        Gap(itemGap),

        /// fake results (you will replace later)
        Expanded(
          child: buildCommunityList(
            scrollController: cc.myCommunityScrlCtrl,
            itemCount: 5,
            itemBuilder: (index) => CommunityItem(
              bgClr: c.inputBackground,
              btnTxt: "Join",
              isLoading: false,
              onTapItem: () {},
              onTapItemBtn: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultContent(CommunityController cc) {
    return Column(
      key: const ValueKey("default"),

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // tabs
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

        Gap(itemGap),

        // tab content
        Obx(() {
          return cc.selTab.value == CommunityTab.myCommunities
              ? Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: buildCommunityList(
                          scrollController: cc.myCommunityScrlCtrl,
                          itemCount: 14,
                          itemBuilder: (index) => CommunityItem(
                            btnTxt: index < 2 ? Strings.manage : Strings.visit,
                            isLoading: false,
                            onTapItem: () {},
                            onTapItemBtn: () {},
                          ),
                        ),
                      ),

                      Gap(itemGap),

                      /// keyboard hide suggestion
                      Obx(() {
                        return cc.isKeyboardOpen.value
                            ? const SizedBox.shrink()
                            : SuggestedCommunitySection(cc: cc);
                      }),
                    ],
                  ),
                )
              : Expanded(
                  child: buildCommunityList(
                    scrollController: cc.manageCommunityScrlCtrl,
                    itemCount: 10,
                    itemBuilder: (index) => CommunityItem(
                      btnTxt: index < 2 ? Strings.manage : Strings.visit,
                      isLoading: false,
                      onTapItem: () {},
                      onTapItemBtn: () {},
                    ),
                  ),
                );
        }),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBarContent(
      title: Strings.community,
      hasBackNavArrow: false,
      suffix: CusGestureDetector(
        onTap: () => communityGuidlineDialog(
          isLoading: false,
          onTapAction: () async {
            Get.back();
            Get.toNamed(RoutePaths.createCommunity);
          },
        ),
        child: SvgIcon(iconPath: IconsPath.addPlus, height: 30),
      ),
    );
  }

  Widget _buildTabItem({required String title, required bool isSelected, void Function()? onTap}) {
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
          style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: isSelected ? selTxtClr : unselTxtClr),
        ),
      ),
    );
  }
}
*/

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityController>();

    return Obx(
      () => AppScreenTemplate(
        appBar: _buildAppBar(),
        isScrollable: cc.selTab.value == CommunityTab.manage ? false : null,

        child: Obx(() {
          final showTag = cc.showSearchedTag.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: CustomScrollView(
                  shrinkWrap: true,
                  controller: cc.communityScrlCtrl,
                  slivers: [
                    // Search bar
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CusSearchBar(
                            rad: 12,
                            fillColor: ctransp,
                            controller: cc.searchController,
                            focusNode: cc.searchFocus,
                            onEditingComplete: () {
                              cc.showSearchedTag.value = true;
                              cc.searchedTxt.value = cc.searchController.text;
                              cc.clearAll();
                              cc.unFocusAll();
                            },
                          ).getcm,
                          Gap(itemGap),
                        ],
                      ),
                    ),

                    // Main content (search results OR default content)
                    SliverToBoxAdapter(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: showTag
                            ? _buildSearchResultSliver(cc)
                            :
                              // Text("data"),
                              _buildDefaultContentSliver(cc),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBarContent(
      title: Strings.community,
      hasBackNavArrow: false,
      suffix: CusGestureDetector(
        onTap: () => communityGuidlineDialog(
          isLoading: false,
          onTapAction: () async {
            Get.back();
            Get.toNamed(RoutePaths.createCommunity);
          },
        ),
        child: SvgIcon(iconPath: IconsPath.addPlus, height: 30),
      ),
    );
  }
}

Widget _buildSearchResultSliver(CommunityController cc) {
  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      key: const ValueKey("search"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContainerBordered(
              vp: 6,
              hp: 12,
              rad: 30,
              contClr: c.secondary.withOpacity(0.3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFit(
                    cc.searchedTxt.value,
                    style: TxtStyle.urbanistSemiB(fs: 14, w: 600, color: c.primary),
                  ),
                  Gap(8),
                  CusGestureDetector(
                    onTap: () {
                      cc.showSearchedTag.value = false;
                      cc.clearAll();
                    },
                    child: SvgIconColored(iconPath: IconsPath.closeCircle, iconColor: white),

                    // Icon(Icons.close, size: 16, color: white),
                  ),
                ],
              ),
            ).getcm,
          ],
        ),
        Gap(itemGap),
        buildCommunityList(
          shrinkWrap: true,
          scrollController: cc.myCommunityScrlCtrl,
          itemCount: 15,

          itemBuilder: (index) => CommunityItem(
            btnTxt: Strings.join,
            isLoading: false,
            onTapItem: () {},
            onTapItemBtn: () {},
          ),
        ),
      ],
    ),
  );
}

Widget _buildDefaultContentSliver(CommunityController cc) {
  return Column(
    key: const ValueKey("default"),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Tabs
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
      Gap(itemGap),

      // List content
      Obx(() {
        final selTab = cc.selTab.value;
        return selTab == CommunityTab.myCommunities
            ? Column(
                children: [
                  SizedBox(
                    height: S.h * 0.4,
                    child: buildCommunityList(
                      scrollController: cc.myCommunityScrlCtrl,
                      itemCount: 14,
                      itemBuilder: (index) => CommunityItem(
                        btnTxt: Strings.visit,
                        isLoading: false,
                        onTapItem: () => cc.onTapItem(MyCommunityBtnState.visit),
                        onTapItemBtn: () => cc.onTapItemBtn(MyCommunityBtnState.visit),
                      ),
                    ),
                  ),
                  Gap(itemGap),
                  SuggestedCommunitySection(cc: cc),
                ],
              )
            : Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: buildCommunityList(
                      shrinkWrap: true,
                      scrollController: cc.myCommunityScrlCtrl,
                      itemCount: 15,
                      itemBuilder: (index) => CommunityItem(
                        btnTxt: Strings.manage,
                        isLoading: false,
                        onTapItem: () => cc.onTapItem(MyCommunityBtnState.manage),
                        onTapItemBtn: () => cc.onTapItemBtn(MyCommunityBtnState.manage),
                      ),
                    ),
                  ),
                ],
              );
      }),
    ],
  );
}

Widget _buildTabItem({required String title, required bool isSelected, void Function()? onTap}) {
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
        style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: isSelected ? selTxtClr : unselTxtClr),
      ),
    ),
  );
}

Widget buildCommunityList({
  required ScrollController scrollController,
  required int itemCount,
  required CommunityItem Function(int index) itemBuilder,
  final bool? shrinkWrap,
}) {
  return CusScrollbarWidget(
    controller: scrollController,
    child: ListView.builder(
      shrinkWrap: shrinkWrap ?? false,
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder(index).getcm.mB(itemGap * 0.6);
      },
    ),
  );
}

Widget buildCommunityListNoScroll({
  required ScrollController scrollController,
  required int itemCount,
  required CommunityItem Function(int index) itemBuilder,
}) {
  return Column(children: List.generate(12, (index) => itemBuilder(index).getcm.mB(itemGap * 0.5)));
  //  CusScrollbarWidget(
  //   controller: scrollController,
  //   child: Column(children: List.generate(itemCount, (index) => itemBuilder(index).mB(itemGap))),
  // );
}

class SuggestedCommunitySection extends StatelessWidget {
  final CommunityController cc;
  const SuggestedCommunitySection({super.key, required this.cc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContainerBordered(
              rad: 8,
              hp: 10,
              vp: 4,
              // contClr: c.primary,
              child: TextFit(
                Strings.suggestions,
                style: TxtStyle.outfitSemiB(fs: 13, w: 500, color: c.secondary),
              ),
            ),
          ],
        ).getcm,
        Gap(itemGap),
        buildCommunityListNoScroll(
          scrollController: cc.suggCommunityScrlCtrl,
          itemCount: 10,
          itemBuilder: (_) => CommunityItem(
            bgClr: c.inputBackground,
            btnTxt: Strings.join,
            isLoading: false,
            onTapItem: () => cc.onTapItem(MyCommunityBtnState.join),
            onTapItemBtn: () => cc.onTapItemBtn(MyCommunityBtnState.join),
          ),
        ),
      ],
    );
  }
}

//
// Manage

//
