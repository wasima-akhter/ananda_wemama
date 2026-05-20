import '../../../../app/service_export.dart';
import '../../../features/auth/signin/model/signin_model.dart';
import '../../../features/auth/signup/model/signin_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';

class SignupService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<bool> signUp({
    required String email,
    required String password,
    required String conPassword,
  }) async {
    //

    apiCall() {
      return ApiClient().post(
        Endpoints.register.getUrl,
        headers: HeaderHelpers.getAuthHeader(),

        //         {
        //     "email": "ananda@yopmail.com",
        //     "password": "123456",
        //     "confirmPassword": "123456"
        // }
        data: {
          "email": email,
          "password": password,
          "confirmPassword": conPassword,
        },
      );
    }

    final response = await _apiHelper.request<SignUpModelData>(
      apiCall: apiCall,
      parser: (data) => SignUpModelData.fromJson(data),
    );

    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      // _saveUserDataAfterSignUp(response: response);
      log("response.data?.user.name : ${response.data?.email}");

      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.fetchMyProfile(); // fetch latest profile data
      }
    }

    return response.success;
  }

  void _saveUserDataAfterSignUp({
    required BaseResponse<SigninModelData> response,
  }) {
    // as success,
    // save the access token in app storage
    // save the user info in appstorage
    if (response.data != null) {
      final user = response.data?.user;
      final fetchedEmail = user?.email;

      storage.setUserInfo(email: fetchedEmail);

      // set user role
      // UserRole

      // token
      storage.setToken(response.data!.accessToken);

      // ✅ Now call ProfileController to refresh the profile
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.fetchMyProfile(); // fetch latest profile data
      }
    }
  }
}
