import '../../../../app/service_export.dart';

class SignupService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // Future<bool> signUp({
  //   required String name,
  //   required String phone,
  //   required String email,
  //   required String password,
  //   required String conPassword,
  // }) async {
  //   //

  //   apiCall() {
  //     return ApiClient().post(
  //       Endpoints.register.getUrl,
  //       headers: HeaderHelpers.getAuthHeader(),
  //       data: {
  //         "name": name,
  //         "phone": phone,
  //         "email": email,
  //         "password": password,
  //         "confirmPassword": conPassword,
  //         "role": roleFromChooseScreen,
  //       },
  //     );
  //   }

  //   final response = await _apiHelper.request<SignupModelData>(
  //     apiCall: apiCall,
  //     parser: (data) => SignupModelData.fromJson(data),
  //   );

  //   if (response == null) return false;

  //   // You can access user like:
  //   if (response.success) {
  //     _saveUserDataAfterSignUp(response: response);
  //     print("response.data?.user.name : ${response.data?.newUser?.name}");
  //   }

  //   return response.success;
  // }

  // void _saveUserDataAfterSignUp({required BaseResponse<SignupModelData> response}) {
  //   // as success,
  //   // save the access token in app storage
  //   // save the user info in appstorage
  //   if (response.data != null) {
  //     final user = response.data?.newUser;
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
  //   }
  // }
}
