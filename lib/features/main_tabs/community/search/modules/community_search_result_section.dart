import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../shared_ui/community_item.dart';
import '../controller/community_search_controller.dart';
import 'community_list_view_scrollbar.dart';
import 'community_search_chip.dart';

class CommunitySearchResultSection extends StatefulWidget {
  const CommunitySearchResultSection({super.key});

  @override
  State<CommunitySearchResultSection> createState() =>
      _CommunitySearchResultSectionState();
}

class _CommunitySearchResultSectionState
    extends State<CommunitySearchResultSection> {
  final csc = CommunitySearchController.to;

  @override
  void initState() {
    super.initState();
    csc.searchedCommCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final ctrl = csc.searchedCommCtrl;

    if (!csc.searchedPaginator.hasMore.value) return;

    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200) {
      csc.loadMoreSearched(); // ✅ correct
    }
  }

  @override
  void dispose() {
    csc.searchedCommCtrl.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final csc = CommunitySearchController.to;
    return Column(
      key: const ValueKey("search"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommunitySearchChip(csc: csc),

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
              onRefresh: () async => csc.getSearchedCommunityList(),
              state: uiStateCommunities,

              loading: () => CommunityListViewScrollbar(
                controller: csc.searchedCommCtrl,
                itemCount: 10,
                itemBuilder: (index) => CommunityItemShimmer(),
                isShimmer: true,
              ),

              empty: () => EmptyNoSearchWidgetScrollable(
                title: "No communities found",
                assetPath: Assets.images.noCommunitiesIcon.path,

                subTitle:
                    "We couldn't find any communities\n"
                    "matching your search. Try exploring\n"
                    "with different keywords.",
              ).getcm,

              data: () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: CommunityListViewScrollbar(
                  controller: csc.searchedCommCtrl,
                  itemCount: displayListSearched.length,
                  itemBuilder: (index) {
                    final item = displayListSearched[index];
                    return CommunityItem(
                      item: item,
                      btnTxt: item.btnText,
                      isLoading: false,
                      onTapItem: () => csc.onTapItem(
                        btnState: item.btnState,
                        communityItemId: item.id ?? '',
                      ),
                      onTapItemBtn: () => csc.onTapItemBtn(
                        btnState: item.btnState,
                        communityItemId: item.id ?? '',
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
