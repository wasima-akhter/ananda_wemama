import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../shared_ui/community_item.dart';
import '../controller/community_search_controller.dart';
import 'community_list_view_scrollbar.dart';

class SuggestedCommunitySection extends StatefulWidget {
  const SuggestedCommunitySection({super.key});

  @override
  State<SuggestedCommunitySection> createState() =>
      _SuggestedCommunitySectionState();
}

class _SuggestedCommunitySectionState extends State<SuggestedCommunitySection> {
  final csc = CommunitySearchController.to;

  @override
  void initState() {
    super.initState();
    csc.suggCommunityScrlCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final ctrl = csc.suggCommunityScrlCtrl;

    if (!csc.suggestedPaginator.hasMore.value) return;

    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200) {
      csc.loadMoreSuggested();
    }
  }

  @override
  void dispose() {
    csc.suggCommunityScrlCtrl.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final csc = CommunitySearchController.to;
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

      empty: () => EmptyNoSearchWidgetScrollable(
        assetPath: Assets.images.noCommunitiesIcon.path,
        title: "No suggested communities",
        subTitle:
            "New communities are joining every day.\n"
            "Come back soon and discover your\n"
            "perfect mum circle.",
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
