import 'package:dio/dio.dart' as dio;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';

class UpdateProfileService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<ProfileDataModel?> updateProfileWithChildren({
    required List<XFile> descriptionImages,
    XFile? profileImage,
    required String dob,
    required String state,
    required String city,
    required String bio,
    List<Map<String, String>>? children, // [{"gender":"Male","dob":"2019.05.12"}]
  }) async {
    // Build FormData
    final data = dio.FormData();

    // Add file if exists
    if (profileImage != null) {
      final file = await dio.MultipartFile.fromFile(profileImage.path, filename: profileImage.name);
      data.files.add(MapEntry('profile-image', file)); // ✅ Exactly like Postman
    }

    // Add files
    final descriptionFiles = await Future.wait(
      descriptionImages.map(
        (image) => dio.MultipartFile.fromFile(image.path, filename: image.name),
      ),
    );

    data.files.addAll(descriptionFiles.map((file) => MapEntry('description-image', file)));

    // Add text fields
    data.fields
      ..add(MapEntry('DOB', dob))
      ..add(MapEntry('state', state))
      ..add(MapEntry('city', city))
      ..add(MapEntry('bio', bio));

    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        data.fields.add(MapEntry('children[$i][gender]', children[i]['gender']!));
        data.fields.add(MapEntry('children[$i][dob]', children[i]['dob']!));
      }
    }

    apiCall() {
      return ApiClient().patchWithFile(
        Endpoints.updateProfile.getUrl,
        reqName: Strings.updateProfile,
        data: data,
      );
    }

    print(data.fields);
    print(data.files.map((e) => e.key).toList());

    debugPrint("UpdateProfileService - Storage.token: ${storage.getAccessToken}");

    final response = await _apiHelper.request<ProfileDataModel>(
      apiCall: apiCall,
      parser: (data) => ProfileDataModel.fromJson(data),
    );

    if (response == null || !response.success) return null;

    return response.data; // 👈 return actual data
  }
}
