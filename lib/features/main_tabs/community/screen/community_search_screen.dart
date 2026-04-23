import 'package:mama_app/core/components/ui/scroll/cus_scrollbar_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../controller/community_search_controller.dart';
import '../widgets/community_item.dart';

class CommunitySearchScreen extends StatelessWidget {
  const CommunitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final csc = Get.find<CommunitySearchController>();
    return AppScreenTemplate(
      isScrollable: false,
      appBar: _buildAppBar(csc),

      child: Obx(() {
        final showTag = csc.showSearchedTag.value;

        return showTag ? _buildSearchResult(csc) : SuggestedCommunitySection(csc: csc);
      }),
    );
  }

  Widget _buildSearchResult(CommunitySearchController csc) {
    return Column(
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
                    csc.searchedTxt.value,
                    style: TxtStyle.urbanistSemiB(fs: 14, w: 600, color: c.primary),
                  ),
                  Gap(8),
                  CusGestureDetector(
                    onTap: () async {
                      csc.showSearchedTag.value = false;

                      csc.clearAll();
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

        Obx(() {
          final isSearchedLoading = csc.isSearchedCommunityLoading_.value;
          final displayListSearched = csc.searchedCommunityList;

          final uiStateCommunities = getUIStateList(
            isLoading: isSearchedLoading,
            list: displayListSearched,
          );
          return Expanded(
            child: UIStateHandler(
              onRefresh: () async {
                await csc.getSearchedCommunityList();
              },
              state: uiStateCommunities,

              loading: () => CusScrollbarWidget(
                controller: csc.searchedCommCtrl,
                child:
                    //  ListView.builder(itemCount: 10, itemBuilder: (context, index) => Text("data")),
                    ListView.separated(
                      controller: csc.searchedCommCtrl,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.only(bottom: itemGap * 2),
                      itemCount: 10,
                      separatorBuilder: (_, __) => Gap(itemGap * 0.6),
                      itemBuilder: (_, index) => CommunityItemShimmer(),
                    ).getcm,
              ),

              empty: () => const EmptyWidgetScrollable(title: "No Community found").getcm,

              data: () => Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: buildCommunityList(
                    scrollController: csc.searchedCommCtrl,
                    itemCount: displayListSearched.length,
                    itemBuilder: (index) {
                      final item = displayListSearched[index];

                      return CommunityItem(
                        item: item,
                        btnTxt: item.btnText,
                        isLoading: false,
                        onTapItem: () =>
                            csc.onTapItem(btnState: item.btnState, communityItemId: item.id ?? ''),
                        onTapItemBtn: () => csc.onTapItemBtn(
                          btnState: item.btnState,
                          communityItemId: item.id ?? '',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(CommunitySearchController csc) {
    return CommonAppBarContent(
      title: '',
      titleWidget: Expanded(
        child: CusSearchBar(
          fillColor: ctransp,
          controller: csc.searchController,
          focusNode: csc.searchFocus,
          onEditingComplete: () async {
            csc.showSearchedTag.value = true;
            csc.searchedTxt.value = csc.searchController.text;

            await csc.getSearchedCommunityList();
            csc.clearAll();
            csc.unFocusAll();
          },
        ).getcm.mHV(0, 6),
      ),
    );
  }
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
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder(index).getcm.mB(itemGap * 0.6);
      },
    ),
  );
}

// ── Suggested communities section ──────────────────────────────────────────────
class SuggestedCommunitySection extends StatelessWidget {
  final CommunitySearchController csc;
  const SuggestedCommunitySection({super.key, required this.csc});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSuggestedLoading = csc.isSuggestedCommunityLoading_.value;
      final displayListSuggested = csc.suggestedCommunityList;

      final uiStateMyCommunities = getUIStateList(
        isLoading: isSuggestedLoading,
        list: displayListSuggested,
      );

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
                child: TextFit(
                  "You may like",
                  style: TxtStyle.outfitSemiB(fs: 13, w: 500, color: c.secondary),
                ),
              ),
            ],
          ).getcm,
          Gap(itemGap * 0.5),

          // Expanded(child: Column(children: [Text("sihasbas")])),
          Expanded(
            // height: 500,
            child: UIStateHandler(
              onRefresh: () async {
                await csc.getSuggestedCommunityList();
              },
              state: uiStateMyCommunities,

              loading: () => ListView.separated(
                controller: csc.suggCommunityScrlCtrl,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.only(bottom: itemGap * 2),
                itemCount: 10,
                separatorBuilder: (_, __) => Gap(itemGap * 0.6),
                itemBuilder: (_, index) => CommunityItemShimmer(),
              ).getcm,

              empty: () => const EmptyWidgetScrollable(title: "No Communities yet").getcm,

              data: () => buildCommunityList(
                scrollController: csc.suggCommunityScrlCtrl,
                itemCount: displayListSuggested.length,
                itemBuilder: (index) => CommunityItem(
                  item: displayListSuggested[index],
                  bgClr: c.inputBackground,
                  btnTxt: Strings.join,
                  isLoading: false,
                  onTapItem: () => csc.onTapItem(
                    btnState: MyCommunityBtnState.join,
                    communityItemId: displayListSuggested[index].id ?? '',
                  ),
                  onTapItemBtn: () => csc.onTapItemBtn(
                    btnState: MyCommunityBtnState.join,
                    communityItemId: displayListSuggested[index].id ?? '',
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
