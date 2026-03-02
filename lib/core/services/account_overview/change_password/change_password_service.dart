import '../../../../../app/service_export.dart';

class ChangePasswordService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // Future<bool> changePassword({
  //   required String oldPassword,
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   //

  //   apiCall() {
  //     return ApiClient().patch(
  //       Endpoints.changePassword.getUrl,
  //       headers: HeaderHelpers.getAuthHeader(),
  //       data: {
  //         "oldPassword": oldPassword,
  //         "newPassword": newPassword,
  //         "confirmPassword": confirmPassword,
  //       },
  //     );
  //   }

  //   final response = await _apiHelper.request<ChangePassDataModel>(
  //     apiCall: apiCall,
  //     parser: (data) => ChangePassDataModel.fromJson(data),
  //   );

  //   if (response == null) return false;

  //   // You can access user like:
  //   if (response.success) {
  //     print("response.data?.user?.role : ${response.data?.user?.role}");
  //   }

  //   return response.success;
  // }
}
