import '../../../../../app/controller_export.dart';
import '../service/purchase_service.dart';

class SubscriptionPendingController extends GetxController {
  final PurchaseService _purchaseService = PurchaseService.to;
  final RxBool isChecking = false.obs;

  Future<void> onCheckStatus() async {
    if (isChecking.value) return;
    isChecking.value = true;
    try {
      await _purchaseService.refreshCustomerInfo();
      if (_purchaseService.isActive.value) {
        Get.offAllNamed(RoutePaths.subscriptionSuccess);
      } else {
        Snack.showError('Still processing. Please check again shortly.');
      }
    } finally {
      isChecking.value = false;
    }
  }
}
