import '../../../../app/helper_widgets_export.dart';
import 'premium_access_service.dart';

class PremiumGate extends StatelessWidget {
  final Widget child;
  final WidgetBuilder? lockedBuilder;
  final bool waitForReady;

  const PremiumGate({
    super.key,
    required this.child,
    this.lockedBuilder,
    this.waitForReady = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final access = PremiumAccessService.to;

      if (waitForReady && !access.isReady.value) {
        return const SizedBox.shrink();
      }

      if (access.isPremiumUser.value) return child;

      return lockedBuilder?.call(context) ?? const SizedBox.shrink();
    });
  }
}

class PremiumLock extends StatelessWidget {
  const PremiumLock({
    super.key,
    required this.child,
    this.disabledOpacity = .45,
  });

  final Widget child;
  final double disabledOpacity;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPremium = PremiumAccessService.to.isPremiumUser.value;

      return IgnorePointer(
        ignoring: !isPremium,
        child: Opacity(opacity: isPremium ? 1 : disabledOpacity, child: child),
      );
    });
  }
}
