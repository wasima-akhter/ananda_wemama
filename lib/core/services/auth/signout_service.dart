import '../../../app/service_export.dart';
import '../../../features/main_tabs/chat/controller/chat_controller.dart';
import '../../../features/main_tabs/chat/controller/chat_inbox_controller.dart';
import '../../../features/main_tabs/community/feed/controller/community_controller.dart';
import '../../../features/main_tabs/experts/controller/experts_controller.dart';
import '../../../features/main_tabs/home/controller/home_controller.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../features/main_tabs/match/controller/match_controller.dart';
import '../../../features/more/notification/controller/notification_controller.dart';
import '../../../features/shared/wave_request/controller/wave_request_controller.dart';
import '../../local/app_storage.dart';
import '../socket/socket_service.dart';

class SignoutService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<bool> signoutFromBackend() async {
    //

    apiCall() {
      return ApiClient().post(
        Endpoints.logout.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request(apiCall: apiCall);

    if (response == null) return false;

    return response.success;
  }

  Future<void> signOut() async {
    final res = await signoutFromBackend();

    if (!res) return;
    // Disconnect socket FIRST
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().disconnectSocket();
    }

    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().clearData();
    }

    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().notifications.clear();
    }

    if (Get.isRegistered<WaveRequestController>()) {
      Get.find<WaveRequestController>().newWaveList.clear();
    }

    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().userProfileData.value = null;
    }
    // Delete user-scoped controllers
    // final controllersToDelete = [
    //   ChatController,
    //   ChatInboxController,
    //   NotificationController,
    //   ProfileController,
    //   MatchController,
    //   WaveRequestController,
    //   HomeController,
    //   ExpertsController,
    //   CommunityController,
    // ];

    // for (final controller in controllersToDelete) {
    //   if (Get.isRegistered(tag: controller.toString())) {
    //     Get.delete(tag: controller.toString(), force: true);
    //   }
    // }

    // Delete user-scoped controllers.
    // NOTE: GetX generics must be written per-type — this replaces the old
    // `tag: controller.toString()` loop, which never matched anything
    // because these controllers are registered by type, not by tag.
    Get.delete<ChatController>(force: true);
    Get.delete<ChatInboxController>(force: true);
    Get.delete<NotificationController>(force: true);
    Get.delete<ProfileController>(force: true);
    Get.delete<MatchController>(force: true);
    Get.delete<WaveRequestController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<ExpertsController>(force: true);
    Get.delete<CommunityController>(force: true);

    // Clear storage
    AppStorage.to.logout();
  }
}
