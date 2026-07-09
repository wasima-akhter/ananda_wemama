import '../../../../app/controller_export.dart';
import '../service/subscription_service.dart';

// subscription_upgrade_controller.dart
class SubscriptionUpgradeController extends GetxController {
  final RxInt selectedPlanIndex = (-1).obs;
  final RxBool isLoading = false.obs;
  final SubscriptionService _subscriptionService = SubscriptionService();

  bool isPlanSelected(int index) => selectedPlanIndex.value == index;

  void selectPlan(int index) => selectedPlanIndex.value = index;

  Future<void> onTapContinue(GlobalKey<FormState> formKey) async {
    if (selectedPlanIndex.value == -1) {
      Snack.showError('Please select a plan');
      return;
    }

    // Free plan — no payment needed, just activate directly
    if (selectedPlanIndex.value == 0) {
      Get.offAllNamed(
        RoutePaths.subscriptionInfo,
      ); // or whatever your free-path is
      return;
    }

    isLoading.value = true;
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
      isLoading.value = false;
    }
  }
}

/*    // RESTORE Function
Future<void> onTapRestorePurchases() async {
  isProcessing.value = true;
  final outcome = await Get.find<PurchaseService>().restorePurchases();
  isProcessing.value = false;

  if (outcome.result == PurchaseResult.success) {
    CustomSnackBar.success('Subscription restored successfully');
    Get.offAllNamed(Routes.home);
  } else {
    CustomSnackBar.error(outcome.errorMessage ?? 'No purchases to restore');
  }
}
*/

/*
// if free --> home
// .. if premium navigation --->
// splash or home entry check
Future<void> checkSubscriptionAndNavigate() async {
  await Get.find<PurchaseService>().refreshCustomerInfo();
  final isActive = Get.find<PurchaseService>().isActive.value;

  if (isActive) {
    Get.offAllNamed(Routes.home);
  } else {
    Get.offAllNamed(Routes.subscriptionUpgrade); // fallback: force back to paywall
  }
}
*/

/*
// Also react live to entitlement changes anywhere in the app (e.g. subscription expires while app is open):
ever(Get.find<PurchaseService>().isActive, (active) {
  if (!active) Get.offAllNamed(Routes.subscriptionUpgrade);
});
*/
