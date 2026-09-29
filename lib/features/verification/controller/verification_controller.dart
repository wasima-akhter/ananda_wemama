import 'dart:async';

import 'package:persona_flutter/persona_flutter.dart';

import '../../../app/controller_export.dart';
import '../../../core/network/base/dio_client.dart';
import '../../../core/services/auth/signout_service.dart';
import '../../../core/services/auth/verification_gate.dart';
import '../model/verification_model.dart';
import '../service/verification_service.dart';

enum PersonaOutcome { completed, canceled, error }

class VerificationController extends GetxController {
  final status = VerificationStatus.notStarted.obs;
  final isStarting = false.obs;
  final isPolling = false.obs;
  final pollTimedOut = false.obs;

  Timer? _timer;
  DateTime? _pollStart;
  bool _inFlight = false;

  static const _interval = Duration(seconds: 3);
  static const _cap = Duration(minutes: 2);

  @override
  void onInit() {
    super.onInit();

    _subComplete = PersonaInquiry.onComplete.listen((e) {
      print('Persona complete: ${e.inquiryId} / ${e.status}');
      _finishPersona(PersonaOutcome.completed);
    });
    _subCanceled = PersonaInquiry.onCanceled.listen((e) {
      _finishPersona(PersonaOutcome.canceled);
    });
    _subError = PersonaInquiry.onError.listen((e) {
      print('Persona error: ${e.error}');
      _finishPersona(PersonaOutcome.error);
    });

    _checkOnce(); // resume correctly on app reopen
  }

  Future<void> _checkOnce() async {
    final res = await VerificationService().getStatus();
    if (!res.isSuccess || res.data == null) return;
    status.value = res.data!.status;

    if (status.value == VerificationStatus.approved) {
      PostAuthNavigator.goHome();
    } else if (status.value == VerificationStatus.processing) {
      _startPolling();
    }
  }

  Future<void> onTapVerify() async {
    if (isStarting.value) return;
    isStarting.value = true;
    final res = await VerificationService().createSession();
    isStarting.value = false;

    if (!(res.isSuccess && res.data != null)) {
      _handleSessionError(res);
      return;
    }

    final outcome = await _openPersona(res.data!);

    switch (outcome) {
      case PersonaOutcome.completed:
        _startPolling(); // backend is the source of truth, not Persona's callback
        break;
      case PersonaOutcome.canceled:
        _checkOnce(); // user backed out; refresh state, stay on screen
        break;
      case PersonaOutcome.error:
        Snack.showError('Could not open verification. Please try again.');
        break;
    }
  }

  void _handleSessionError(Result res) {
    switch (res.statusCode) {
      case 409: // already verified
        status.value = VerificationStatus.approved;
        PostAuthNavigator.goHome();
        break;
      case 429:
        Snack.showError(
          res.message ?? 'Too many attempts. Try again in 15 minutes.',
        );
        break;
      case 502:
        Snack.showError('Verification service unavailable. Please try again.');
        break;
      default: // 401, 403, network, etc.
        Snack.showError(
          res.message ?? 'Something went wrong. Please try again.',
        );
    }
  }

  StreamSubscription<InquiryComplete>? _subComplete;
  StreamSubscription<InquiryCanceled>? _subCanceled;
  StreamSubscription<InquiryError>? _subError;
  Completer<PersonaOutcome>? _personaCompleter;

  void _finishPersona(PersonaOutcome o) {
    final c = _personaCompleter;
    if (c != null && !c.isCompleted) c.complete(o);
  }

  // ---- Persona ----
  Future<PersonaOutcome> _openPersona(VerificationSession s) async {
    _personaCompleter = Completer<PersonaOutcome>();
    try {
      await PersonaInquiry.init(
        configuration: InquiryIdConfiguration(
          inquiryId: s.inquiryId,
          sessionToken: s.sessionToken,
        ),
      );
      await PersonaInquiry.start();
    } catch (e) {
      print('Persona start failed: $e');
      _finishPersona(PersonaOutcome.error);
    }
    return _personaCompleter!.future;
  }

  // ---- Polling ----
  void _startPolling() {
    _timer?.cancel();
    pollTimedOut.value = false;
    isPolling.value = true;
    _pollStart = DateTime.now();
    _timer = Timer.periodic(_interval, (_) => _poll());
    _poll();
  }

  Future<void> _poll() async {
    if (_inFlight) return;
    if (DateTime.now().difference(_pollStart!) > _cap) {
      _stopPolling();
      pollTimedOut.value = true;
      return;
    }
    _inFlight = true;
    final res = await VerificationService().getStatus();
    _inFlight = false;

    if (res.statusCode == 401) return _stopPolling();
    if (!res.isSuccess || res.data == null) return; // transient, keep trying

    status.value = res.data!.status;
    if (status.value.isFinal) {
      _stopPolling();
      if (status.value == VerificationStatus.approved)
        PostAuthNavigator.goHome();
    }
  }

  void _stopPolling() {
    _timer?.cancel();
    isPolling.value = false;
  }

  //
  void checkAgain() => _startPolling();

  final isSignoutLoading = false.obs;
  Future<void> signOut() async {
    isSignoutLoading.value = true;
    await SignoutService().signOut();

    isSignoutLoading.value = false;
    Get.offAllNamed(RoutePaths.signin);
  }

  @override
  void onClose() {
    _timer?.cancel();
    _subComplete?.cancel();
    _subCanceled?.cancel();
    _subError?.cancel();
    super.onClose();
  }
}
