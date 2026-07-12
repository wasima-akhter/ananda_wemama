import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../../../helpers/image_helper.dart';

class UpdateProfileService extends GetxService {
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

    if (children != null && children.isNotEmpty) {
      for (int i = 0; i < children.length; i++) {
        fields['children[$i][gender]'] = children[i]['gender']!;
        fields['children[$i][dob]'] = children[i]['dob']!;
      }
    }

    log("── updateProfileWithChildren ──────────────────────");
    log("fields: $fields");
    log("profileImage: ${profileImage?.path ?? 'null'}");
    log(
      "descriptionImages (${descriptionImages.length}): ${descriptionImages.map((f) => f.path).toList()}",
    );
    log("───────────────────────────────────────────────────");

    // Sanitize files (copies with clean names)
    final sanitizedProfile = profileImage != null
        ? sanitizeXFile(profileImage)
        : null;
    final sanitizedDesc = descriptionImages.map(sanitizeXFile).toList();

    try {
      final response = await ApiExecutor().execute<ProfileDataModel>(
        apiCall: () => ApiClient().patchWithFile(
          Endpoints.updateProfile.getUrl,
          file: sanitizedProfile != null
              ? MapEntry('profile-image', sanitizedProfile)
              : null,
          files: sanitizedDesc
              .map((f) => MapEntry('description-image', f))
              .toList(),
          fields: fields,
        ),
        parser: (data) => ProfileDataModel.fromJson(data),
      );

      return response.type == ApiResultType.failed ? null : response.data;
    } finally {
      // ✅ Clean up sanitized temp copies
      for (final f in [...sanitizedDesc, ?sanitizedProfile]) {
        try {
          final file = File(f.path);
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
    }
  }
}
