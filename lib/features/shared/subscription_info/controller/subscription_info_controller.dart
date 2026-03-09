import '../../../../app/controller_export.dart';

class SubscriptionInfoController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // ── Toggle states ──
  final pushNotification = true.obs;
  final communityUpdates = false.obs;
  final invisibleMode = false.obs;

  void togglePushNotification(bool v) => pushNotification.value = v;
  void toggleCommunityUpdates(bool v) => communityUpdates.value = v;
  void toggleInvisibleMode(bool v) => invisibleMode.value = v;

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
