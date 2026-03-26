import '../../../../app/service_export.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';

class WaveUserProfileInfoService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<ProfileDataModel?> fetchUserProfile({required String userId}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getUserProfile(userId: userId).getUrl,
        reqName: Strings.profile,
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
