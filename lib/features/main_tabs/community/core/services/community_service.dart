import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../../../../../core/utils/paginator/paginator.dart';
import '../models/community_item_model.dart';

class CommunityService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<bool> createCommunity({
    required XFile? communityImg,
    required String communityName,
  }) async {
    final response = await _apiHelper.request(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.createCommunity.getUrl,
        reqName: Strings.createCommunity,
        file: communityImg != null
            ? MapEntry('community-image', communityImg)
            : null,
        fields: {'name': communityName},
      ),
    );

    return response != null && response.success;
  }

  Future<bool> updateCommunity({
    required XFile? communityImg,
    required String? communityName,
    required String communityId,
  }) async {
    final response = await _apiHelper.request(
      apiCall: () => ApiClient().patchWithFile(
        Endpoints.updateCommunity.getUrl,
        reqName: Strings.updateCommunity,
        file: communityImg != null
            ? MapEntry('community-image', communityImg)
            : null,
        fields: {'name': ?communityName, 'communityId': communityId},
      ),
    );

    return response != null && response.success;
  }

  Future<PaginatedResult<CommunityItemModel>> fetchManagedCommunityListPaged({
    required int page,
    required int limit,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getMyCommunity(limit: limit, page: page).getUrl,

        reqName: Strings.myCommunity,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<CommunityItemModel>>(
      showErrorToast: false,
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: $data");
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    log("response data: ${response?.data}");

    return PaginatedResult(
      data: response?.data ?? [],
      meta: response?.meta, // ✅ comes straight from BaseResponse
    );
  }

  Future<PaginatedResult<CommunityItemModel>> fetchJoinedCommunityListPaged({
    required int page,
    required int limit,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getJoinedCommunity(limit: limit, page: page).getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<CommunityItemModel>>(
      showErrorToast: false,
      apiCall: apiCall,
      parser: (data) {
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }
        return [];
      },
    );

    return PaginatedResult(
      data: response?.data ?? [],
      meta: response?.meta, // ✅ comes straight from BaseResponse
    );
  }

  Future<PaginatedResult<CommunityItemModel>> fetchSuggestedCommunityListPaged({
    required int page,
    required int limit,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getSuggestedCommunity(limit: limit, page: page).getUrl,
        reqName: Strings.suggestions,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<CommunityItemModel>>(
      showErrorToast: false,
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: $data");
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    log("response data: ${response?.data}");
    return PaginatedResult(
      data: response?.data ?? [],
      meta: response?.meta, // ✅ comes straight from BaseResponse
    );
  }

  Future<PaginatedResult<CommunityItemModel>> fetchSearchedCommunityListPaged({
    required String searchTxt,
    required int page,
    required int limit,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getSearchedCommunity(
          searchTxt: searchTxt,
          limit: limit,
          page: page,
        ).getUrl,
        reqName: Strings.search,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<CommunityItemModel>>(
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: $data");
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    log("response data: ${response?.data}");
    return PaginatedResult(
      data: response?.data ?? [],
      meta: response?.meta, // ✅ comes straight from BaseResponse
    );
  }
}
