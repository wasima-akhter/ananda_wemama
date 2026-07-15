import 'package:mama_app/core/components/app_ui/popup_widgets/ask_ques_popup.dart';
import 'package:mama_app/core/components/app_ui/popup_widgets/live_end_msg_popup.dart';
import 'package:mama_app/features/shared/wave_request/widgets/new_waves_req_accept_popup.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../features/main_tabs/chat/widgets/chat_user_details_popup.dart';
import '../../../../features/main_tabs/community/shared_ui/community_guildline.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../../../../features/shared/wave_request/widgets/new_waves_req_connected_popup.dart';
import '../../../../features/shared/wave_request/widgets/new_waves_user_details_popup.dart';
import '../../../../features/video_meeting/controller/fullscreen_video_controller.dart';
import '../../app_ui/popup_widgets/awaiting_verification_popup.dart';
import '../../app_ui/popup_widgets/daily_limit_popup.dart';
import '../../app_ui/popup_widgets/delete_confirm_dialog.dart';
import '../../app_ui/popup_widgets/image_viewer.dart';
import '../../app_ui/popup_widgets/loading_popup.dart';
import '../../app_ui/popup_widgets/lock_comment_popup.dart';
import '../../app_ui/popup_widgets/logout_confirm_dialog.dart';
import '../../app_ui/popup_widgets/reset_pass_confirm_dialog.dart';
import '../../app_ui/popup_widgets/wave_sent_popup.dart';

class Popups {
  Future<void> baseAlert({
    required BuildContext context,
    EdgeInsets? insetPadding,
    required Widget content,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (_, animation, _, _) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              insetPadding:
                  insetPadding ??
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
              backgroundColor: Colors.transparent,
              clipBehavior: Clip.none,
              child: content,
            ),
          ),
        );
      },
    );
  }
}

Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = false,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) => const SizedBox.shrink(),

    transitionBuilder: (context, animation, _, _) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
              child: FadeTransition(opacity: animation, child: child),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showImageViewer({
  required BuildContext context,
  required dynamic imageSource, // String (url/path), File, XFile
}) async {
  await showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    child: ImageViewerPopup(imageSource: imageSource),
  );
}

//
Future<void> showWaveSentDialog({required RxBool stopSearching}) {
  return showAnimatedDialog(
    context: Get.context!,
    child: WaveSentPopup(stopSearching: stopSearching),
  );
}

Future<void> showDailyLimitDialog() {
  return showAnimatedDialog(
    context: Get.context!,
    barrierDismissible: true,
    child: DailyLimitPopup(),
  );
}

Future<void> showLockCommentialog({required bool isLocked}) {
  return showAnimatedDialog(
    context: Get.context!,
    child: LockCommentPopup(isLocked: isLocked),
  );
}

Future<void> showAskYourQuesDialog({
  required void Function()? onTap,
  required TextEditingController writeQuesCtrl,
  required FocusNode writeQuesFocusNode,
  required RxBool isSendQuesLoading,
}) {
  return showAnimatedDialog(
    context: Get.context!,
    barrierDismissible: true,
    child: AskQuesPopup(
      onTap: onTap,
      isSendQuesLoading: isSendQuesLoading,

      writeQuesCtrl: writeQuesCtrl,
      writeQuesFocusNode: writeQuesFocusNode,
    ),
  );
}

Future<void> communityGuidlineDialog({
  required bool isLoading,
  required Future<void> Function() onTapAction,
  bool? hasButton,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    insetPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
    content: CommunityGuildline(
      isLoading: isLoading,
      hasButton: hasButton,
      onTapAction: onTapAction,
    ),
  );
}

/// 🔹 newWavesUserDetailsDialog Popup
Future<void> newWavesUserDetailsDialog({
  required RxBool isLoading,
  required Future<void> Function(bool isAccepted) onTapAction,
  required RxBool isSeeMore,
  required void Function() onTapSeeMoreTxt,
  required Rxn<ProfileDataModel> user,
  required RxBool isAcceptLoading,
  required RxBool isRejectLoading,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    content: NewWavesUserDetailsPopup(
      isLoading: isLoading,
      onTapAction: onTapAction,
      isSeeMore: isSeeMore,
      onTapSeeMore: onTapSeeMoreTxt,
      user: user,
      isAcceptLoading: isAcceptLoading,
      isRejectLoading: isRejectLoading,
    ),
  );
}

