import '../../../../../app/controller_export.dart';
import '../../subscription_access/premium_access_service.dart';
import '../../subscription_upgrade/mixin/subscription_plan_mixin.dart';

class SubscriptionChoosePlanController extends GetxController
    with SubscriptionPlanFlowMixin {
  final isLoading_ = false.obs;
  @override
  RxBool get flowLoading => isLoading_;
  bool get isLoading => isLoading_.value;

  final selectedPlanIndex = (-1).obs;
  void selectPlan(int index) => selectedPlanIndex.value = index;
  bool isPlanSelected(int index) => selectedPlanIndex.value == index;
  bool get hasSelectedPlan => selectedPlanIndex.value != -1;

  void unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  void onInit() {
    super.onInit();
    if (PremiumAccessService.to.isPremiumUserNow) {
      Get.offAllNamed(RoutePaths.subscriptionSuccess); // or wherever home is
    }
  }

  Future<void> onTapContinue(GlobalKey<FormState> formKey) async {
    if (!hasSelectedPlan || isLoading_.value) return;
    if (!validateForm(formKey)) return;
    unfocusAll();

    if (selectedPlanIndex.value == 0) {
      Get.offAllNamed(RoutePaths.welcomeFundingMum);
    } else {
      await proceedToPaidPlan();
    }
  }
}
