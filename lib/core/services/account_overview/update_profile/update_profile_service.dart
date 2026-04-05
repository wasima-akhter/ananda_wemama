import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';

class UpdateProfileService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // Future<ProfileDataModel?> updateProfileWithChildren({
  //   required List<XFile> descriptionImages,
  //   XFile? profileImage,
  //   required String dob,
  //   required String state,
  //   required String city,
  //   required String bio,
  //   List<Map<String, String>>? children, // [{"gender":"Male","dob":"2019.05.12"}]
  // }) async {
  //   // Build FormData
  //   final data = dio.FormData();

  //   // Add file if exists
  //   if (profileImage != null) {
  //     final file = await dio.MultipartFile.fromFile(profileImage.path, filename: profileImage.name);
  //     data.files.add(MapEntry('profile-image', file)); // ✅ Exactly like Postman
  //   }

  //   // Add files
  //   final descriptionFiles = await Future.wait(
  //     descriptionImages.map(
  //       (image) => dio.MultipartFile.fromFile(image.path, filename: image.name),
  //     ),
  //   );

  //   data.files.addAll(descriptionFiles.map((file) => MapEntry('description-image', file)));

  //   // Add text fields
  //   data.fields
  //     ..add(MapEntry('DOB', dob))
  //     ..add(MapEntry('state', state))
  //     ..add(MapEntry('city', city))
  //     ..add(MapEntry('bio', bio));

  //   if (children != null) {
  //     for (int i = 0; i < children.length; i++) {
  //       data.fields.add(MapEntry('children[$i][gender]', children[i]['gender']!));
  //       data.fields.add(MapEntry('children[$i][dob]', children[i]['dob']!));
  //     }
  //   }

  //   apiCall() {
  //     return ApiClient().patchWithFile(
  //       Endpoints.updateProfile.getUrl,
  //       reqName: Strings.updateProfile,
  //       data: data,
  //     );
  //   }

  //  debugPrint(data.fields);
  //  debugPrint(data.files.map((e) => e.key).toList());

  //   debugPrint("UpdateProfileService - Storage.token: ${storage.getAccessToken}");

  //   final response = await _apiHelper.request<ProfileDataModel>(
  //     apiCall: apiCall,
  //     parser: (data) => ProfileDataModel.fromJson(data),
  //   );

  //   if (response == null || !response.success) return null;

  //   return response.data; // 👈 return actual data
  // }

  Future<ProfileDataModel?> updateProfileWithChildren({
    required List<XFile> descriptionImages,
    XFile? profileImage,
    required String dob,
    required String state,
    required String city,
    required String bio,
    required String name, // ✅ add name
    List<Map<String, String>>? children,
  }) async {
    final data = dio.FormData();

    // ── All files go under 'files' key — matches Postman ─────────────────────
    if (profileImage != null) {
      data.files.add(
        MapEntry(
          'profile-image',
          await dio.MultipartFile.fromFile(profileImage.path, filename: profileImage.name),
        ),
      );
    }

    for (final image in descriptionImages) {
      data.files.add(
        MapEntry(
          'description-image',
          await dio.MultipartFile.fromFile(image.path, filename: image.name),
        ),
      );
    }

    // ── Text fields ───────────────────────────────────────────────────────────
    data.fields
      // ..add(MapEntry('DOB', dob))
      ..add(MapEntry('state', state))
      ..add(MapEntry('city', city))
      ..add(MapEntry('bio', bio))
      ..add(MapEntry('name', name)); // ✅ add name

    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        data.fields.add(MapEntry('children[$i][gender]', children[i]['gender']!));
        data.fields.add(MapEntry('children[$i][dob]', children[i]['dob']!));
      }
    }

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

    final response = await _apiHelper.request<ProfileDataModel>(
      apiCall: () => ApiClient().patchWithFile(
        Endpoints.updateProfile.getUrl,
        reqName: Strings.updateProfile,
        data: data,
      ),
      parser: (data) => ProfileDataModel.fromJson(data),
    );

    if (response == null || !response.success) return null;
    return response.data;
  }
}
