import '../../../../app/controller_export.dart';

class SubscriptionChoosePlanController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // 0 = free, 1 = paid, -1 = none selected
  final selectedPlanIndex = (-1).obs;

  /// 🔹 select a plan
  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  bool isPlanSelected(int index) => selectedPlanIndex.value == index;

  bool get hasSelectedPlan => selectedPlanIndex.value != -1;

  /// 🔹 Unfocus all fields
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Clear all inputs
  void clearAll() {
    unfocusAll();
    selectedPlanIndex.value = -1;
  }

  ///// Continue button logic
  Future<void> onTapContinue(GlobalKey<FormState> chooseSubPlanFormKey) async {
    // ❌ prevent continue if no plan selected
    if (!hasSelectedPlan || isLoading_.value) return;

    final isValid = validateForm(chooseSubPlanFormKey);
    if (!isValid) return;

    unfocusAll();
    isLoading_.value = true;

    // 🔹 backend stuff
    Get.toNamed(RoutePaths.welcomeFundingMum);

    isLoading_.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
