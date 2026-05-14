import '../../../../app/service_export.dart';
import '../model/notifications_model.dart';

class NotificationService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<List<NotificationItemModel>> fetchNotifications() async {
    apiCall() {
      return ApiClient().get(
        // Endpoints.getMatch(lat: latitude, long: longitude).getUrl,
        Endpoints.notifications.getUrl,
        reqName: Strings.notification,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<NotificationItemModel>>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");

        if (data == null) return [];

        return (data is List) ? data.map((e) => NotificationItemModel.fromJson(e)).toList() : [];
      },
    );

    print("response data: ${response?.data}");
    return response?.data ?? [];
  }

  Future<bool> updateIsSeen({required String notificationId}) async {
    apiCall() {
      return ApiClient().patch(
        Endpoints.notificationIsSeenUpdate(notificationId: notificationId).getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);

    if (response == null) return false;
    return response.success;
  }
}
