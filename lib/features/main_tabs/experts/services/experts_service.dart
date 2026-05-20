import '../../../../app/service_export.dart';
import '../model/expert_session_list_model.dart';

class ExpertsService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<ExpertSessionsListModel?> fetchExpertSessionList({
    required String sessionStatus,
    required String page,
    required String searchTxt,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getExpertSessionList(
          page: page,
          sessionStatus: sessionStatus,
          searchTxt: searchTxt,
        ).getUrl,
        reqName: Strings.experts,
        headers: HeaderHelpers.jsonHeader(),
      );
    }

    final response = await _apiHelper.request<ExpertSessionsListModel?>(
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: $data");

        final responseData = ExpertSessionsListModel.fromJson(data);

        return responseData;
      },
    );

    log("response data: ${response?.data}");
    return response?.data;
  }

  //----------------------------

  Future<bool> uploadUpcomingSessionQues({
    required String expertId,
    required String sessionId,
    required String question,
  }) async {
    apiCall() {
      return ApiClient().post(
        Endpoints.uploadSessionQuesUrl.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
        data: {"expert": expertId, "session": sessionId, "question": question},
      );
    }

    final response = await _apiHelper.request<void>(apiCall: () => apiCall());

    if (response == null) return false;

    // You can access user like:
    if (response.success) {
      log("Send question is success!");
    }

    return true;
  }
}
