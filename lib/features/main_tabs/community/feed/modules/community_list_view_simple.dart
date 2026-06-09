import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/scroll/custom_scroll_view_widget.dart';
import '../../shared_ui/community_item.dart';

class CommunityListViewSimple extends StatefulWidget {
  final int itemCount;
  final CommunityItem Function(int index) itemBuilder;

  const CommunityListViewSimple({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<CommunityListViewSimple> createState() =>
      _CommunityListViewSimpleState();
}

class _CommunityListViewSimpleState extends State<CommunityListViewSimple> {
  final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollViewWidget(
      controller: _ctrl,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(bottom: itemGap * 2),
          sliver: SliverList.builder(
            itemCount: widget.itemCount,
            itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == widget.itemCount - 1 ? 0 : itemGap * 0.6,
              ),
              child: widget.itemBuilder(index).getcm,
            ),
          ),
        ),
      ],
    );
  }
}
