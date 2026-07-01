import '../../../../app/service_export.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';

class WaveService extends GetxService {
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

  Future<bool> acceptWaveRequest({required String conversationId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.acceptWaveRequest(conversationId: conversationId).getUrl,
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);

    if (response == null || !response.success) return false;

    return response.success; // 👈 return actual data
  }

  Future<bool> rejectWaveRequest({required String conversationId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.rejectWaveRequest(conversationId: conversationId).getUrl,
        

      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);

    if (response == null || !response.success) return false;

    return response.success; // 👈 return actual data
  }
}
