import '../../../../../app/helper_widgets_export.dart';

class CommunityListViewScrollbar extends StatelessWidget {
  final ScrollController controller;
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final bool isShimmer;

  const CommunityListViewScrollbar({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.isShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(c.primary),
        trackColor: WidgetStateProperty.all(c.primary.withOpacity(0.1)),
        trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        interactive: true,
        radius: Radius.circular(8.r),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView.separated(
            controller: controller,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.only(bottom: itemGap * 2),
            itemCount: itemCount,
            separatorBuilder: (_, _) => Gap(itemGap * 0.6),
            itemBuilder: (_, index) => itemBuilder(index).getcm,
          ),
        ),
      ),
    );
  }
}
