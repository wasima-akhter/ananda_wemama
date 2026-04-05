import 'package:mama_app/app/service_export.dart';
import 'package:mama_app/core/components/app_ui/popup_widgets/ask_ques_popup.dart';
import 'package:mama_app/features/shared/wave_request/widgets/new_waves_req_accept_popup.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../features/main_tabs/community/widgets/community_guildline.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../../../../features/shared/wave_request/widgets/new_waves_req_connected_popup.dart';
import '../../../../features/shared/wave_request/widgets/new_waves_user_details_popup.dart';
import '../../app_ui/popup_widgets/awaiting_verification_popup.dart';
import '../../app_ui/popup_widgets/cancel_order_dialog.dart';
import '../../app_ui/popup_widgets/daily_limit_popup.dart';
import '../../app_ui/popup_widgets/delete_confirm_dialog.dart';
import '../../app_ui/popup_widgets/edit_fuel_diesel_rate_popup.dart';
import '../../app_ui/popup_widgets/loading_popup.dart';
import '../../app_ui/popup_widgets/lock_comment_popup.dart';
import '../../app_ui/popup_widgets/logout_confirm_dialog.dart';
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
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (_, animation, __, ___) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
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
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (_, animation, __, ___) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
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
  return showAnimatedDialog(context: Get.context!, child: DailyLimitPopup());
}

Future<void> showLockCommentialog() {
  return showAnimatedDialog(context: Get.context!, child: LockCommentPopup());
}

Future<void> showAskYourQuesDialog({
  required void Function()? onTap,
  required TextEditingController writeQuesCtrl,
  required FocusNode writeQuesFocusNode,
}) {
  return showAnimatedDialog(
    context: Get.context!,
    barrierDismissible: true,
    child: AskQuesPopup(
      onTap: onTap,
      writeQuesCtrl: writeQuesCtrl,
      writeQuesFocusNode: writeQuesFocusNode,
    ),
  );
}

Future<void> communityGuidlineDialog({
  required bool isLoading,
  required Future<void> Function() onTapAction,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    insetPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
    content: CommunityGuildline(isLoading: isLoading, onTapAction: onTapAction),
  );
}

/// 🔹 newWavesUserDetailsDialog Popup
Future<void> newWavesUserDetailsDialog({
  required RxBool isLoading,
  required Future<void> Function(bool isAccepted) onTapAction,
  required RxBool isSeeMore,
  required void Function() onTapSeeMoreTxt,
  required Rxn<ProfileDataModel> user,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    content: NewWavesUserDetailsPopup(
      isLoading: isLoading,
      onTapAction: onTapAction,
      isSeeMore: isSeeMore,
      onTapSeeMore: onTapSeeMoreTxt,
      user: user,
    ),
  );
}

Future<void> showReqAcceptedDialog() async {
  await Popups().baseAlert(context: Get.context!, content: NewWavesReqAcceptPopup());
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
        return isupdateIsSeenLoading.value ? const LoadingPopup() : const SizedBox.shrink();
      });
    },
  );
}

/// 🔹 editFuelDieselRate Popup
Future<void> editFuelDieselRate({
  required String title,
  required FuelType type,
  required TextEditingController controller,
  required FocusNode focusNode,
  required RxBool isLoading,
  bool? isLoad,

  required VoidCallback onTapUpdatePrice,
  required GlobalKey<FormState> updatePriceFormKey,
}) async {
  await Popups().baseAlert(
    context: Get.context!,

    content: EditFuelDieselRatePopup(
      title: title,
      type: type,
      controller: controller,
      focusNode: focusNode,
      isLoading: isLoading,
      isLoad: isLoad,
      onTapUpdatePrice: onTapUpdatePrice,
      updatePriceFormKey: updatePriceFormKey,
    ),
  );
}

/// 🔹 Awaiting Verification Popup
Future<void> awaitingVerification({required VoidCallback onBackToLogin}) async {
  await Popups().baseAlert(
    context: Get.context!,
    content: AwaitingVerificationPopup(onBackToLogin: onBackToLogin),
  );
}

/// 🔹 Awaiting Verification Popup
Future<void> cancelOrderDialog({
  required bool isLoading,
  required Future<void> Function() onCancelOrder,
}) async {
  await Popups().baseAlert(
    context: Get.context!,
    content: CancelOrderDialog(isLoading: isLoading, onCancelOrder: onCancelOrder),
  );
}

/// 🔹 Awaiting Verification Popup
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
