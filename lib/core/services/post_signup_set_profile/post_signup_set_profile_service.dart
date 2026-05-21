import 'package:image_picker/image_picker.dart';

import '../../../../../../app/service_export.dart';
import '../../../features/post_auth_setup/mums_stage/model/complete_profile_model.dart';

class PostSignupSetProfileService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();
  /*
  Future<bool> uploadCompleteProfile({
    required String name,
    required String dob,
    required String state,
    required String city,
    String? bioDes,
    required List<String> interestedFields,
    required String mumStage,
    XFile? profileImage,
  }) async {
    final data = dio.FormData();

    // ───────────────── TEXT FIELDS ─────────────────

    data.fields
      ..add(MapEntry('name', name))
      ..add(MapEntry('DOB', dob))
      ..add(MapEntry('state', state))
      ..add(MapEntry('city', city))
      ..add(MapEntry('mumStage', mumStage));

    if (bioDes != null && bioDes.trim().isNotEmpty) {
      data.fields.add(MapEntry('bio', bioDes.trim()));
    }

    for (final field in interestedFields) {
      data.fields.add(MapEntry('interesteds', field));
    }

    // ───────────────── PROFILE IMAGE (COMPRESSED) ─────────────────

    if (profileImage != null) {
      final compressed = await MultipartHelper.compressedImage(
        File(profileImage.path),
      );

      if (compressed == null) {
        "Image compression failed".showToast();
        return false;
      }

      data.files.add(MapEntry('profile-image', compressed));
    }

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

    final response = await _apiHelper.request<CompleteProfileModel>(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.completeProfile.getUrl,
        reqName: Strings.setupProfile,
        data: data,
      ),
      parser: (data) => CompleteProfileModel.fromJson(data),
    );

    if (response == null) return false;

    if (response.success) {
      log("response.data?.createdAt : ${response.data?.createdAt}");
    }

    return response.success;
  }

*/
  Future<bool> uploadCompleteProfile({
    required String name,
    required String dob,
    required String state,
    required String city,
    String? bioDes,
    required List<String> interestedFields,
    required String mumStage,
    XFile? profileImage,
  }) async {
    final response = await _apiHelper.request<CompleteProfileModel>(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.completeProfile.getUrl,
        reqName: Strings.setupProfile,
        file: profileImage != null
            ? MapEntry('profile-image', profileImage)
            : null,
        fields: {
          'name': name,
          'DOB': dob,
          'state': state,
          'city': city,
          'mumStage': mumStage,
          if (bioDes != null && bioDes.trim().isNotEmpty) 'bio': bioDes.trim(),
        },
        extraFields: interestedFields
            .map((f) => MapEntry('interesteds', f))
            .toList(),
      ),
      parser: (data) => CompleteProfileModel.fromJson(data),
    );

    return response != null && response.success;
  }
}
