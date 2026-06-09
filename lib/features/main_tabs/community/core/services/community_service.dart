import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../models/community_item_model.dart';

class CommunityService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API
  /* old
  Future<bool> createCommunity({
    required XFile? communityImg,
    required String communityName,
  }) async {
    final data = dio.FormData();

    // ───────────────── IMAGE (COMPRESS) ─────────────────

    if (communityImg != null) {
      final compressed = await MultipartHelper.compressedImage(
        File(communityImg.path),
      );

      if (compressed == null) {
        "Image compression failed".showToast();
        return false;
      }

      data.files.add(MapEntry('community-image', compressed));
    }

    // ───────────────── TEXT FIELDS ─────────────────

    data.fields.add(MapEntry('name', communityName));

    // ───────────────── DEBUG ─────────────────

    log('fields: ${data.fields}');
    log('files count: ${data.files.length}');
    log('file keys: ${data.files.map((e) => e.key).toList()}');

    for (final f in data.fields) {
      log('${f.key}: ${f.value}');
    }

    for (final f in data.files) {
      log('${f.key}: ${f.value.filename}');
    }

    log("Token: ${storage.getAccessToken}");

    // ───────────────── API CALL ─────────────────

    final response = await _apiHelper.request(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.createCommunity.getUrl,
        reqName: Strings.createCommunity,
        data: data,
      ),
    );

    if (response == null || !response.success) return false;

    log('response.success: ${response.success}');
    log('community id while create: ${response.data}');

    return true;
  }

  Future<bool> updateCommunity({
    required XFile? communityImg,
    required String? communityName,
    required String communityId,
  }) async {
    final data = dio.FormData();

    // ───────────────── IMAGE (COMPRESS HERE) ─────────────────

    if (communityImg != null) {
      final compressed = await MultipartHelper.compressedImage(
        File(communityImg.path),
      );

      if (compressed != null) {
        data.files.add(MapEntry('community-image', compressed));
      } else {
        "Image compression failed".showToast();
        return false;
      }
    }

    // ───────────────── TEXT FIELDS ─────────────────

    if (communityName != null) {
      data.fields.add(MapEntry('name', communityName));
    }

    data.fields.add(MapEntry('communityId', communityId));

    // ───────────────── DEBUG ─────────────────

    log('fields: ${data.fields}');
    log('files count: ${data.files.length}');
    log('file keys: ${data.files.map((e) => e.key).toList()}');

    log('FIELDS:');
    for (var f in data.fields) {
      log('${f.key}: ${f.value}');
    }

    log('FILES:');
    for (var f in data.files) {
      log('${f.key}: ${f.value.filename}');
    }

    log("Token: ${storage.getAccessToken}");

    // ───────────────── API CALL ─────────────────

    final response = await _apiHelper.request(
      apiCall: () => ApiClient().patchWithFile(
        Endpoints.updateCommunity.getUrl,
        reqName: Strings.updateCommunity,
        data: data,
      ),
    );

    if (response == null || !response.success) return false;

    log('response.success: ${response.success}');
    log('community id while update : ${response.data}');

    return true;
  }
*/
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

  Future<List<CommunityItemModel>> fetchManagedCommunityList() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getMyCommunity.getUrl,
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
    return response?.data ?? [];
  }

  Future<List<CommunityItemModel>> fetchJoinedCommunityList() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getJoinedCommunity.getUrl,
        reqName: Strings.joined,
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
    return response?.data ?? [];
  }

  Future<List<CommunityItemModel>> fetchSuggestedCommunityList() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getSuggestedCommunity.getUrl,
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
    return response?.data ?? [];
  }

  Future<List<CommunityItemModel>> fetchSearchedCommunityList({
    required String searchTxt,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getSearchedCommunity(searchTxt: searchTxt).getUrl,
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
    return response?.data ?? [];
  }
}
