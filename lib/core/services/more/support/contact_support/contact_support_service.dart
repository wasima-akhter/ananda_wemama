import '../../../../../../app/service_export.dart';
import '../../../../../features/more/support/contact_support/model/contact_support_model.dart';

class ContactSupportService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<bool> sendSupportMsg({
    required String name,

    required String email,
    required String messageDes,
  }) async {
    //

    apiCall() {
      return ApiClient().post(
        Endpoints.contactSupportSubmit.getUrl,
        headers: HeaderHelpers.jsonHeader(),
        data: {"name": name, "email": email, "description": messageDes},
      );
    }

    final response = await _apiHelper.request<ContactAndSupportDataModel>(
      apiCall: apiCall,
      parser: (data) => ContactAndSupportDataModel.fromJson(data),
    );

    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      print("response.data?.createdAt : ${response.data?.createdAt}");
    }

    return response.success;
  }
}
