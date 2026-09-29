import 'package:intl/intl.dart';
import 'package:we_mama/features/shared/date_picker/widgets/date_picker_widget.dart';

import '../../app/helper_widgets_export.dart';
import '../../features/main_tabs/home/sub_feature/edit_profile/model/child_model.dart';

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

    print(formattedDate.toString()); // 👉 16 Sep 2025

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
      print('❌ formatUTCtimestamp failed for "$timestamp": $e');
      return DateAndTimeMap(
        date: 'N/A',
        time: 'N/A',
        dateYear: 'N/A',
        fullDate: 'N/A',
      );
    }
  }

  String formatDateLabel(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final now = DateTime.now();

    final difference = now.difference(date).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";

    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final monthName = months[date.month - 1];

    return "${date.day} $monthName ${date.year}";
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
        result = minutes == 1 ? "1 min ago" : "$minutes min ago";
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        result = hours == 1 ? "1 hr ago" : "$hours hrs ago";
      } else if (difference.inDays == 1) {
        result = "yesterday";
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        result = "$days d ago";
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        result = weeks == 1 ? "1 w ago" : "$weeks w ago";
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        result = months == 1 ? "1 mon ago" : "$months mon ago";
      } else {
        final years = (difference.inDays / 365).floor();
        result = years == 1 ? "1 yr ago" : "$years yrs ago";
      }

      return DateAndTimeMap(date: result, time: '', dateYear: result);
    } catch (e) {
      print('❌ formatTimeAgo failed for "$timestamp": $e');
      return DateAndTimeMap(date: 'N/A', time: '', dateYear: 'N/A');
    }
  }

  ///
  ///////
  ///
  ///
  DateAndTimeMap formatNotificationTime(String? timestamp) {
    if (timestamp == null || timestamp.trim().isEmpty) {
      return DateAndTimeMap(
        date: 'N/A',
        time: '',
        dateYear: 'N/A',
        display: 'N/A',
      );
    }

    try {
      DateTime? dt = DateTime.tryParse(timestamp);

      if (dt == null) {
        return DateAndTimeMap(
          date: 'N/A',
          time: '',
          dateYear: 'N/A',
          display: 'N/A',
        );
      }

      final bool isUtc =
          timestamp.endsWith('Z') ||
          timestamp.contains(RegExp(r'[+-]\d\d:\d\d'));

      if (isUtc) {
        dt = dt.toLocal();
      }

      final now = DateTime.now();

      final isToday =
          now.year == dt.year && now.month == dt.month && now.day == dt.day;

      if (isToday) {
        final diff = now.difference(dt);

        String short;

        if (diff.inSeconds < 60) {
          short = '${diff.inSeconds} s';
        } else if (diff.inMinutes < 60) {
          short = '${diff.inMinutes} m';
        } else {
          short = '${diff.inHours} hr';
        }

        return DateAndTimeMap(
          date: short,
          time: DateFormat('hh:mm a').format(dt),
          dateYear: short,
          fullDate: DateFormat('dd MMM yyyy').format(dt),
          display: short,
        );
      }

      final date = DateFormat('dd MMM yyyy').format(dt);
      final time = DateFormat('hh:mm a').format(dt);

      return DateAndTimeMap(
        date: date,
        time: time,
        dateYear: DateFormat('MMM yyyy').format(dt),
        fullDate: '$date $time',
        display: '$date\n$time',
      );
    } catch (e) {
      print('❌ formatNotificationTime failed: $e');

      return DateAndTimeMap(
        date: 'N/A',
        time: '',
        dateYear: 'N/A',
        display: 'N/A',
      );
    }
  }
}

class DateAndTimeMap {
  final String date;
  final String time;
  final String dateYear;
  final String? fullDate;
  final String display; // 👈 combined display text

