import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama_app/features/main_tabs/community/model/community_item_model.dart';

import '../../../../app/service_export.dart';

class CommunityService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<bool> createCommunity({
    required XFile? communityImg,
    required String communityName,
  }) async {
    final data = dio.FormData();

    // ── All files go under 'files' key — matches Postman ─────────────────────
    if (communityImg != null) {
      data.files.add(
        MapEntry(
          'community-image',
          await dio.MultipartFile.fromFile(communityImg.path, filename: communityImg.name),
        ),
      );
    }

    // ── Text fields ───────────────────────────────────────────────────────────
    data.fields.add(MapEntry('name', communityName)); // ✅ add name

    debugPrint('fields: ${data.fields}');
    debugPrint('files count: ${data.files.length}');
    debugPrint('file keys: ${data.files.map((e) => e.key).toList()}');

    debugPrint('FIELDS:');
    for (var f in data.fields) {
      debugPrint('${f.key}: ${f.value}');
    }

    debugPrint('FILES:');
    for (var f in data.files) {
      debugPrint('${f.key}: ${f.value.filename}');
    }

    debugPrint("Token: ${storage.getAccessToken}");

    final response = await _apiHelper.request(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.createCommunity.getUrl,
        reqName: Strings.createCommunity,
        data: data,
      ),
    );

    if (response == null || !response.success) return false;

    debugPrint('response.success: ${response.success}');
    debugPrint('community id while create: ${response.data}');
    return true;
  }

  Future<bool> updateCommunity({
    required XFile? communityImg,
    required String? communityName,
    required String communityId,
  }) async {
    final data = dio.FormData();

    // ── All files go under 'files' key — matches Postman ─────────────────────
    if (communityImg != null) {
      data.files.add(
        MapEntry(
          'community-image',
          await dio.MultipartFile.fromFile(communityImg.path, filename: communityImg.name),
        ),
      );
    }

    // ── Text fields ───────────────────────────────────────────────────────────

    if (communityName != null) {
      data.fields.add(MapEntry('name', communityName)); // ✅ add name
    }

    data.fields.add(MapEntry('communityId', communityId)); // ✅ add name

    debugPrint('fields: ${data.fields}');
    debugPrint('files count: ${data.files.length}');
    debugPrint('file keys: ${data.files.map((e) => e.key).toList()}');

    debugPrint('FIELDS:');
    for (var f in data.fields) {
      debugPrint('${f.key}: ${f.value}');
    }

    debugPrint('FILES:');
    for (var f in data.files) {
      debugPrint('${f.key}: ${f.value.filename}');
    }

    debugPrint("Token: ${storage.getAccessToken}");

    final response = await _apiHelper.request(
      apiCall: () => ApiClient().patchWithFile(
        Endpoints.updateCommunity.getUrl,
        reqName: Strings.updateCommunity,
        data: data,
      ),
    );

    if (response == null || !response.success) return false;

    debugPrint('response.success: ${response.success}');
    debugPrint('community id while update : ${response.data}');
    return true;
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
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    print("response data: ${response?.data}");
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
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    print("response data: ${response?.data}");
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
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    print("response data: ${response?.data}");
    return response?.data ?? [];
  }

  Future<List<CommunityItemModel>> fetchSearchedCommunityList({required String searchTxt}) async {
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
        print("parserdata: ${data}");
        if (data is List) {
          return data.map((e) => CommunityItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    print("response data: ${response?.data}");
    return response?.data ?? [];
  }
}
