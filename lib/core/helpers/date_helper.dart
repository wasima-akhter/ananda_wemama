import 'package:intl/intl.dart';

import '../../app/helper_widgets_export.dart';
import '../common_widgets/common_components/set_children_bottom_sheet.dart';
import '../common_widgets/common_components/state_city_bottom_sheet.dart';

class DateHelper {
  String yMdToDMY(String inputDate) {
    if (inputDate.trim().isEmpty) {
      return 'N/A';
    }

    //  String inputDate = "2025-09-16";

    // Parse the string into DateTime
    DateTime parsedDate = DateTime.parse(inputDate);

    // Format to "DD MMM YYYY"
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    debugPrint(formattedDate.toString()); // 👉 16 Sep 2025

    return formattedDate;
  }

  DateAndTimeMap formatUTCtimestamp(String? timestamp) {
    // Handle null or empty timestamp
    if (timestamp == null || timestamp.trim().isEmpty) {
      return DateAndTimeMap(
        date: 'N/A',
        time: 'N/A',
        dateYear: 'N/A',
        fullDate: 'N/A',
      );
    }

    try {
      // Detect if timestamp is UTC (has Z or ±hh:mm)
      final bool isUtc =
          timestamp.endsWith('Z') ||
          timestamp.contains(RegExp(r'[+-]\d\d:\d\d'));

      // Try to parse safely
      DateTime? dt = DateTime.tryParse(timestamp);
      if (dt == null) {
        return DateAndTimeMap(
          date: 'N/A',
          time: '',
          dateYear: 'N/A',
          fullDate: 'N/A',
        );
      }

      if (isUtc) dt = dt.toLocal(); // Convert to local if UTC

      // Format date & time
      final formattedDate = DateFormat('dd MMM yyyy').format(dt); // 08 Nov 2026

      final formattedTime = DateFormat('hh:mm a').format(dt); // 04:52 PM

      final formattedDateYear = DateFormat('MMM yyyy').format(dt); // Nov 2026

      final formattedFullDate = DateFormat(
        'd MMM yyyy',
      ).format(dt); // 8 Nov 2026

      return DateAndTimeMap(
        date: formattedDate,
        time: formattedTime,
        dateYear: formattedDateYear,
        fullDate: formattedFullDate,
      );
    } catch (e) {
      debugPrint('❌ formatUTCtimestamp failed for "$timestamp": $e');
      return DateAndTimeMap(
        date: 'N/A',
        time: 'N/A',
        dateYear: 'N/A',
        fullDate: 'N/A',
      );
    }
  }

  String formatTime12HourSafe(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.trim().isEmpty) return '--:--';

    try {
      // Split by space and take the last part (assumes HH:mm:ss is at the end)
      final parts = dateTimeStr.trim().split(' ');
      if (parts.isEmpty) return '--:--';

      final timePart = parts.last;
      final timeSegments = timePart.split(':');
      if (timeSegments.length < 2) return '--:--';

      int hour = int.tryParse(timeSegments[0]) ?? 0;
      final minute =
          int.tryParse(timeSegments[1])?.toString().padLeft(2, '0') ?? '00';
      final second = timeSegments.length > 2
          ? (int.tryParse(timeSegments[2])?.toString().padLeft(2, '0') ?? '00')
          : '00';

      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour == 0) {
        hour = 12; // midnight
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      return '--:--';
    }
  }

  ///
  ///
  String formatDurationMMSS(Duration? duration) {
    if (duration == null) {
      return "00:00";
    }
    final totalSeconds = duration.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  DateAndTimeMap formatTimeAgo(String? timestamp) {
    if (timestamp == null || timestamp.trim().isEmpty) {
      return DateAndTimeMap(date: 'N/A', time: '', dateYear: 'N/A');
    }

    try {
      DateTime? dt = DateTime.tryParse(timestamp);
      if (dt == null) {
        return DateAndTimeMap(date: 'N/A', time: '', dateYear: 'N/A');
      }

      // Convert to local if UTC
      final bool isUtc =
          timestamp.endsWith('Z') ||
          timestamp.contains(RegExp(r'[+-]\d\d:\d\d'));

      if (isUtc) dt = dt.toLocal();

      final now = DateTime.now();
      final difference = now.difference(dt);

      String result;

      if (difference.inSeconds < 60) {
        result = "just now";
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        result = minutes == 1 ? "1 minute ago" : "$minutes minutes ago";
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        result = hours == 1 ? "1 hour ago" : "$hours hours ago";
      } else if (difference.inDays == 1) {
        result = "yesterday";
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        result = "$days days ago";
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        result = weeks == 1 ? "1 week ago" : "$weeks weeks ago";
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        result = months == 1 ? "1 month ago" : "$months months ago";
      } else {
        final years = (difference.inDays / 365).floor();
        result = years == 1 ? "1 year ago" : "$years years ago";
      }

      return DateAndTimeMap(date: result, time: '', dateYear: result);
    } catch (e) {
      debugPrint('❌ formatTimeAgo failed for "$timestamp": $e');
      return DateAndTimeMap(date: 'N/A', time: '', dateYear: 'N/A');
    }
  }

  ///
  ///////
}

