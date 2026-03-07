import 'package:dio/dio.dart' as dio;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart'; 

class UpdateProfileService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<ProfileDataModel?> updateProfile({
    required String name,
    String? phone,
    XFile? profileImage,
  }) async {
    // Build form data conditionally
    final data = dio.FormData();
    // Add text fields
    data.fields.add(MapEntry('name', name));
    data.fields.add(MapEntry('phone', phone ?? ''));

    // Add file if exists
    if (profileImage != null) {
      final file = await dio.MultipartFile.fromFile(profileImage.path, filename: profileImage.name);
      data.files.add(MapEntry('profile-image', file)); // ✅ Exactly like Postman
    }

    apiCall() {
      return ApiClient().patchWithFile(
        Endpoints.updateProfile.getUrl,
        reqName: Strings.updateProfile,
        data: data,
      );
    }

    debugPrint("UpdateProfileService - Storage.token: ${storage.getAccessToken}");

    final response = await _apiHelper.request<ProfileDataModel>(
      apiCall: apiCall,
      parser: (data) => ProfileDataModel.fromJson(data),
    );

    if (response == null || !response.success) return null;

    return response.data; // 👈 return actual data
  }
}
