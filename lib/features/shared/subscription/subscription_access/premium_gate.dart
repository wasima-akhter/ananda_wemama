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

/* Use:
PremiumGate(
  child: AdvancedInsightsCard(),
  lockedBuilder: (_) => UpgradeTeaserCard(
    onTap: () => Get.toNamed(RoutePaths.subscriptionChoosePlan),
  ),
)
*/
