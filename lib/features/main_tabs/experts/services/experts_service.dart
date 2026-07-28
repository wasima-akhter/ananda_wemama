import '../../../../app/service_export.dart';
import '../../../../core/utils/extension/context_extension.dart';
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

  Future<Result<ExpertSessionsListModel>> fetchPastLibrarySessionList({
    required String sessionStatus,
    required String page,
    required String searchTxt,
  }) {
    return ApiExecutor().execute<ExpertSessionsListModel>(
      apiCall: () => ApiClient().get(
        Endpoints.getPastLibrarySessionList(
          page: page,
          sessionStatus: sessionStatus,
          searchTxt: searchTxt,
        ).getUrl,
      ),
      parser: (data) => ExpertSessionsListModel.fromList(data),
    );
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
    Get.back();
    if (result.type == ApiResultType.success) {
      Snack.showSuccess("${result.message}");
    }

    return result.type == ApiResultType.success;
  }

  //
  Future<bool> setReminder({required String sessionId}) async {
    final response = await ApiExecutor().execute(
      apiCall: () => ApiClient().post(
        Endpoints.setSessionReminder(sessionId: sessionId).getUrl,
        data: {},
      ),
      parser: (data) => data,
    );

    if (response.isSuccess) {
      Snack.showSuccess("${response.message}");
    }

    return response.isSuccess;
  }

  Future<bool> removeReminder({required String sessionId}) async {
    final response = await ApiExecutor().execute(
      apiCall: () => ApiClient().delete(
        Endpoints.removeSessionReminder(sessionId: sessionId).getUrl,
      ),
      parser: (data) => data,
    );

    if (response.isSuccess) {
      Snack.showSuccess("${response.message}");
    }
    return response.isSuccess;
  }
}
