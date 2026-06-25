import '../../../app/service_export.dart';
import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';

class SessionService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  //

  Future<Session?> getSessionById({required String sessionId}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getSessionDetailById(id: sessionId).getUrl,

        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<Session?>(
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: $data");
        final parsedData = Session.fromJson(data);

        return parsedData;
      },
    );

    log("response data: ${response?.data}");
    return response?.data;
  }

  //
}
