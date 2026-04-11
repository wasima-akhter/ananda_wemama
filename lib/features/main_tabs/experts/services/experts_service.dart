import '../../../../app/service_export.dart';
import '../model/expert_session_list_model.dart';

class ExpertsService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<ExpertSessionsListModel?> fetchExpertSessionList({
    required String sessionStatus,
    required String page,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getExpertSessionList(page: page, sessionStatus: sessionStatus).getUrl,
        reqName: Strings.experts,
        headers: HeaderHelpers.jsonHeader(),
      );
    }

    final response = await _apiHelper.request<ExpertSessionsListModel?>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");

        final responseData = ExpertSessionsListModel.fromJson(data);

        return responseData;
      },
    );

    print("response data: ${response?.data}");
    return response?.data;
  }
}
