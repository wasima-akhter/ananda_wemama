import '../../../../app/service_export.dart';
import '../../../features/auth/signin/model/signin_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';

class SigninService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<bool> signIn({required String email, required String password}) async {
    //
    print("Login started.."); // <--- ADD THIS
    apiCall() {
      return ApiClient().post(Endpoints.login.getUrl, data: {"email": email, "password": password});
    }

    final response = await _apiHelper.request<SigninModelData>(
      apiCall: apiCall,
      parser: (data) => SigninModelData.fromJson(data),
    );
    print("RESPONSE sign in: $response"); // <--- ADD THIS
    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      _saveUserDataAfterLogin(response: response);
      print("response.data?.user.name : ${response.data?.user.email}");

      print("access token login: ${response.data?.accessToken}");
    }

    return response.success;
  }

  void _saveUserDataAfterLogin({required BaseResponse<SigninModelData> response}) {
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
