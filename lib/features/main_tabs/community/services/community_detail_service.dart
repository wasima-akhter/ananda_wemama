import '../../../../app/service_export.dart';
import '../model/all_comments_of_post_model.dart';
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
        log("parserdata: ${data}");
        final parsedData = CommunityItemDetailModel.fromJson(data);

        return parsedData;
      },
    );

    log("response data: ${response?.data}");
    return response?.data;
  }

  Future<CommentOfPostResponseModel?> fetchCommentsOfAPost({required String postId}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getAllCommentsOfAPost(postId: postId).getUrl,
        reqName: "${Strings.comment} of a post",
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<CommentOfPostResponseModel?>(
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: ${data}");
        final parsedData = CommentOfPostResponseModel.fromJson(data);

        return parsedData;
      },
    );

    log("response data: ${response?.data}");
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
    log("response success: ${response.success}");
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
    log("response success: ${response.success}");
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
    log("response success: ${response.success}");
    return response.success;
  }

  Future<bool> deletePost({required String postItemId}) async {
    apiCall() {
      return ApiClient().delete(
        Endpoints.deletePost(postId: postItemId).getUrl,
        reqName: Strings.post,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    log("response success: ${response.success}");
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
        reqName: Strings.post,
        data: {"community": communityItemId, "content": content, "isAnonymous": isAnonymous},

        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    log("response success: ${response.success}");
    return response.success;
  }

  Future<bool> addComment({
    required String communityItemId,
    required String postItemId,
    String? parentCommentId,
    required String content,
    required String commentorName,
  }) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.postAddComment.getUrl,
        reqName: Strings.comment,
        data: parentCommentId == null
            ? {
                "community": communityItemId,
                "post": postItemId,
                "content": content,
                "name": commentorName,
              }
            : {
                "community": communityItemId,
                "post": postItemId,
                "parentComment": parentCommentId,
                "content": content,
                "name": commentorName,
              },

        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    log("response success: ${response.success}");
    return response.success;
  }

  Future<bool> joinCommunity({required String communityItemId}) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.joinCommunity(communityId: communityItemId).getUrl,
        reqName: "${Strings.join} Community",
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);
    if (response == null) return false;
    log("response success: ${response.success}");
    return response.success;
  }
}
