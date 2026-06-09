import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../shared_ui/community_item.dart';
import '../controller/community_search_controller.dart';
import 'community_list_view_scrollbar.dart';

class SuggestedCommunitySection extends StatelessWidget {
  final CommunitySearchController csc;

  const SuggestedCommunitySection({super.key, required this.csc});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = csc.isSuggestedCommunityLoading_.value;

      final list = csc.suggestedCommunityList;

      final state = getUIStateList(isLoading: isLoading, list: list);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SuggestedHeader(),
          Gap(itemGap * 0.5),
          Expanded(
            child: _SuggestedCommunityList(csc: csc, state: state, list: list),
          ),
        ],
      );
    });
  }
}

class _SuggestedHeader extends StatelessWidget {
  const _SuggestedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    ).getcm;
  }
}

class _SuggestedCommunityList extends StatelessWidget {
  final CommunitySearchController csc;
  final UIState state;
  final List list;

  const _SuggestedCommunityList({
    required this.csc,
    required this.state,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return UIStateHandler(
      onRefresh: () async => csc.getSuggestedCommunityList(),
      state: state,

      loading: () => CommunityListViewScrollbar(
        controller: csc.suggCommunityScrlCtrl,
        itemCount: 10,
        itemBuilder: (_) => CommunityItemShimmer(),
        isShimmer: true,
      ),

      empty: () => const EmptyNoSearchWidgetScrollable(
        title: "No Communities yet",
      ).getcm,

      data: () => CommunityListViewScrollbar(
        controller: csc.suggCommunityScrlCtrl,
        itemCount: list.length,
        itemBuilder: (i) => _buildItem(csc, list, i),
      ),
    );
  }

  Widget _buildItem(CommunitySearchController csc, List list, int i) {
    final item = list[i];

    return CommunityItem(
      item: item,
      bgClr: c.inputBackground,
      btnTxt: Strings.join,
      isLoading: false,
      onTapItem: () => csc.onTapItem(
        btnState: MyCommunityBtnState.join,
        communityItemId: item.id ?? '',
      ),
      onTapItemBtn: () => csc.onTapItemBtn(
        btnState: MyCommunityBtnState.join,
        communityItemId: item.id ?? '',
      ),
    );
  }
}
