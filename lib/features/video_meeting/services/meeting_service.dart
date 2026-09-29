import 'dart:async';

import '../../../../app/service_export.dart';
import '../model/live_session_info_model.dart';

class MeetingService extends GetxService {
  /// Fetch inventory details from API

  // Future<LiveSessionInfoModel?> fetchSessionsInfo({
  //   required String channelName,
  // }) async {
  //   apiCall() {
  //     return ApiClient().get(
  //       Endpoints.joinLiveSessionInfo(channelName: channelName).getUrl,
  //       // reqName: Strings.attendLiveSessions,
  //       headers: HeaderHelpers.getAuthHeader(),
  //     );
  //   }

  //   final response = await ApiExecutor().execute<LiveSessionInfoModel?>(
  //     apiCall: apiCall,
  //     parser: (data) {
  //       print("parserdata: $data");
  //       return LiveSessionInfoModel.fromJson(data);
  //     },
  //   );

  //   print("response data: ${response?.data}");
  //   return response?.data;
  // }

  Future<LiveSessionInfoModel?> fetchSessionsInfo({
    required String channelName,
  }) async {
    print('🔵 fetchSessionsInfo called');
    print('🔵 fetchSessionsInfo called');
    print('🔵 channelName: $channelName');

    final endpoint = Endpoints.joinLiveSessionInfo(
      channelName: channelName,
    ).getUrl;
    print('🔵 API endpoint: $endpoint'); // ADD THIS

    apiCall() {
      print('🔵 [DIO] About to make HTTP GET request');
      return ApiClient()
          .get(endpoint, headers: HeaderHelpers.getAuthHeader())
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              print('❌ [DIO] REQUEST TIMEOUT after 15s');
              throw TimeoutException('API request timed out');
            },
          );
    }

    try {
      print('🔵 [DIO] Calling ApiExecutor.execute()');
      final response = await ApiExecutor().execute<LiveSessionInfoModel?>(
        apiCall: apiCall,
        parser: (data) {
          print('🔵 [DIO] Parser called');
          return LiveSessionInfoModel.fromJson(data);
        },
        showErrorMessage: true,
      );

      print('🔵 [DIO] ApiExecutor returned: ${response.type}');

      if (response.data != null) {
        print('📦 Response data not null');
      } else {
        print('⚠️ Response data is NULL - message: ${response.message}');
      }

      return response.data;
    } catch (e) {
      print('❌ fetchSessionsInfo caught exception: $e');
      print('❌ fetchSessionsInfo caught exception: $e');
      print('❌ Exception type: ${e.runtimeType}');
      print('❌ Exception type: ${e.runtimeType}');
      rethrow;
    }
  }
}