class DateAndTimeMap {
  final String date;
  final String time;
  final String dateYear;
  final String? fullDate;

  DateAndTimeMap({
    required this.date,
    required this.time,
    required this.dateYear,
    this.fullDate,
  });
}

bool isIso8601Utc(String input) {
  try {
    final date = DateTime.parse(input);
    // Check if input ends with 'Z' to ensure UTC
    return input.endsWith('Z');
  } catch (e) {
    return false;
  }
}

////////////////////////////////
///
///
Future<DateTime?> pickDateGeneric({
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Color? primaryColor,
  Color? backgroundColor,
  TextStyle? headerTextStyle,
  TextStyle? dayTextStyle,
  void Function()? unfocusAll,
}) {
  unfocusAll?.call();

  final now = DateTime.now();

  final picked = showDatePicker(
    context: Get.context!,
    initialDate: initialDate ?? now.subtract(const Duration(days: 365 * 18)),
    firstDate: firstDate ?? DateTime(1950),
    lastDate: lastDate ?? now,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor ?? c.primary, // header/date circle
            onPrimary: c.secondary, // text on selected day
            surface:
                backgroundColor ?? c.inputBackground, // calendar background
            onSurface: c.textPrimary, // normal day text
          ),
          textTheme: TextTheme(
            headlineLarge: headerTextStyle, // Month header
            bodyLarge: dayTextStyle, // Day numbers
          ),

          primaryTextTheme: TextTheme(
            titleMedium: TxtStyle.outfit(
              fs: 14,
              color: c.primary,
            ), // typed text color
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TxtStyle.outfit(
              fs: 14,
              color: c.primary.withOpacity(0.6),
            ),
            labelStyle: TxtStyle.outfit(fs: 14, color: c.primary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: c.primary),
            ),
          ),
          //   Forces the typed input text color
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: c.primary,
            selectionColor: c.primary.withOpacity(0.3),
            selectionHandleColor: c.primary,
          ),
          dialogBackgroundColor: backgroundColor ?? c.inputBackground,
        ),
        child: child!,
      );
    },
  );

  return picked;
}

Future<void> pickDate({
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Color? primaryColor,
  Color? backgroundColor,
  TextStyle? headerTextStyle,
  TextStyle? dayTextStyle,
  void Function()? unfocusAll,
  required RxString selectedDate,
}) async {
  unfocusAll?.call();

  final now = DateTime.now();

  final picked = await pickDateGeneric(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    primaryColor: primaryColor,
    backgroundColor: backgroundColor,
    headerTextStyle: headerTextStyle,
    dayTextStyle: dayTextStyle,
    unfocusAll: unfocusAll,
  );
  if (picked != null) {
    selectedDate.value = formatDate(picked);
  }
}

String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";
}

///////////////////////////////////////
///
///     select state
///
///////////////////////////////////////
Future<dynamic> showSelectionBottomSheet({
  required String title,
  required List<String> items,
  required RxString selectedValue,
  double? heightFactor,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    backgroundColor: bgClr,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),
      child: Container(
        // color: Colors.amber,
        height: bSheetH * 1 * (heightFactor ?? 1),
        child: SelectListBottomSheet(
          title: title,
          items: items,
          selectedValue: selectedValue,
        ),
      ),
    ),
  );
}
