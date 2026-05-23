import 'package:image_picker/image_picker.dart';

import '../../../../../app/service_export.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';

class UpdateProfileService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

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
    // ✅ Don't send children field at all when empty
    // multipart/form-data can't represent JSON arrays — just omit it
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

// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// import '../../../../../app/service_export.dart';
// import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';
// import '../../../helpers/image_helper.dart';
// import '../../../local/app_storage.dart';

// class UpdateProfileService extends GetxService {
//   Future<ProfileDataModel?> updateProfileWithChildren({
//     required List<XFile> descriptionImages,
//     XFile? profileImage,
//     required String dob,
//     required String state,
//     required String city,
//     required String bio,
//     required String name,
//     List<Map<String, String>>? children,
//   }) async {
//     final token = AppStorage.to.getToken;
//     if (token.isEmpty) {
//       log("❌ updateProfileWithChildren aborted: no token");
//       return null;
//     }

//     // ── Build fields ────────────────────────────────
//     final fields = <String, String>{};
//     if (name.isNotEmpty) fields['name'] = name;
//     if (dob.isNotEmpty) fields['DOB'] = dob;
//     if (state.isNotEmpty) fields['state'] = state;
//     if (city.isNotEmpty) fields['city'] = city;
//     if (bio.isNotEmpty) fields['bio'] = bio;

//     if (children != null && children.isNotEmpty) {
//       for (int i = 0; i < children.length; i++) {
//         fields['children[$i][gender]'] = children[i]['gender']!;
//         fields['children[$i][dob]'] = children[i]['dob']!;
//       }
//     }

//     // ── Logs ────────────────────────────────────────
//     log("── updateProfileWithChildren ──────────────────────");
//     log("fields: $fields");
//     log("profileImage: ${profileImage?.path ?? 'null'}");
//     log(
//       "descriptionImages (${descriptionImages.length}): ${descriptionImages.map((f) => f.path).toList()}",
//     );
//     log("───────────────────────────────────────────────────");

//     try {
//       final uri = Uri.parse(Endpoints.updateProfile.getUrl);
//       final request = http.MultipartRequest('PATCH', uri);

//       // ── Headers ─────────────────────────────────
//       request.headers['Authorization'] = 'Bearer $token';
//       request.headers['Accept'] = 'application/json';

//       // ── Fields ──────────────────────────────────
//       request.fields.addAll(fields);

//       // ── Profile image ────────────────────────────
//       if (profileImage != null) {
//         final compressed = await MultipartHelper.compressedImage(
//           File(profileImage.path),
//         );

//         final bytes = compressed != null
//             ? await File(profileImage.path).readAsBytes()
//             : await File(profileImage.path).readAsBytes();

//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'profile-image',
//             bytes,
//             filename: profileImage.name,
//           ),
//         );
//       }

//       // ── Description images ───────────────────────
//       for (final image in descriptionImages) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'description-image',
//             image.path,
//             filename: image.name,
//           ),
//         );
//       }

//       log("➡️ REQUEST[PATCH] => ${uri.toString()}");
//       log("Headers: ${request.headers}");
//       log("Fields: ${request.fields}");
//       log(
//         "Files: ${request.files.map((f) => '${f.field}: ${f.filename}').toList()}",
//       );

//       // ── Send ─────────────────────────────────────
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       log("✅ RESPONSE[${response.statusCode}] => ${response.body}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final decoded = jsonDecode(response.body) as Map<String, dynamic>;
//         final success = decoded['success'] as bool? ?? false;

//         if (!success) {
//           log("❌ API returned success=false: ${decoded['message']}");
//           return null;
//         }

//         final data = decoded['data'] as Map<String, dynamic>?;
//         if (data == null) return null;

//         return ProfileDataModel.fromJson(data);
//       } else {
//         log("❌ ERROR[${response.statusCode}] => ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       log("❌ updateProfileWithChildren error: $e");
//       return null;
//     }
//   }
// }
