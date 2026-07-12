import 'package:image_picker/image_picker.dart';

import '../../../../../../app/service_export.dart';
import '../../../features/post_auth_setup/mums_stage/model/complete_profile_model.dart';

class PostSignupSetProfileService extends GetxService {
  //
  Future<bool> uploadCompleteProfile({
    required String name,
    required String dob,
    required bool isDobPrivate,
    required String state,
    required String city,
    String? bioDes,
    required List<String> interestedFields,
    required List<String> mumStages,
    List<Map<String, String>>? children,
    XFile? profileImage,
  }) async {
    final fields = {
      'name': name,
      'DOB[date]': dob,
      'DOB[isPublic]': (!isDobPrivate),
      'state': state,
      'city': city,
    };

    // bio
    if (bioDes != null && bioDes.trim().isNotEmpty) {
      fields['bio'] = bioDes.trim();
    } // children
    if (children != null && children.isNotEmpty) {
      for (int i = 0; i < children.length; i++) {
        fields['children[$i][gender]'] = children[i]['gender']!;
        fields['children[$i][dob]'] = children[i]['dob']!;
      }
    } // mum stages
    if (mumStages.isNotEmpty) {
      for (int i = 0; i < mumStages.length; i++) {
        fields['mumStage[$i]'] = mumStages[i];
      }
    }
    final response = await ApiExecutor().execute<CompleteProfileModel>(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.completeProfile.getUrl,

        // reqName: Strings.setupProfile,
        file: profileImage != null
            ? MapEntry('profile-image', profileImage)
            : null,

        fields: fields,
        extraFields: interestedFields
            .map((f) => MapEntry('interesteds', f))
            .toList(),
      ),
      parser: (data) => CompleteProfileModel.fromJson(data),
    );

    return response.isSuccess;
  }
}