/// 🔹 newWavesUserDetailsDialog Popup
Future<void> chatUserDetailsDialog({
  required RxBool isLoading,
  required RxBool isSeeMore,
  required void Function() onTapSeeMoreTxt,
  required Rxn<ProfileDataModel> user,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    content: ChatUserDetailsPopup(
      isLoading: isLoading,
      isSeeMore: isSeeMore,
      onTapSeeMore: onTapSeeMoreTxt,
      user: user,
    ),
  );
}

Future<void> showReqAcceptedDialog() async {
  await Popups().baseAlert(
    context: Get.context!,
    content: NewWavesReqAcceptPopup(),
  );
}

Future<void> showBothConnectedDialog({
  required String myImageUrl,
  required String peerImageUrl,
  required String peerName,
  required String conversationId,
}) async {
  await Popups().baseAlert(
    insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
    context: Get.context!,
    content: NewWavesReqConnectedPopup(
      myImageUrl: myImageUrl,
      peerImageUrl: peerImageUrl,
      peerName: peerName,
      conversationId: conversationId,
    ),
  );
}

Future<void> deletePostConfirmDialog({
  required RxBool isLoading,
  required Future<void> Function() onConfirm,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    content: DeleteConfirmDialog(isLoading: isLoading, onConfirm: onConfirm),
  );
}

// lib/core/components/ui/dialogs/popups.dart
// Replace your showLiveEndMsg with these:

Future<void> showLiveExitPopup(
  LiveExitReason reason, {
  VoidCallback? onRejoin,
  Function(bool)? onTapCancel,
  void Function(BuildContext dialogContext)? onDialogShown, // 👈 NEW, optional
}) async {
  // 👇 NEW: if fullscreen video page is currently active, exit it first
  // so the popup never renders in landscape/fullscreen mode.
  if (Get.isRegistered<FullscreenVideoController>()) {
    log('🔵 Fullscreen active — exiting before showing popup');
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back(); // pops FullscreenVideoPage, triggers its dispose()
    }
    // give orientation + navigation time to settle before showing dialog
    await Future.delayed(const Duration(milliseconds: 350));
  }
  final isBlocking =
      reason == LiveExitReason.kicked ||
      reason == LiveExitReason.connectionLost;
  return showDialog(
    context: Get.context!,
    barrierDismissible: !isBlocking,
    builder: (dialogContext) {
      onDialogShown?.call(
        dialogContext,
      ); // 👈 hand back this dialog's own context
      return LiveSessionExitPopup(
        reason: reason,
        onRejoin: onRejoin,
        onTapCancel: onTapCancel,
      );
    },
  );
}

//////////////////////////////////////////
///
///  new waves popup
///
///
/////////////////////////////////////////

Future<void> showLoading({required RxBool isupdateIsSeenLoading}) {
  return showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (_) {
      return Obx(() {
        return isupdateIsSeenLoading.value
            ? const LoadingPopup()
            : const SizedBox.shrink();
      });
    },
  );
}

/// 🔹 Awaiting Verification Popup
Future<void> awaitingVerification({required VoidCallback onBackToLogin}) async {
  await Popups().baseAlert(
    context: Get.context!,
    content: AwaitingVerificationPopup(onBackToLogin: onBackToLogin),
  );
}

/// 🔹  logoutConfirmDialog Popup
Future<void> logoutConfirmDialog({
  required RxBool isLoading,
  required Future<void> Function() onConfirm,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
    content: LogoutConfirmDialog(isLoading: isLoading, onConfirm: onConfirm),
  );
}

/// 🔹 Reset Password Confirmation Popup
Future<void> resetPasswordConfirmDialog({
  required Future<void> Function() onConfirm,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
    content: ResetPasswordConfirmDialog(),
  );
}

/* call like:
Alerts().baseAlert(
   context: Get.context!,
  content: DeliveryFeedbackDialog(
    isLoading: controller.feedbackLoading.value,
    onSubmit: (rating, feedback) async {
      await controller.submitFeedback(rating, feedback);
      GNav.pop();
    },
  ),
);
*/
