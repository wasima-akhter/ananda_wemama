import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../shared_ui/community_item.dart';
import '../controller/community_search_controller.dart';
import 'community_list_view_scrollbar.dart';
import 'community_search_chip.dart';

class CommunitySearchResultSection extends StatelessWidget {
  final CommunitySearchController csc;

  const CommunitySearchResultSection({super.key, required this.csc});

  @override
  Widget build(BuildContext context) {
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

              empty: () => const EmptyNoSearchWidgetScrollable(
                title: "No Community found",
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
