import 'package:mama_app/app/controller_export.dart';
import 'package:mama_app/features/more/blocked_user/model/blocked_user_model.dart';

import '../../../../app/service_export.dart';

class BlockedUserService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<List<BlockedUserDataModel>> fetchBlockedUsers() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.blockedUsers.getUrl,
        reqName: Strings.blockedUser,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<BlockedUserDataModel>>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");

        if (data == null) return [];

        return (data is List) ? data.map((e) => BlockedUserDataModel.fromJson(e)).toList() : [];
      },
    );

    print("response data: ${response?.data}");
    return response?.data ?? [];
  }

  Future<bool> unblockUser({required String userId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.unblockUser(blockeRUserId: currentProfileId(), blockedUserId: userId).getUrl,
        reqName: Strings.unblock,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);

    if (response == null) return false;

    print("response data: ${response?.success}");
    return response?.success ?? false;
  }

  Future<bool> blockUser({required String userId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.blockUser(userId: userId).getUrl,
        reqName: Strings.unblock,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);

    if (response == null) return false;

    print("response data: ${response?.success}");
    return response?.success ?? false;
  }
}
