import 'dart:async';

import '../../../../app/controller_export.dart';
import '../meeting_controller.dart';

mixin SessionTimerMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  /// --------------- Live Duration ---------------///

  final sessionStartTime = Rxn<DateTime>();
  final elapsedSeconds = 0.obs;
  Timer? _sessionTimer;

  // In MeetingController — replace startSessionTimer() call
  void startSessionTimer() {
    try {
      final startedAtRaw = _self.sessionInfo.value.startedAt;

      /// ✅ Parse ISO string → DateTime (UTC)
      final startTime = startedAtRaw != null
          ? DateTime.parse(startedAtRaw).toLocal()
          : DateTime.now();

      sessionStartTime.value = startTime;

      /// ✅ Calculate elapsed time
      elapsedSeconds.value = DateTime.now().difference(startTime).inSeconds;

      /// ✅ Prevent negative (device time mismatch)
      if (elapsedSeconds.value < 0) {
        elapsedSeconds.value = 0;
      }

      /// ✅ Avoid multiple timers
      _sessionTimer?.cancel();

      /// ✅ Accurate ticking (no drift)
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsedSeconds.value = DateTime.now()
            .difference(sessionStartTime.value!)
            .inSeconds;
      });

      print(
        '⏱️ Timer started — start: $startTime, elapsed: ${elapsedSeconds.value}s',
      );
    } catch (e) {
      print('❌ Timer error: $e');
    }
  }

  void stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    print('⏱️ Session timer stopped');
  }

  String get formattedDuration {
    final s = elapsedSeconds.value;
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${sec.toString().padLeft(2, '0')}';
  }
}
