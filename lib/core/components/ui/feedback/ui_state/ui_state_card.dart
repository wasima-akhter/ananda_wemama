import '../../../../../app/helper_widgets_export.dart';

class UIStateHandler extends StatelessWidget {
  final UIState state;

  /// Builders
  final Widget Function()? loading;
  final Widget Function()? empty;
  final Widget Function()? error;
  final Widget Function()? data;

  /// Retry
  final VoidCallback? onRetry;

  /// Pull to refresh
  final Future<void> Function()? onRefresh;

  const UIStateHandler({
    super.key,
    required this.state,
    this.loading,
    this.empty,
    this.error,
    this.data,
    this.onRetry,
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

      case UIState.error:
        return error?.call() ?? _DefaultErrorPlaceholder(onRetry: onRetry);

      case UIState.data:
        return CusRefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          child: data?.call() ?? const SizedBox.shrink(),
        );
    }
  }
}

class _DefaultErrorPlaceholder extends StatelessWidget {
  final VoidCallback? onRetry;

  const _DefaultErrorPlaceholder({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48),
          const SizedBox(height: 12),
          Text('Something went wrong', style: TxtStyle.outfitLarTitle),
          const SizedBox(height: 8),
          Text('Please try again.', style: TxtStyle.outfitSmTitleSec),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String retryText;

  const CustomErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.retryText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 34,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Text(
              message?.isNotEmpty == true
                  ? message!
                  : 'Unable to load the content. Please try again.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),

            if (onRetry != null) ...[
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
