import 'package:we_mama/app/controller_export.dart';
import 'package:we_mama/features/more/blocked_user/model/blocked_user_model.dart';

import '../../../../app/service_export.dart';

class BlockedUserService extends GetxService {
  /// Fetch inventory details from API

  Future<List<BlockedUserDataModel>> fetchBlockedUsers() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.blockedUsers.getUrl,
        // reqName: Strings.blockedUser,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<List<BlockedUserDataModel>>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: $data");

        if (data == null) return [];

        return (data is List)
            ? data.map((e) => BlockedUserDataModel.fromJson(e)).toList()
            : [];
      },
    );

    print("response data: ${response.data}");
    return response.data ?? [];
  }

  Future<bool> unblockUser({required String userId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.unblockUser(
          blockeRUserId: currentProfileId(),
          blockedUserId: userId,
        ).getUrl,
        // reqName: Strings.unblock,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
  }

  Future<bool> blockUser({required String userId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.blockUser(userId: userId).getUrl,
        // reqName: Strings.unblock,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
  }
}
