import '../../../../app/service_export.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';

class WaveService extends GetxService {
  Future<ProfileDataModel?> fetchUserProfile({required String userId}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getUserProfile(userId: userId).getUrl,
        // reqName: Strings.profile,
      );
    }

    final response = await ApiExecutor().execute<ProfileDataModel>(
      apiCall: apiCall,
      parser: (data) => ProfileDataModel.fromJson(data),
    );

    if (!response.isSuccess) return null;

    return response.data; // 👈 return actual data
  }

  Future<bool> acceptWaveRequest({required String conversationId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.acceptWaveRequest(conversationId: conversationId).getUrl,
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    if (!response.isSuccess) return false;

    return response.isSuccess; // 👈 return actual data
  }

  Future<bool> rejectWaveRequest({required String conversationId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.rejectWaveRequest(conversationId: conversationId).getUrl,
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    if (!response.isSuccess) return false;

    return response.isSuccess; // 👈 return actual data
  }
}
