import '../../../../app/service_export.dart';
import '../model/live_session_info_model.dart';

class MeetingService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<LiveSessionInfoModel?> fetchSessionsInfo({required String channelName}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.joinLiveSessionInfo(channelName: channelName).getUrl,
        reqName: Strings.attendLiveSessions,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<LiveSessionInfoModel?>(
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: ${data}");
        return LiveSessionInfoModel.fromJson(data);
      },
    );

    log("response data: ${response?.data}");
    return response?.data;
  }
}
