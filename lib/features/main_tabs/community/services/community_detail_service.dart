import '../../../../app/service_export.dart';
import '../model/community_item_detail_model.dart';

class CommunityDetailService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<CommunityItemDetailModel?> fetchCommunityDetail({required String communityItemId}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getCommunityDetail(id: communityItemId).getUrl,
        reqName: "${Strings.community} Detail",
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<CommunityItemDetailModel?>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");
        final parsedData = CommunityItemDetailModel.fromJson(data);

        return parsedData;
      },
    );

    print("response data: ${response?.data}");
    return response?.data;
  }

  Future<bool> postTogglelike({
    required String communityItemId,
    required String postItemId,
    required String likerName,
  }) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.postToggleLike.getUrl,
        reqName: Strings.post,
        data: {"community": communityItemId, "post": postItemId, "name": likerName},
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    print("response success: ${response.success}");
    return response.success;
  }

  Future<bool> pinPost({required String postItemId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.pinPost(id: postItemId).getUrl,
        reqName: Strings.pinPost,

        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    print("response success: ${response.success}");
    return response.success;
  }

  Future<bool> lockCommentOfPost({required String postItemId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.lockCommentOfPost(id: postItemId).getUrl,
        reqName: Strings.comment,

        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    print("response success: ${response.success}");
    return response.success;
  }

  Future<bool> createNewPost({
    required String communityItemId,
    required String content,
    required bool isAnonymous,
  }) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.createNewPost.getUrl,
        reqName: Strings.comment,
        data: {"community": communityItemId, "content": content, "isAnonymous": isAnonymous},

        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    print("response success: ${response.success}");
    return response.success;
  }
}
