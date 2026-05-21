import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';

class UpdateProfileService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // old
  /*
  Future<ProfileDataModel?> updateProfileWithChildren({
    required List<XFile> descriptionImages,
    XFile? profileImage,
    required String dob,
    required String state,
    required String city,
    required String bio,
    required String name,
    List<Map<String, String>>? children,
  }) async {
    final data = dio.FormData();

    // ───────────────── PROFILE IMAGE ─────────────────

    if (profileImage != null) {
      final compressedProfile = await MultipartHelper.compressedImage(
        File(profileImage.path),
      );

      if (compressedProfile != null) {
        data.files.add(MapEntry('profile-image', compressedProfile));
      }
    }

    // ───────────────── DESCRIPTION IMAGES ─────────────────

    for (final image in descriptionImages) {
      final compressedImage = await MultipartHelper.compressedImage(
        File(image.path),
      );

      if (compressedImage != null) {
        data.files.add(MapEntry('description-image', compressedImage));
      }
    }

    // ───────────────── TEXT FIELDS ─────────────────

    data.fields
      ..add(MapEntry('DOB', dob))
      ..add(MapEntry('state', state))
      ..add(MapEntry('city', city))
      ..add(MapEntry('bio', bio))
      ..add(MapEntry('name', name));

    // ───────────────── CHILDREN ─────────────────

    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        data.fields.add(
          MapEntry('children[$i][gender]', children[i]['gender']!),
        );

        data.fields.add(MapEntry('children[$i][dob]', children[i]['dob']!));
      }
    }

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

    final response = await _apiHelper.request<ProfileDataModel>(
      apiCall: () => ApiClient().patchWithFile(
        Endpoints.updateProfile.getUrl,
        reqName: Strings.updateProfile,
        data: data,
      ),
      parser: (data) => ProfileDataModel.fromJson(data),
    );

    if (response == null || !response.success) {
      return null;
    }

    return response.data;
  }

*/

  //
  Future<ProfileDataModel?> updateProfileWithChildren({
    required List<XFile> descriptionImages,
    XFile? profileImage,
    required String dob,
    required String state,
    required String city,
    required String bio,
    required String name,
    List<Map<String, String>>? children,
  }) async {
    final fields = {
      'DOB': dob,
      'state': state,
      'city': city,
      'bio': bio,
      'name': name,
    };

    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        fields['children[$i][gender]'] = children[i]['gender']!;
        fields['children[$i][dob]'] = children[i]['dob']!;
      }
    } else {
      // ✅ Tell backend explicitly: no children
      fields['children'] = '[]';
    }

    // ── Logs ────────────────────────────────────────────────────────────────
    log("── updateProfileWithChildren ──────────────────────");
    log("fields: $fields");
    log("profileImage: ${profileImage?.path ?? 'null'}");
    log(
      "descriptionImages (${descriptionImages.length}): ${descriptionImages.map((f) => f.path).toList()}",
    );
    log("───────────────────────────────────────────────────");

    final response = await _apiHelper.request<ProfileDataModel>(
      apiCall: () => ApiClient().patchWithFile(
        Endpoints.updateProfile.getUrl,
        reqName: Strings.updateProfile,
        file: profileImage != null
            ? MapEntry('profile-image', profileImage)
            : null,
        files: descriptionImages
            .map((f) => MapEntry('description-image', f))
            .toList(),
        fields: fields,
      ),
      parser: (data) => ProfileDataModel.fromJson(data),
    );

    return (response == null || !response.success) ? null : response.data;
  }
}
