import 'package:mama_app/app/service_export.dart';

import '../../app/helper_widgets_export.dart';
import '../../features/shared/wave_request/widgets/new_waves_user_details_popup.dart';
import 'popup_widgets/awaiting_verification_popup.dart';
import 'popup_widgets/cancel_order_dialog.dart';
import 'popup_widgets/delivery_feedback_dialog.dart';
import 'popup_widgets/edit_fuel_diesel_rate_popup.dart';
import 'popup_widgets/loading_popup.dart';
import 'popup_widgets/logout_confirm_dialog.dart';

class Popups {
  Future<void> baseAlert({required BuildContext context, required Widget content}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          backgroundColor: Colors.transparent,
          clipBehavior: Clip.none,
          child: Container(
            // width: S.w - 60,
            // constraints: const BoxConstraints(maxWidth: 480),

            // padding: const EdgeInsets.all(20),
            // decoration: BoxDecoration(color: bgClr, borderRadius: (20).brdrRad),
            // child: content,
            child: content,
          ),
        );
      },
    );
  }
}

/// 🔹 Awaiting Verification Popup
Future<void> newWavesUserDetailsDialog({
  required BuildContext context,
  required bool isLoading,
  required Future<void> Function() onTapDeclineOrAccept,
  required RxBool isSeeMore,
  required void Function() onTapSeeMoreTxt,
}) async {
  await Popups().baseAlert(
    context: context,
    content: NewWavesUserDetailsPopup(
      isLoading: isLoading,
      onTapDeclineOrAccept: onTapDeclineOrAccept,
      isSeeMore: isSeeMore,
      onTapSeeMoreTxt: onTapSeeMoreTxt,
    ),
  );
}

//////////////////////////////////////////
///
///  new waves popup
///
///
/////////////////////////////////////////

Future<void> showLoading({required BuildContext context, required RxBool isupdateIsSeenLoading}) {
  return showDialog(
    context: context,
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
  required BuildContext context,
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
    context: context,

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
Future<void> awaitingVerification({
  required BuildContext context,
  required VoidCallback onBackToLogin,
}) async {
  await Popups().baseAlert(
    context: context,
    content: AwaitingVerificationPopup(onBackToLogin: onBackToLogin),
  );
}

/// 🔹 Awaiting Verification Popup
Future<void> cancelOrderDialog({
  required BuildContext context,
  required bool isLoading,
  required Future<void> Function() onCancelOrder,
}) async {
  await Popups().baseAlert(
    context: context,
    content: CancelOrderDialog(isLoading: isLoading, onCancelOrder: onCancelOrder),
  );
}

/// 🔹 Awaiting Verification Popup
Future<void> logoutConfirmDialog({
  required BuildContext context,
  required RxBool isLoading,
  required Future<void> Function() onConfirm,
}) async {
  await Popups().baseAlert(
    context: context,
    content: LogoutConfirmDialog(isLoading: isLoading, onConfirm: onConfirm),
  );
}

/// 🔹 deliveryFeedbackDialog Popup
Future<void> deliveryFeedbackDialog({
  required BuildContext context,
  required RxBool isLoading,
  required RxInt selRatingNum,
  required void Function(int) onRatingChanged,
  required void Function(String) onFeedbackChanged,
  required Future<void> Function(int rating, String feedback) onSubmit,

  required TextEditingController descriptionCtrl,
  required FocusNode descriptionFocusNode,
}) async {
  await Popups().baseAlert(
    context: context,
    content: Container(
      // color: Colors.amber,
      height: 1.sh * 0.5,
      child: DeliveryFeedbackDialog(
        descriptionCtrl: descriptionCtrl,
        descriptionFocusNode: descriptionFocusNode,
        isLoading: isLoading,
        selRatingNum: selRatingNum,

        feedback: Strings.writeYourFeedback,
        onSubmit: onSubmit,
        onRatingChanged: onRatingChanged,
        onFeedbackChanged: onFeedbackChanged,
      ),
    ),
  );
}

/* call like:
Alerts().baseAlert(
  context: context,
  content: DeliveryFeedbackDialog(
    isLoading: controller.feedbackLoading.value,
    onSubmit: (rating, feedback) async {
      await controller.submitFeedback(rating, feedback);
      GNav.pop();
    },
  ),
);
*/
