import 'package:pinput/pinput.dart';

import '../../app/helper_widgets_export.dart';
import '../../features/main_tabs/community/model/comments_bottom_sheet.dart';
import '../../features/shared/report_sheet/screens/report_bottom_sheet.dart';

PinTheme? defaultPinTheme = PinTheme(
  width: 56.w,
  height: 58.h,
  textStyle: TxtStyle.urbanist(fs: 20, w: 600, color: c.primary),
  decoration: BoxDecoration(
    color: c.inputBackground,
    borderRadius: 30.brdrRad,

    border: Border.all(color: c.inputBorder),
  ),
);

PinTheme? focusedPinTheme = defaultPinTheme?.copyWith(
  decoration: BoxDecoration(
    color: c.inputBackground,
    borderRadius: 30.brdrRad,
    border: Border.all(color: c.primary, width: 2),
    boxShadow: [
      BoxShadow(color: c.primary.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3)),
    ],
  ),
);

PinTheme? followingPinTheme = defaultPinTheme?.copyWith(
  decoration: BoxDecoration(
    color: c.inputBackground,
    borderRadius: 30.brdrRad,
    border: Border.all(color: c.inputBorder),
  ),
);

///////////////////////////////////////////////////////////////
///
///        report bottom sheet in ChatInboxScreen
///
///////////////////////////////////////////////////////////////

Future<dynamic> showReportBottomSheet({double? heightFactor, bool isScrollControlled = true}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: Container(
        height: bSheetH * 0.8 * (heightFactor ?? 1),

        // width: 1.sw,
        child: ReportBottomSheet(),
      ).getBtmSheetM,
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}

Future<dynamic> showCommentsBottomSheet({double? heightFactor, bool isScrollControlled = true}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: Container(
        height: S.h * 0.9 * (heightFactor ?? 1),

        // width: 1.sw,
        child: CommentsBottomSheet(),
      ).getBtmSheetM,
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}
