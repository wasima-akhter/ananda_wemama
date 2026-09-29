import '../../../../app/service_export.dart';
import '../../../features/auth/signin/model/signin_model.dart';
import '../../../features/auth/signup/model/signin_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import 'signin_service.dart';

class SignupService extends GetxService {
  Future<bool> signUp({
    required String email,
    required String password,
    required String conPassword,
  }) async {
    //

    apiCall() {
      return ApiClient().post(
        Endpoints.register.getUrl,
        headers: HeaderHelpers.jsonHeader(),

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

    final response = await ApiExecutor().execute<SignUpModelData>(
      apiCall: apiCall,
      parser: (data) => SignUpModelData.fromJson(data),
    ); // You can access user like:
    if (response.isSuccess) {
      // _saveUserDataAfterSignUp(response: response);
      print("response.data?.user.name : ${response.data?.email}");

      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.fetchMyProfile(); // fetch latest profile data
      }
    }

    return response.isSuccess;
  }

  Future<SocialLoginResult> socialSignup({
    required String authToken,
    required String provider,
  }) async {
    print("Social signup → provider: $provider");

    final response = await ApiClient().post(
      Endpoints.socialRegister.getUrl,
      headers: HeaderHelpers.jsonHeader(),
      data: {"provider": provider, "authToken": authToken},
    );

    if (response == null) {
      return const SocialLoginResult(type: SocialLoginApiResultType.failed);
    }

    final body = response.data;

    if (body is! Map<String, dynamic>) {
      return const SocialLoginResult(type: SocialLoginApiResultType.failed);
    }

    final data = SigninModelData.fromJson(body["data"] ?? {});

    print("Social signup statusCode: ${data.statusCode}");

    // ==========================
    // EMAIL NOT VERIFIED
    // ==========================

    if (data.statusCode == 403 || data.isEmailVerified == false) {
      return SocialLoginResult(
        type: SocialLoginApiResultType.failed,
        message: data.msg,
      );
    }

    // ==========================
    // PROFILE INCOMPLETE
    // ==========================

    if (data.statusCode == 302 || data.isProfileCompleted == false) {
      if (data.accessToken != null && data.accessToken!.isNotEmpty) {
        storage.setToken(data.accessToken!);
      }

      return SocialLoginResult(
        type: SocialLoginApiResultType.profileIncomplete,
        message: data.msg,
      );
    }

    // ==========================
    // TOKEN VALIDATION
    // ==========================

    final accessToken = data.accessToken ?? '';

    if (accessToken.isEmpty) {
      return const SocialLoginResult(type: SocialLoginApiResultType.failed);
    }

    // ==========================
    // SAVE LOGIN DATA
    // ==========================

    storage.setToken(accessToken);

    storage.setUserInfo(email: data.user?.email ?? '');

    print("Social signup success: ${data.user?.email}");

    return const SocialLoginResult(type: SocialLoginApiResultType.success);
  }

  //
}
