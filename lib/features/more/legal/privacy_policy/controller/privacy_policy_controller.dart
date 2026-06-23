import 'package:get/get.dart';

import '../../../../../core/services/more/legal/privacy_policy/privacy_policy_service.dart';
import '../../terms_and_conditions/model/term_and_conditions_model.dart';

class PrivacyPolicyController extends GetxController {
  final _service = PrivacyPolicyService();

  final isLoading = false.obs;
  final termsData = Rxn<TermsAndConditionsDataModel>();
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy({bool isRefresh = false}) async {
    if (termsData.value != null && !isRefresh) return;

    isLoading.value = true;
    errorMessage.value = null;

    final data = await _service.fetchPrivacyPolicy();

    if (data != null) {
      termsData.value = data;
    } else {
      errorMessage.value = "Failed to load terms. Pull to refresh.";
    }

    isLoading.value = false;
  }
}
