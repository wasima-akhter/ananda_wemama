import '../../../../app/controller_export.dart';

class SubscriptionUpgradeController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // 0 = free, 1 = paid
  final selectedPlanIndex = 0.obs;

  /// 🔹 select a plan
  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  bool isPlanSelected(int index) => selectedPlanIndex.value == index;

  /// 🔹 Unfocus all fields
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Clear all inputs
  void clearAll() {
    unfocusAll();
  }

  /////

  Future<void> onTapContinue(GlobalKey<FormState> chooseSubPlanFormKey) async {
    final isValid = validateForm(chooseSubPlanFormKey);

    if (!isValid || isLoading_.value) return;

    unfocusAll();
    isLoading_.value = true;

    //backend stuff

    Get.toNamed(RoutePaths.welcomeFundingMum);

    isLoading_.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
