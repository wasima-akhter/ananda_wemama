import 'package:intl/intl.dart';

class SessionTimeHelper {
  SessionTimeHelper._();

  static const String fallbackTime = '--:--';
  static const String fallbackDate = '--';
  static const String fallbackDateTime = '--';

  // ============================================================
  // Parse host dateTime -> user's device local DateTime
  // ============================================================

  /// Treats [dateTime] as a wall-clock time belonging to [hostTimezone].
  ///
  /// Example:
  ///
  /// dateTime    = 2026-08-16T09:36:00.000Z
  /// hostTimezone = Asia/Dhaka
  ///
  /// The `09:36` is treated as 09:36 AM in Dhaka.
  /// It is then converted to the user's device timezone.
  ///
  /// The timezone suffix in the API timestamp is intentionally ignored
  /// because [hostTimezone] is the source timezone according to the
  /// session's business rule.
  static DateTime? toLocal({required String? dateTime, String? hostTimezone}) {
    if (dateTime == null || dateTime.trim().isEmpty) {
      return null;
    }

    try {
      final parsed = DateTime.parse(dateTime.trim());

      // Backend sends a global UTC timestamp.
      // Convert the same instant to the user's device timezone.
      return parsed.toLocal();
    } catch (e, st) {
      print(
        '❌ SessionTimeHelper.toLocal failed: '
        'dateTime=$dateTime, error=$e',
      );
      print('$st');
      return null;
    }
  }

  // ============================================================
  // TIME
  // ============================================================

  static String time({
    required String? dateTime,
    required String? hostTimezone,
  }) {
    final local = toLocal(dateTime: dateTime, hostTimezone: hostTimezone);

    if (local == null) {
      return fallbackTime;
    }

    try {
      return DateFormat('h:mm a').format(local);
    } catch (_) {
      return fallbackTime;
    }
  }

  // ============================================================
  // DATE
  // ============================================================

  static String date({
    required String? dateTime,
    required String? hostTimezone,
  }) {
    final local = toLocal(dateTime: dateTime, hostTimezone: hostTimezone);

    if (local == null) {
      return fallbackDate;
    }

    try {
      return DateFormat('MMM d, yyyy').format(local);
    } catch (_) {
      return fallbackDate;
    }
  }

  // ============================================================
  // DATE + TIME
  // ============================================================

  static String dateTime({
    required String? dateTime,
    required String? hostTimezone,
  }) {
    final local = toLocal(dateTime: dateTime, hostTimezone: hostTimezone);

    if (local == null) {
      return fallbackDateTime;
    }

    try {
      return DateFormat('MMM d, yyyy • h:mm a').format(local);
    } catch (_) {
      return fallbackDateTime;
    }
  }

  // ============================================================
  // TIME + DATE
  // ============================================================

  static String timeAndDate({
    required String? dateTime,
    required String? hostTimezone,
  }) {
    final local = toLocal(dateTime: dateTime, hostTimezone: hostTimezone);

    if (local == null) {
      return fallbackDateTime;
    }

    try {
      return DateFormat('h:mm a • MMM d, yyyy').format(local);
    } catch (_) {
      return fallbackDateTime;
    }
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  static bool isValid({
    required String? dateTime,
    required String? hostTimezone,
  }) {
    return toLocal(dateTime: dateTime, hostTimezone: hostTimezone) != null;
  }

  // ============================================================
  // UPCOMING
  // ============================================================

  static bool isUpcoming({
    required String? dateTime,
    required String? hostTimezone,
  }) {
    final local = toLocal(dateTime: dateTime, hostTimezone: hostTimezone);

    if (local == null) {
      return false;
    }

    return local.isAfter(DateTime.now());
  }

  // ============================================================
  // STARTED
  // ============================================================

  static bool hasStarted({
    required String? dateTime,
    required String? hostTimezone,
  }) {
    final local = toLocal(dateTime: dateTime, hostTimezone: hostTimezone);

    if (local == null) {
      return false;
    }

    return !local.isAfter(DateTime.now());
  }
}
