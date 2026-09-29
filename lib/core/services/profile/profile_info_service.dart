import '../../../../app/service_export.dart';
import '../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';

class ProfileInfoService {
  Future<ProfileDataModel?> fetchProfile() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.profileDetail.getUrl,
        // reqName: Strings.profile,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<ProfileDataModel>(
      apiCall: apiCall,
      parser: (data) {
        return ProfileDataModel.fromJson(data);
      },
    );

    if (!response.isSuccess) return null;

    return response.data; // 👈 return actual data
  }
}
