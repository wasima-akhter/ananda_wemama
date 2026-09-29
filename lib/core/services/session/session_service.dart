import '../../../app/service_export.dart';
import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';

class SessionService {
  //

  Future<Session?> getSessionById({required String sessionId}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getSessionDetailById(id: sessionId).getUrl,

        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<Session?>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: $data");
        final parsedData = Session.fromJson(data);

        return parsedData;
      },
    );

    print("response data: ${response?.data}");
    return response?.data;
  }

  //
}
