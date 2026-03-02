import '../../../../../app/service_export.dart';
import '../../../../features/more/notification/model/notifications_model.dart';

class NotificationService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<List<NotificationsDataModel>> fetchNotifications() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.notifications.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<List<NotificationsDataModel>>(
      apiCall: apiCall,
      parser: (data) {
        return (data as List).map((e) => NotificationsDataModel.fromJson(e)).toList();
      },
    );

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
