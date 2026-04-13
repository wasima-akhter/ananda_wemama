import '../../../../../app/helper_widgets_export.dart';

class UIStateHandler extends StatelessWidget {
  final UIState state;

  /// builders
  final Widget Function()? loading;
  final Widget Function()? empty;
  final Widget Function()? data;

  final Future<void> Function()? onRefresh;

  const UIStateHandler({
    super.key,
    required this.state,
    this.loading,
    this.empty,
    this.data,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case UIState.loading:
        return loading?.call() ?? const SizedBox.shrink();

      case UIState.empty:
        return CusRefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          child: empty?.call() ?? const SizedBox.shrink(),
        );

      case UIState.data:
        return CusRefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          child: data?.call() ?? const SizedBox.shrink(),
        );
    }
  }
}
