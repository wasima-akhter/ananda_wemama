// core/mixins/subscription_plan_flow_mixin.dart
import '../../../../../app/controller_export.dart';
import '../service/subscription_service.dart';

mixin SubscriptionPlanFlowMixin on GetxController {
  /// Each controller exposes its own loading Rx so UI bindings don't change
  RxBool get flowLoading;

  final SubscriptionService _subscriptionService = SubscriptionService();

  Future<void> proceedToPaidPlan() async {
    if (flowLoading.value) return;
    flowLoading.value = true;
    try {
      final priceModel = await _subscriptionService.getDiscountedPrice();
      if (priceModel == null) {
        Snack.showError('Unable to fetch pricing. Please try again.');
        return;
      }
      Get.toNamed(RoutePaths.subscriptionConfirmScreen, arguments: priceModel);
    } catch (e) {
      Snack.showError('Something went wrong. Please try again.');
    } finally {
      flowLoading.value = false;
    }
  }
}
