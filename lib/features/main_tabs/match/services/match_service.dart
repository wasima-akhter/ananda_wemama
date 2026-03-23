import 'package:mama_app/features/main_tabs/match/model/match_model.dart';

import '../../../../app/service_export.dart';

class MatchService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<List<MatchResponseModel>> fetchMatches({
    required String latitude,
    required String longitude,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getMatch(lat: latitude, long: longitude).getUrl,
        reqName: Strings.match,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<MatchResponseModel>>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");

        if (data is List) {
          return data.map((e) => MatchResponseModel.fromJson(e)).toList();
        }
        return [];
      },
    );

    print("response data: ${response?.data}");
    return response?.data ?? [];
  }
}
