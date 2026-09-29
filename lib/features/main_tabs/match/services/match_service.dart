import 'package:we_mama/features/main_tabs/match/model/match_model.dart';

import '../../../../app/service_export.dart';

class MatchService extends GetxService {
  Future<List<MatchResponseModel?>> fetchMatches({
    required String latitude,
    required String longitude,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getMatch(long: longitude, lat: latitude).getUrl,
        // Endpoints.getMatch(long: "90.405449", lat: "23.777628").getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<MatchResponseModel?>(
      apiCall: apiCall,
      parser: (data) {
        print("parser data: $data");

        if (data is Map<String, dynamic>) {
          return MatchResponseModel.fromJson(data);
        }

        return null;
      },
    );

    print("response data: ${response.data}");

    // Backend says free limit reached
    if (response.statusCode == 403) {
      throw const MatchLimitExceededException();
    }

    if (response.data == null) {
      return [];
    }

    // Wrap single match into a list so existing controller code remains unchanged.
    return [response.data!];
  }
}

class MatchLimitExceededException implements Exception {
  const MatchLimitExceededException();
}
