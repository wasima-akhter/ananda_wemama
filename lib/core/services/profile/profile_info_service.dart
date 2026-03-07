import '../../../../app/service_export.dart';
import '../../../features/main_tabs/profile/model/profile_model.dart';

class ProfileInfoService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<ProfileDataModel?> fetchProfile() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.profileDetail.getUrl,
        reqName: Strings.profile,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<ProfileDataModel>(
      apiCall: apiCall,
      parser: (data) => ProfileDataModel.fromJson(data),
    );

    if (response == null || !response.success) return null;

    return response.data; // 👈 return actual data
  }
}
