import '../../../../app/service_export.dart';

class SigninService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // Future<bool> signIn({required String email, required String password}) async {
  //   //
  //   print("Login started.."); // <--- ADD THIS
  //   apiCall() {
  //     return ApiClient().post(
  //       Endpoints.login.getUrl,
  //       headers: HeaderHelpers.getAuthHeader(),
  //       data: {"email": email, "password": password},
  //     );
  //   }

  //   final response = await _apiHelper.request<SigninModelData>(
  //     apiCall: apiCall,
  //     parser: (data) => SigninModelData.fromJson(data),
  //   );
  //   print("RESPONSE sign in: $response"); // <--- ADD THIS
  //   if (response == null) return false;

  //   // You can access user like:
  //   if (response.success) {
  //     _saveUserDataAfterLogin(response: response);
  //     print("response.data?.user.name : ${response.data?.user.name}");
  //   }

  //   return response.success;
  // }

  // void _saveUserDataAfterLogin({required BaseResponse<SigninModelData> response}) {
  //   // as success,
  //   // save the access token in app storage
  //   // save the user info in appstorage
  //   if (response.data != null) {
  //     final user = response.data?.user;
  //     final fetchedEmail = user?.email;
  //     final fetchedname = user?.name;
  //     final fetchedPhone = user?.phone;
  //     final fetchedRole = user?.role;
  //     storage.setUserInfo(
  //       email: fetchedEmail,
  //       name: fetchedname,
  //       phone: fetchedPhone,
  //       role: fetchedRole,
  //     );

  //     // set user role
  //     // UserRole

  //     storage.setUserRole(response.data!.user.role.toUserRole() ?? UserRole.customer);

  //     // token
  //     storage.setToken(response.data!.accessToken);

  //     // ✅ Now call ProfileController to refresh the profile
  //     if (Get.isRegistered<ProfileController>()) {
  //       final profileController = Get.find<ProfileController>();
  //       profileController.fetchMyProfile(); // fetch latest profile data
  //     }
  //   }
  // }
}
