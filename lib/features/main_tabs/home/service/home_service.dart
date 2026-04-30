import 'package:flutter/material.dart';

import '../../../../app/service_export.dart';
import '../model/community_spotlight_model.dart';

class HomeService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<CommunitySpotlightModel?> fetchCommunitySpotLight() async {
    apiCall() {
      return ApiClient().get(
        // Endpoints.getMatch(lat: latitude, long: longitude).getUrl,
        Endpoints.communitySpotlight.getUrl,
        reqName: Strings.communitySpotlight,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<CommunitySpotlightModel?>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");

        debugPrint(
          ' CommunitySpotlightData.fromJson(data) : ${CommunitySpotlightModel.fromJson(data).communitySpotlight?.createdAt}',
        );

        return CommunitySpotlightModel.fromJson(data); // ✅
      },
    );

    print("response data: ${response?.data}");
    return response?.data;
  }
}