  DateAndTimeMap({
    required this.date,
    required this.time,
    required this.dateYear,
    this.fullDate,
    this.display = '',
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

Theme buildDatePickerTheme({
  required Widget child,
  required BuildContext context,
  Color? primaryColor,
  Color? backgroundColor,
  TextStyle? headerTextStyle,
  TextStyle? dayTextStyle,
}) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: primaryColor ?? c.strokePrimary, // header/date circle
        onPrimary: white, // text on selected day
        surface: backgroundColor ?? c.inputBackground, // calendar background
        onSurface: c.foregroundPrimary, // normal day text
      ),
      textTheme: TextTheme(
        headlineLarge:
            headerTextStyle ?? TxtStyle.poppinsSemiB(), // Month header
        bodyLarge: dayTextStyle, // Day numbers
      ),

      primaryTextTheme: TextTheme(
        titleMedium: TxtStyle.poppinsSemiB(fs: 14), // typed text color
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TxtStyle.poppinsSemiB(
          fs: 14,
          color: c.foregroundPrimary.withValues(alpha: 0.6),
        ),
        labelStyle: TxtStyle.poppinsSemiB(fs: 14, color: c.foregroundPrimary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: c.foregroundPrimary),
        ),
      ),
      //   Forces the typed input text color
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.foregroundPrimary,
        selectionColor: c.foregroundPrimary.withValues(alpha: 0.3),
        selectionHandleColor: c.foregroundPrimary,
      ),
      dialogTheme: DialogThemeData(
        contentTextStyle: TxtStyle.poppinsSemiB(),
        backgroundColor: backgroundColor ?? c.inputBackground,
      ),
    ),
    child: child,
  );
}

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

///

Future<DateTime?> pickDatePickerForChildren({
  ChildModel? child, // null = new child → default to now()
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

  // Parse existing DOB from child if available (format: "dd-MM-yyyy")
  DateTime? parsedDate;
  if (child != null && child.dob.value.isNotEmpty) {
    try {
      final parts = child.dob.value.split('-');
      if (parts.length == 3) {
        parsedDate = DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (_) {}
  }

  // New child → now(), existing child → their saved DOB
  final initialDate = parsedDate ?? now;

  return showDatePicker(
    context: Get.context!,
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime(1950),
    lastDate: lastDate ?? now,
    builder: (context, child) {
      return buildDatePickerTheme(child: child!, context: context);
    },
  );
}

Future<DateTime?> pickDatePickerToAddChild({
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  VoidCallback? unfocusAll,
}) {
  unfocusAll?.call();

  final now = DateTime.now();

  final minDate = firstDate ?? DateTime(1950);
  final maxDate = lastDate ?? now;

  final safeInitialDate = initialDate == null
      ? now
      : initialDate.isBefore(minDate)
      ? minDate
      : initialDate.isAfter(maxDate)
      ? maxDate
      : initialDate;

  return showDatePicker(
    context: Get.context!,
    initialDate: safeInitialDate,
    firstDate: minDate,
    lastDate: maxDate,
    builder: (context, child) {
      return buildDatePickerTheme(child: child!, context: context);
    },
  );
}

///
///

Future<void> pickDateWithOptions({
  required RxString selectedDate,
  required RxBool keepPrivate,
  void Function()? unfocusAll,
  DateTime? firstDate,
  DateTime? lastDate,
  bool? showKeepPrivate,
}) async {
  unfocusAll?.call();

  // ✅ parse dd/MM/yyyy format correctly
  DateTime? parsedDate;
  if (selectedDate.value.isNotEmpty) {
    try {
      final parts = selectedDate.value.split('/');
      if (parts.length == 3) {
        parsedDate = DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (_) {}
  }

  final tempSelected = (parsedDate ?? DateTime.now()).obs;

  await Get.dialog(
    buildDatePickerTheme(
      context: Get.context!,
      child: DatePickerWithPrivacy(
        selectedDate: selectedDate,
        tempSelected: tempSelected,
        keepPrivate: keepPrivate,
        firstDate: firstDate,
        lastDate: lastDate,
        showKeepPrivate: showKeepPrivate ?? true,
      ),
    ),
    barrierDismissible: true,
  );
}

///
String convertDobToTimestamp(String dob) {
  if (dob.isEmpty) return '';

  try {
    final parts = dob.split('/');
    final date = DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );

    return DateTime.utc(date.year, date.month, date.day).toIso8601String();
  } catch (e) {
    return '';
  }
}

String convertChildDobToTimestamp(String dob) {
  if (dob.isEmpty) return '';

  try {
    final parts = dob.split('-');
    final date = DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );

    return DateTime.utc(date.year, date.month, date.day).toIso8601String();
  } catch (e) {
    return '';
  }
}

///
String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";
}
