import 'package:mama_app/app/controller_export.dart';

import '../../../../app/service_export.dart';
import '../../../features/auth/signin/model/signin_model.dart';
import '../../../features/auth/signup/model/signin_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import 'signin_service.dart';

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
        // headers: HeaderHelpers.getAuthHeader(),

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

  Future<SocialLoginResult> socialSignup({
    required String authToken,
    required String provider,
  }) async {
    final response = await _apiHelper.request<SigninModelData>(
      apiCall: () => ApiClient().post(
        Endpoints.socialRegister.getUrl,
        data: {"provider": provider, "authToken": authToken},
        isLogin_: true,
        reqName: 'social signup'.capEachWord(),
      ),
      parser: (data) => SigninModelData.fromJson(data),
    );

    if (response == null || response.data == null) {
      return const SocialLoginResult(type: SocialLoginResultType.failed);
    }

    final data = response.data!;
    final accessToken = data.accessToken ?? '';

    if (accessToken.isEmpty) {
      return const SocialLoginResult(type: SocialLoginResultType.failed);
    }

    // save token and email if success

    storage.setToken(accessToken);
    storage.setUserInfo(email: data.user?.email ?? '');

    return const SocialLoginResult(type: SocialLoginResultType.success);
  }
}
