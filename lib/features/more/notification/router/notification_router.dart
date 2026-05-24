import '../../../../app/helper_widgets_export.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../model/notifications_model.dart';

class NotificationRouter {
  static Future<void> route(NotificationItemModel n) async {
    switch (n.type) {
      case NotificationTypes.likePost:
      case NotificationTypes.commentPost:
        if (n.referenceId == null) return;

        // take both post id and community id

        // Get.toNamed(
        //   RoutePaths.postDetails,
        //   // arguments: PostDetailArgModel.fromNotification(postId: n.referenceId!),
        //   arguments: PostDetailArgModel(
        //     communityData: Community(id: n.referenceId ?? ''),
        //     postItem: AllPost(id: n.id ?? ''),
        //   ),
        // );
        break;

      case NotificationTypes.approveCommunity:
        if (n.referenceId == null) return;

        Get.toNamed(
          RoutePaths.communityDetail,
          arguments: {
            'btnState': MyCommunityBtnState.manage,
            'communityItemId': n.referenceId,
          },
        );
        break;

      case NotificationTypes.acceptWave:
        Get.offAllNamed(RoutePaths.mainNav); //chat
        MainNavController.to.goToTab(1);
        break;

      case NotificationTypes.sentMessage:
      case NotificationTypes.sentWave:
      case NotificationTypes.rejectWave:
      case NotificationTypes.other:
      default:
        break;
    }
  }
}
