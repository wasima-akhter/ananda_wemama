import '../../../../../app/helper_widgets_export.dart';
import '../../shared_ui/community_item.dart';

class CommunityShimmerList extends StatelessWidget {
  const CommunityShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(bottom: itemGap * 2),
          sliver: SliverList.separated(
            itemCount: 5,
            itemBuilder: (_, _) => CommunityItemShimmer(),
            separatorBuilder: (_, _) => Gap(itemGap * 0.6),
          ),
        ),
      ],
    ).getcm;
  }
}
