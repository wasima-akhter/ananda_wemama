import '../../../../../../app/service_export.dart';
import '../../../../../features/more/support/contact_support/model/contact_support_model.dart';

class ContactSupportService extends GetxService {
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

    final response = await ApiExecutor().execute<ContactAndSupportDataModel>(
      apiCall: apiCall,
      parser: (data) => ContactAndSupportDataModel.fromJson(data),
    );

    return response.type == ApiResultType.success;
  }
}
