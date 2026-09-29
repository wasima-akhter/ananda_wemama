import '../../../../app/service_export.dart';
import '../../../../core/utils/paginator/paginator.dart';
import '../model/notifications_model.dart';

class NotificationService extends GetxService {
  /// Fetch inventory details from API

  Future<PaginatedResult<NotificationItemModel>> fetchNotificationsPaged({
    required int page,
    required int limit,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.notifications(limit: limit, page: page).getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<List<NotificationItemModel>>(
      apiCall: apiCall,
      parser: (data) {
        if (data is List) {
          return data.map((e) => NotificationItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    print("notification response data: ${response.data}");

    return PaginatedResult(data: response.data ?? [], meta: response.meta);
  }

  Future<bool> updateIsSeen({required String notificationId}) async {
    apiCall() {
      return ApiClient().patch(
        Endpoints.notificationIsSeenUpdate(
          notificationId: notificationId,
        ).getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute(apiCall: apiCall);

    return response.isSuccess;
  }
}
