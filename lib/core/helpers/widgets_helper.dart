import 'package:pinput/pinput.dart';

import '../../app/helper_widgets_export.dart';
import '../../features/main_tabs/community/model/comments_bottom_sheet.dart';
import '../../features/shared/report_sheet/screens/report_bottom_sheet.dart';
import '../../features/video_meeting/modules/meeting_comments_bottom_sheet.dart';
import '../common_widgets/common_components/set_children_bottom_sheet.dart';

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
        height: bSheetH * 1 * (heightFactor ?? 1),

        // width: 1.sw,
        child: ReportBottomSheet(),
      ).getBtmSheetM,
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}

Future<dynamic> showCommentsBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
  required int postId, // ← add
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,
    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),
      child: Container(
        height: S.h * 0.9 * (heightFactor ?? 1),
        child: CommentsBottomSheet(postId: postId), // ← pass postId
      ).getBtmSheetM,
    ),
    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr,
  );
}

Future<dynamic> showLiveCommentsBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
  required int postId, // ← add
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,
    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),
      child: Container(
        height: bSheetH * (heightFactor ?? 1),
        child: MeetingCommentsBottomSheet(postId: postId), // ← pass postId
      ).getBtmSheetM,
    ),
    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr,
  );
}

Future<dynamic> showChildrenBottomSheet({double? heightFactor, bool isScrollControlled = true}) {
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
        child: SetChildrenBottomSheet(),
      ),
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}

//
// String getChildAge(String? dobString, {String placeholder = "N/A"}) {
//   if (dobString == null || dobString.isEmpty) return placeholder;

//   try {
//     final dob = DateTime.parse(dobString).toLocal();
//     final now = DateTime.now();

//     int years = now.year - dob.year;
//     int months = now.month - dob.month;
//     int days = now.day - dob.day;

//     /// adjust days
//     if (days < 0) {
//       final prevMonth = DateTime(now.year, now.month, 0);
//       days += prevMonth.day;
//       months--;
//     }

//     /// adjust months
//     if (months < 0) {
//       years--;
//       months += 12;
//     }

//     /// 🔹 أقل من شهر → show days
//     if (years == 0 && months == 0) {
//       return "$days day${days == 1 ? '' : 's'}";
//     }

//     /// 🔹 أقل من سنة → show months
//     if (years == 0) {
//       return "$months month${months == 1 ? '' : 's'}";
//     }

//     /// 🔹 سنة بدون شهور
//     if (months == 0) {
//       return "$years year${years == 1 ? '' : 's'}";
//     }

//     /// 🔹 سنة + شهور
//     return "$years year${years == 1 ? '' : 's'} $months month${months == 1 ? '' : 's'}";
//   } catch (e) {
//     return placeholder;
//   }
// }

String getChildAge(
  String? dobString, {
  String placeholder = "N/A",
  String? gender, // "Male" / "Female"
}) {
  if (dobString == null || dobString.isEmpty) return placeholder;

  try {
    final dob = DateTime.parse(dobString).toLocal();
    final now = DateTime.now();

    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;

    /// adjust days
    if (days < 0) {
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
      months--;
    }

    /// adjust months
    if (months < 0) {
      years--;
      months += 12;
    }

    /// 🎯 Decide emoji
    String emoji;

    if (years == 0) {
      // 👶 baby (under 1 year)
      emoji = "👶";
    } else {
      // 🧒 child with gender
      if (gender?.toLowerCase() == "male") {
        emoji = "👦";
      } else if (gender?.toLowerCase() == "female") {
        emoji = "👧";
      } else {
        emoji = "🧒"; // fallback
      }
    }

    /// 👶 → days
    if (years == 0 && months == 0) {
      return "$emoji $days day${days == 1 ? '' : 's'}";
    }

    /// 👶 → months
    if (years == 0) {
      return "$emoji $months month${months == 1 ? '' : 's'}";
    }

    /// 👦 / 👧
    if (months == 0) {
      return "$emoji $years year${years == 1 ? '' : 's'}";
    }

    /// 👦 / 👧
    return "$emoji $years year${years == 1 ? '' : 's'} $months month${months == 1 ? '' : 's'}";
  } catch (e) {
    return placeholder;
  }
}

//
