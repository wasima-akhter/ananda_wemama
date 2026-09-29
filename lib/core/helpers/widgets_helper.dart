import 'package:pinput/pinput.dart';

import '../../app/helper_widgets_export.dart';
import '../../features/auth/core/auth_button_templates.dart';
import '../../features/main_tabs/community/comments/widgets/comments_bottom_sheet.dart';
import '../../features/main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../../features/shared/report_sheet/screens/report_bottom_sheet.dart';
import '../../features/video_meeting/modules/meeting_comments_bottom_sheet.dart';
import '../components/app_ui/components/user_detaIl_component/controller/user_detail_controller.dart';
import '../components/app_ui/sheets/set_children_bottom_sheet.dart';

PinTheme? defaultPinTheme = PinTheme(
  width: ScreenSize.isSmallWidth ? 42.w : 51.w,
  height: 56.h,
  textStyle: TxtStyle.poppinsSemiB(fs: 20, w: 600, color: c.primary),
  decoration: BoxDecoration(
    color: bgClrNew,
    borderRadius: 30.brdrRad,

    border: Border.all(color: c.strokePrimary.withValues(alpha: 0.3), width: 2),
  ),
);

PinTheme? focusedPinTheme = defaultPinTheme?.copyWith(
  decoration: BoxDecoration(
    color: bgClrNew,
    borderRadius: 30.brdrRad,
    border: Border.all(color: c.strokePrimary, width: 2),
    boxShadow: [
      BoxShadow(
        color: c.primary.withValues(alpha: 0.15),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  ),
);

PinTheme? followingPinTheme = defaultPinTheme?.copyWith(
  decoration: BoxDecoration(
    color: bgClrNew,
    borderRadius: 30.brdrRad,
    border: Border.all(width: 2, color: c.strokePrimary.withValues(alpha: 0.3)),
  ),
);

///////////////////////////////////////////////////////////////
///
///        report bottom sheet in ChatInboxScreen
///
///////////////////////////////////////////////////////////////

Future<dynamic> showReportBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
  required bool isUserReport,
  String? userId,
  String? postId,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: SizedBox(
        height: bSheetH * 1 * (heightFactor ?? 1),

        // width: 1.sw,
        child: ReportBottomSheet(
          isUserReport: isUserReport,
          postId: postId,
          userId: userId,
        ),
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
      child: SizedBox(
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
      child: SizedBox(
        height: bSheetH * (heightFactor ?? 1),
        child: MeetingCommentsBottomSheet(postId: postId), // ← pass postId
      ).getBtmSheetM,
    ),
    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr,
  );
}

Future<dynamic> showChildrenBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: SizedBox(
        height: bSheetH * 0.8 * (heightFactor ?? 1),

        // width: 1.sw,
        child: SetChildrenBottomSheet(),
      ),
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}

Future<T?> showCommonPickerBottomSheet<T>({
  required String title,
  required Widget child,
  required VoidCallback onDone,
  String doneText = "Done",
  double? height,
}) {
  return Get.bottomSheet<T>(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    backgroundColor: bgClr,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: Container(
        height: height ?? bSheetH * 0.9,
        padding: EdgeInsets.all(itemGap * 1.2),

        decoration: BoxDecoration(
          color: c.cardPrimary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),

        child: Column(
          children: [
            Gap(itemGap),

            Text(title.cap, style: TxtStyle.outfitSemiB(fs: 16)),

            Gap(itemGap),

            Expanded(child: child),

            Padding(
              padding: EdgeInsets.all(itemGap),
              child: AuthButton(
                isLoading: false,
                btnText: doneText,
                onTap: onDone,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//

///////////////////////////////////////////////////////////////
///
///       socket helper
///
///////////////////////////////////////////////////////////////

Widget buildTitle(String? title) {
  if (title == null || title.trim().isEmpty) {
    return const SizedBox.shrink(); // 👈 don't show
  }

  return Text(
    title,
    style: TxtStyle.outfit(
      fs: 16,
      w: 600,
      color: c.primary, // 🎨 custom color
    ),
  );
}

Widget buildMessage(String? message) {
  if (message == null || message.trim().isEmpty) {
    return const SizedBox.shrink(); // 👈 don't show
  }

  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      message,
      style: TxtStyle.outfit(
        fs: 14,
        w: 400,
        color: c.textSecondary, // 🎨 custom color
      ),
    ),
  );
}

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
/// --------------   profile data helpers ----------- ///

FakeUserDetailsModel? mapToUserModel(ProfileDataModel? data) {
  if (data == null) return null;

  print("Mapping data.profileImage: ${data.profileImage} ");
  print("Mapping data.dobObject?.isPublic: ${data.dobObject?.isPublic} ");

  print("----dobObject isPublic: ${data.dobObject?.isPublic}");
  print("----dobObject date: ${data.dobObject?.date}");
  print("----dob flat: ${data.dob}");
  print("----data hashCode: ${data.hashCode}"); // ← is this the same object?

  final age = (data.dobObject?.isPublic ?? false) ? calculateAge(data.dob) : 0;
  print(
    "final age: $age | isPublic: ${data.dobObject?.isPublic} | dob: ${data.dob}",
  );

  //

  return FakeUserDetailsModel(
    imageUrl: data.profileImage ?? '',
    name: data.name ?? '',
    age: age,
    aboutMe: data.bio ?? '',
    galleryImages: data.images,
    children: data.children.map((e) => getChildAge(e.dob.toString())).toList(),
    infoList: buildInfoList(data),
  );
}

List<UiInfoItem> buildInfoList(ProfileDataModel data) {
  final List<UiInfoItem> list = [];
  final coords = data.location?.coordinates;

  if (coords != null && coords.length >= 2) {
    list.add(
      UiInfoItem(
        iconPath: IconsPath.locationBold,
        text: "${data.city ?? ''}, ${data.state ?? ''}",
      ),
    );
  }

  if (data.mumStages.isNotEmpty) {
    list.add(
      UiInfoItem(
        iconPath: IconsPath.chartFilled,
        text: data.mumStages.join(', '),
      ),
    );
  }

  if (data.interesteds.isNotEmpty) {
    list.add(
      UiInfoItem(
        iconPath: IconsPath.heartHalfFilled,
        text: data.interesteds.map((e) => e.replaceAll('\n', ' ')).join(', '),
      ),
    );
  }
  return list;
}

int calculateAge(DateTime? dob) {
  if (dob == null) return 0;
  final now = DateTime.now();
  int age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day))
    age--;
  return age;
}

//
