import '../../../../app/helper_widgets_export.dart';

class CusRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final GlobalKey<RefreshIndicatorState>? refreshKey;
  const CusRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshKey,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: bgClr,
      color: c.primary,
      key: refreshKey,

      child: child,
    );
  }
}
