import '../../../../../../app/service_export.dart';
import '../../../../../features/more/legal/terms_and_conditions/model/term_and_conditions_model.dart';

class PrivacyPolicyService extends GetxService {
  Future<TermsAndConditionsDataModel?> fetchPrivacyPolicy() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.privacyPolicy.getUrl,
        // reqName: Strings.privacyPolicy
      );
    }

    final response = await ApiExecutor().execute<TermsAndConditionsDataModel>(
      apiCall: apiCall,
      parser: (data) => TermsAndConditionsDataModel.fromJson(data),
    );

    if (!response.isSuccess) return null;

    return response.data; // 👈 return actual data
  }
}
