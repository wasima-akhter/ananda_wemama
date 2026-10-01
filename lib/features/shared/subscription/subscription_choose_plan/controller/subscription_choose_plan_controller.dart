import '../../../../../app/controller_export.dart';
import '../../../../../core/components/ui/dialogs/popups.dart';
import '../../../../../core/services/auth/verification_gate.dart';
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
  void onReady() {
    super.onReady();

    if (PremiumAccessService.to.isPremiumUserNow) {
      showAlreadyPremiumDialog();
    }
  }

  Future<void> onTapContinue(GlobalKey<FormState> formKey) async {
    if (!hasSelectedPlan || isLoading_.value) return;
    if (!validateForm(formKey)) return;
    unfocusAll();

    if (selectedPlanIndex.value == 0) {
      await VerificationGate.routeAfterAuth(isFromFreePlan: true);
    } else {
      await proceedToPaidPlan();
    }
  }
}
