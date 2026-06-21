import '../../../../../app/helper_widgets_export.dart';

class AppGridView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  final int crossAxisCount;
  final double spacing;
  final double childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const AppGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.spacing = 10,
    this.childAspectRatio = 1.1,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),

      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }
}
