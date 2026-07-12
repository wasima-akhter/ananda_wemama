import '../../../../app/service_export.dart';
import '../../../../core/network/base/api_executor.dart';
import '../model/expert_session_list_model.dart';

class ExpertsService extends GetxService {
  /// Fetch inventory details from API

  Future<ExpertSessionsListModel?> fetchExpertSessionList({
    required String sessionStatus,
    required String page,
    required String searchTxt,
  }) async {
    final result = await ApiExecutor().execute<ExpertSessionsListModel>(
      apiCall: () => ApiClient().get(
        Endpoints.getExpertSessionList(
          page: page,
          sessionStatus: sessionStatus,
          searchTxt: searchTxt,
        ).getUrl,
      ),
      parser: (data) => ExpertSessionsListModel.fromList(data),
    );

    return result.data;
  }

  //----------------------------

  Future<bool> uploadUpcomingSessionQues({
    required String expertId,
    required String sessionId,
    required String question,
  }) async {
    final result = await ApiExecutor().execute(
      apiCall: () => ApiClient().post(
        Endpoints.uploadSessionQuesUrl.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
        data: {"expert": expertId, "session": sessionId, "question": question},
      ),
    );

    return result.type == ApiResultType.success;
  }
}
