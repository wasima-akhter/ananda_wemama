import 'package:get/get.dart';

import '../../../../../core/services/more/legal/privacy_policy/privacy_policy_service.dart';

class AboutController extends GetxController {
  final _service = PrivacyPolicyService();

  final isLoading = false.obs;

  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy({bool isRefresh = false}) async {
    if (!isRefresh) return;

    if (!isRefresh) isLoading.value = true;
    errorMessage.value = null;

    final data = await _service.fetchPrivacyPolicy();

    if (data != null) {
    } else {
      errorMessage.value = "Failed to load terms. Pull to refresh.";
    }

    isLoading.value = false;
  }
}
