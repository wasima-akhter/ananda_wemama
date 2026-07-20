import '../../../../app/service_export.dart';

class ReferralService extends GetxService {
  Future<bool> applyReferralCode({required String referralCode}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.applyReferralCode(code: referralCode).getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
  }
}
