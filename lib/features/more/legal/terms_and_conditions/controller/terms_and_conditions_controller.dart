import 'package:get/get.dart';

import '../../../../../core/services/more/legal/terms_conditions/terms_conditions_service.dart';
import '../model/term_and_conditions_model.dart';

class TermsAndConditionsController extends GetxController {
  static TermsAndConditionsController get to =>
      Get.find<TermsAndConditionsController>();
  final _service = TermsConditionsService();

  final isLoading = false.obs;
  final termsData = Rxn<TermsAndConditionsDataModel>();
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms({bool isRefresh = false}) async {
    if (termsData.value != null && !isRefresh) return;

    if (!isRefresh) isLoading.value = true;
    errorMessage.value = null;

    final data = await _service.fetchTermsAndConditions();

    if (data != null) {
      termsData.value = data;
    } else {
      errorMessage.value = "Failed to load terms. Pull to refresh.";
    }

    isLoading.value = false;
  }
}
