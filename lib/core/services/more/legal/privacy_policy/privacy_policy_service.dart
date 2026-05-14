import '../../../../../../app/service_export.dart';
import '../../../../../features/more/legal/terms_and_conditions/model/term_and_conditions_model.dart';

class PrivacyPolicyService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<TermsAndConditionsDataModel?> fetchPrivacyPolicy() async {
    apiCall() {
      return ApiClient().get(Endpoints.privacyPolicy.getUrl, reqName: Strings.privacyPolicy);
    }

    final response = await _apiHelper.request<TermsAndConditionsDataModel>(
      apiCall: apiCall,
      parser: (data) => TermsAndConditionsDataModel.fromJson(data),
    );

    if (response == null || !response.success) return null;

    return response.data; // 👈 return actual data
  }
}
