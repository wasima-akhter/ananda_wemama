import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

import '../../../../../../app/service_export.dart';
import '../../../features/post_auth_setup/mums_stage/model/complete_profile_model.dart';

class PostSignupSetProfileService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

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
    //
    // 'name': 'soubir',
    // 'DOB': '2020.12.16',
    // 'state': 'Dhaka',
    // 'city': 'Mohakhali',
    // 'bio': 'Developer',
    // 'mumStage': 'Pregnant',
    // 'phone': '01641632319',
    // 'interesteds': [world, sdsdc]
    // 'profile-image': file

    // Build form data conditionally
    final data = dio.FormData();

    /// Text fields
    data.fields.add(MapEntry('name', name));
    data.fields.add(MapEntry('DOB', dob));
    data.fields.add(MapEntry('state', state));
    data.fields.add(MapEntry('city', city));
    data.fields.add(MapEntry('mumStage', mumStage));

    /// bio (optional)
    if (bioDes != null && bioDes.isNotEmpty) {
      data.fields.add(MapEntry('bio', bioDes));
    }

    /// interested fields → [ a, b, c ]
    if (interestedFields.isNotEmpty) {
      for (var field in interestedFields) {
        data.fields.add(MapEntry('interesteds', field));
      }
    }

    /// profile image
    ///     // Add file if exists
    if (profileImage != null) {
      final file = await dio.MultipartFile.fromFile(profileImage.path, filename: profileImage.name);

      data.files.add(MapEntry('profile-image', file));
    }

    apiCall() {
      return ApiClient().postWithFile(
        Endpoints.completeProfile.getUrl,
        reqName: Strings.setupProfile,
        data: data,
      );
    }

    final response = await _apiHelper.request<CompleteProfileModel>(
      apiCall: apiCall,
      parser: (data) => CompleteProfileModel.fromJson(data),
    );

    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      print("response.data?.createdAt : ${response.data?.createdAt}");
    }

    return response.success;
  }
}
