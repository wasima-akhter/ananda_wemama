import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:we_mama/core/components/ui/dialogs/popups.dart';
import 'package:we_mama/core/services/socket/socket_events.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/local/app_storage.dart';
import '../../../../core/network/helpers/location/location_manager_global/app_location_manager.dart';
import '../../../../core/services/profile/profile_info_service.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../../../shared/subscription/subscription_access/premium_access_service.dart';
import '../../home/sub_feature/profile/model/profile_model.dart';
import '../model/match_model.dart';
import '../screen/match_screen.dart';
import '../services/match_service.dart';

enum MatchState { idle, searching, found, noMatch, locationUnavailable }

class MatchController extends GetxController {
  Rx<MatchState> matchState = MatchState.idle.obs;

  static MatchController get to => Get.find<MatchController>();
  RxBool isWaveLoading = false.obs;
  RxBool isPassLoading = false.obs;
  RxBool isSeeMore = false.obs;
  RxBool subUpgradeNeeded = false.obs;

  final RxBool isPaidUser = false.obs;
  Worker? _premiumWorker;

  final int freeDailyLimit = 3;
  final RxInt searchesToday = 0.obs;

  int _searchId = 0;

  final fetchedMatches = <MatchResponseModel>[].obs;
  int _currentMatchIndex = 0;

  MatchResponseModel? get currentMatch {
    if (fetchedMatches.isEmpty) return null;
    if (_currentMatchIndex >= fetchedMatches.length) return null;
    return fetchedMatches[_currentMatchIndex];
  }

  Future<bool> _ensurePremiumAccess() async {
    final premiumService = PremiumAccessService.to;

    debugPrint('\n╔════════════════════════════════════════╗');
    debugPrint('║ [MatchController] PREMIUM CHECK START  ║');
    debugPrint('╚════════════════════════════════════════╝');

    // Print current premium state
    premiumService.debugPrintFullState();

    // ─────────────────────────────────────────────
    // WAIT FOR PREMIUM SERVICE TO BE READY
    // ─────────────────────────────────────────────
    if (!premiumService.isReady.value) {
      debugPrint('⏳ [MatchController] Premium service NOT ready, waiting...');

      int attempts = 0;

      while (!premiumService.isReady.value && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      debugPrint('⏳ [MatchController] Waited $attempts attempts');

      if (!premiumService.isReady.value) {
        debugPrint(
          '🔴 [MatchController] Premium service initialization TIMEOUT',
        );

        premiumService.debugPrintFullState();

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        return false;
      }

      debugPrint('✅ [MatchController] Premium service is now READY');

      premiumService.debugPrintFullState();
    } else {
      debugPrint('✅ [MatchController] Premium service already READY');
    }

    // ─────────────────────────────────────────────
    // PREMIUM CHECK
    // ─────────────────────────────────────────────
    debugPrint('\n🔐 [MatchController] Premium check:');
    debugPrint('   isPremiumUserNow: ${premiumService.isPremiumUserNow}');
    debugPrint('   isPremiumUser.value: ${premiumService.isPremiumUser.value}');

    if (!premiumService.isPremiumUserNow) {
      debugPrint('🔒 [MatchController] ❌ User is NOT premium');

      premiumService.debugPrintFullState();

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.toNamed(RoutePaths.subscriptionUpgrade);

      return false;
    }

    debugPrint('✅ [MatchController] ✅ User IS premium');

    premiumService.debugPrintFullState();

    debugPrint('╔════════════════════════════════════════╗');
    debugPrint('║ [MatchController] PREMIUM CHECK PASSED ║');
    debugPrint('╚════════════════════════════════════════╝\n');

    return true;
  }

  @override
  void onInit() {
    super.onInit();

    final premium = PremiumAccessService.to;
    isPaidUser.value = premium.isPremiumUserNow;
    _premiumWorker = ever<bool>(premium.isPremiumUser, (isPremium) {
      isPaidUser.value = isPremium;
    });

    _restoreSearchCount();

    fetchWaveLimit();

    cancelSearch();
    resetState();

    print("storage.getMatchSearchCount : ${storage.getMatchSearchCount}");
    print("freeDailyLimit : $freeDailyLimit");
  }

  @override
  void onClose() {
    cancelSearch();
    resetState();
    _premiumWorker?.dispose();
    super.onClose();
  }

  // Homescreen logic
  /*
  Future<void> runLocationPermissionFlow() async {
    log("📍 MatchController: starting location permission flow");

    final result = await AppLocationManager.to.ensureFreshLocation();

    final active = result == LocationFlowResult.success;

    checkLocationPopup(isActive: active);
  }
*/

  // new logic
  bool? _lastKnownLocationActive;
  bool _isRunningLocationFlow = false;

  Future<void> runLocationPermissionFlow() async {
    if (_isRunningLocationFlow) return;

    _isRunningLocationFlow = true;

    try {
      log("📍 MatchController: checking location status");

      final result = await AppLocationManager.to.ensureFreshLocation();

      final isActive = result == LocationFlowResult.success;

      // ─────────────────────────────────────────────
      // FIRST CHECK
      // ─────────────────────────────────────────────
      if (_lastKnownLocationActive == null) {
        _lastKnownLocationActive = isActive;

        // First check ALWAYS shows the popup.
        log(
          "📍 First location check: "
          "$isActive → show popup",
        );

        checkLocationPopup(isActive: isActive);
        return;
      }

      // ─────────────────────────────────────────────
      // LATER CHECKS
      // ─────────────────────────────────────────────
      if (_lastKnownLocationActive != isActive) {
        log(
          "📍 Location status changed: "
          "$_lastKnownLocationActive → $isActive",
        );

        _lastKnownLocationActive = isActive;

        checkLocationPopup(isActive: isActive);
        return;
      }

      // No change → no popup.
      log(
        "📍 Location status unchanged: "
        "$isActive → no popup",
      );
    } finally {
      _isRunningLocationFlow = false;
    }
  }

  void checkLocationPopup({required bool isActive}) {
    // if (!storage.hasLoggedInBefore) {
    //   storage.setHasLoggedInBefore();
    //   return;
    // }

    MatchScreen.showLocationStatusOverlay(isActive: isActive);
  }

  //
  final bool _searchLocationStatusInitialized = false;
  bool? _lastSearchLocationStatus;
  // end of new logic

  // ═══════════════════════════════════════════════════════════════════════
  // DAILY LIMIT — persisted via AppStorage
  // ═══════════════════════════════════════════════════════════════════════
  // TODO(backend): once a usage-tracking endpoint exists, replace this with
  // a server-verified count — local storage can be cleared/reinstalled to
  // dodge the limit, so this is a stopgap, not the long-term source of truth.

  String get _todayKey => DateTime.now().toIso8601String().substring(0, 10);

  void _restoreSearchCount() {
    final storage = AppStorage.to;
    final storedDate = storage.getMatchSearchDate;
    final storedCount = storage.getMatchSearchCount;

    searchesToday.value = (storedDate == _todayKey) ? storedCount : 0;
    _persistSearchCount();
  }

  void _incrementSearchCount() {
    // Guard against the day rolling over mid-session.
    if (AppStorage.to.getMatchSearchDate != _todayKey) {
      searchesToday.value = 0;
    }
    searchesToday.value++;
    _persistSearchCount();
  }

  void _persistSearchCount() {
    AppStorage.to.setMatchSearchCount(
      count: searchesToday.value,
      date: _todayKey,
    );
  }

  int get remainingSearchesToday =>
      (freeDailyLimit - searchesToday.value).clamp(0, freeDailyLimit);

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    cancelSearch();
    super.dispose();
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // ADDRESS RESOLUTION
  // ═══════════════════════════════════════════════════════════════════════════

  final _addressCache = <String, String>{};

  Future<String> resolveAddress(MatchResponseModel user) async {
    final id = user.id ?? '';
    if (_addressCache.containsKey(id)) return _addressCache[id]!;

    final rawAddress = user.address.trim() ?? '';
    if (rawAddress.isNotEmpty) {
      _addressCache[id] = rawAddress.capEachWord();
      return _addressCache[id]!;
    }

    final coords = user.location?.coordinates;
    if (coords != null && coords.length >= 2) {
      final resolved = await getOneLineAddress(
        latitude: coords[1].toString(), // GeoJSON: [lng, lat]
        longitude: coords[0].toString(),
      );
      _addressCache[id] = resolved;
      return resolved;
    }

    _addressCache[id] = 'N/A';
    return 'N/A';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Profile Info for wave limit
  // ═══════════════════════════════════════════════════════════════════════════

  final ProfileInfoService _profileInfoService = ProfileInfoService();

  final Rxn<ProfileDataModel> profile = Rxn<ProfileDataModel>();

  Future<void> fetchWaveLimit() async {
    final data = await _profileInfoService.fetchProfile();

    if (data != null) {
      profile.value = data;
    }
  }

  int get dailyWaveLimit => profile.value?.waveLimit?.limit ?? 3;

  int get remainingWaves => profile.value?.waveLimit?.remaining ?? 0;

  bool get isWaveLimitReached {
    final premium = PremiumAccessService.to;

    // Premium status is not known yet.
    // Never treat the user as a free user during initialization.
    if (!premium.isReady.value) {
      return false;
    }

    // Premium users never hit the free wave limit.
    if (premium.isPremiumUserNow) {
      return false;
    }

    return !(profile.value?.waveLimit?.isUnlimited ?? false) &&
        remainingWaves <= 0;
  }

  bool get hasPremiumAccess {
    final premium = PremiumAccessService.to;

    if (!premium.isReady.value) {
      return false;
    }

    return premium.isPremiumUserNow;
  }

  bool get premiumStatusReady => PremiumAccessService.to.isReady.value;

  // ═══════════════════════════════════════════════════════════════════════════
  // SEARCH
  // ═══════════════════════════════════════════════════════════════════════════

  RxBool isSearchLoading = false.obs;

  RxBool isLocationProcessing = false.obs;
  Future<void> enableLocationGatewayFlow() async {
    isLocationProcessing.value = true;
    final result = await AppLocationManager.to.enableLocationGateway();
    isLocationProcessing.value = false;

    if (result == LocationFlowResult.success) {
      await startSearching();
      return;
    }
    if (result == LocationFlowResult.serviceDisabled) {
      Snack.showWarning("Please turn on location service");
      await Geolocator.openLocationSettings();
      return;
    }
    if (result == LocationFlowResult.permissionDenied) {
      Snack.showWarning("Location permission required");
      return;
    }
    if (result == LocationFlowResult.permissionDeniedForever) {
      Snack.showError("Enable permission from app settings");
      await Geolocator.openAppSettings();
      return;
    }
    Snack.showError("Location unavailable");
  }

  Future<void> startSearching() async {
    final int currentSearchId = ++_searchId;

    if (isSearchLoading.value) return;

    // ─────────────────────────────────────────────
    // PREMIUM ACCESS CHECK
    // ─────────────────────────────────────────────
    final hasPremiumAccess = await _ensurePremiumAccess();

    if (!hasPremiumAccess) {
      return;
    }

    // ─────────────────────────────────────────────
    // FETCH LATEST WAVE LIMIT
    // ─────────────────────────────────────────────
    await fetchWaveLimit();

    if (isWaveLimitReached) {
      subUpgradeNeeded.value = true;
      await handleDailyLimitReached();
      return;
    }

    isSearchLoading.value = true;

    try {
      matchState.value = MatchState.searching;

      final locationResult = await AppLocationManager.to.ensureFreshLocation(
        showDialogs: true,
        forceRefresh: true,
      );

      final isLocationActive = locationResult == LocationFlowResult.success;

      await MainNavController.to.checkMatchLocationStatus(
        isActive: isLocationActive,
        showPopupIfChanged: true,
      );

      if (locationResult != LocationFlowResult.success) {
        matchState.value = MatchState.locationUnavailable;
        return;
      }

      await Future.delayed(const Duration(milliseconds: 300));

      final alm = AppLocationManager.to;

      final data = await MatchService().fetchMatches(
        latitude: alm.latitude.value.toString(),
        longitude: alm.longitude.value.toString(),
      );

      if (currentSearchId != _searchId) return;

      if (data.isEmpty) {
        matchState.value = MatchState.noMatch;
        return;
      }

      fetchedMatches.assignAll(data.whereType<MatchResponseModel>());

      _currentMatchIndex = 0;
      matchState.value = MatchState.found;
    } on MatchLimitExceededException {
      // Backend final validation
      subUpgradeNeeded.value = true;
      await handleDailyLimitReached();
    } catch (e) {
      log("❌ startSearching error: $e");

      if (currentSearchId == _searchId) {
        matchState.value = MatchState.noMatch;
      }
    } finally {
      isSearchLoading.value = false;
    }
  }

  void navToSubUpgrade() {
    if (Get.isDialogOpen ?? false) Get.back();
    Get.toNamed(RoutePaths.subscriptionUpgrade);
  }

  /////
  bool _isShowingLimitFlow = false;

  Future<void> handleDailyLimitReached() async {
    if (_isShowingLimitFlow) return;

    _isShowingLimitFlow = true;

    try {
      matchState.value = MatchState.idle;

      showDailyLimitDialog();

      await Future.delayed(const Duration(seconds: 2));

      Get.back();

      await Future.delayed(const Duration(milliseconds: 300));

      await Get.toNamed(RoutePaths.subscriptionUpgrade);

      await fetchWaveLimit();
    } finally {
      _isShowingLimitFlow = false;
    }
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // CANCEL / RESET
  // ═══════════════════════════════════════════════════════════════════════════

  void cancelSearch() {
    _searchId++;
    matchState.value = MatchState.idle;
    isSearchLoading.value = false;
  }

  void toggleSeeMore() => isSeeMore.toggle();

  void resetState() {
    matchState.value = MatchState.idle;
    _currentMatchIndex = 0;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTION — WAVE / PASS
  // ═══════════════════════════════════════════════════════════════════════════

  final socket = Get.find<SocketService>();
  final stopSearching = false.obs;

  final isSuccessSentReq = false.obs;
  /*
  Future<void> onAction(bool hasWaved, {required String receiverId}) async {
    if (hasWaved) {
      isWaveLoading.value = true;
    } else {
      isPassLoading.value = true;
    }

    await Future.delayed(const Duration(seconds: 1));

    if (hasWaved) {
      isWaveLoading.value = false;

      sendConversationRequest(receiverId);

      if (isSuccessSentReq.value) {
        await showWaveSentDialog(stopSearching: stopSearching);

        if (stopSearching.value) {
          matchState.value = MatchState.idle;
        } else {
          await _showNextMatch();
        }
      }
    } else {
      isPassLoading.value = false;

      matchState.value = MatchState.idle;
      await Future.delayed(const Duration(milliseconds: 600));
      await _showNextMatch();
    }
  }
*/
  // In MatchController

  Completer<bool>? _waveCompleter;

  void onWaveConfirmed(bool success) {
    if (_waveCompleter != null && !_waveCompleter!.isCompleted) {
      _waveCompleter!.complete(success);
    }
  }

  Future<void> onAction(bool hasWaved, {required String receiverId}) async {
    if (hasWaved) {
      isWaveLoading.value = true;
    } else {
      isPassLoading.value = true;
    }

    await Future.delayed(const Duration(seconds: 1));

    if (hasWaved) {
      // Try to (re)connect before giving up — keep the loading spinner up
      // for this, since it's still part of "sending the wave" from the
      // user's perspective.
      if (!socket.isConnected) {
        final reconnected = await socket.ensureConnected();
        if (!reconnected) {
          isWaveLoading.value = false;
          Snack.showError(
            "Unable to connect to the server. Please check your internet connection and try again.",
          );
          return;
        }
      }

      isWaveLoading.value = false;

      // Reset flag and set up completer BEFORE emitting
      isSuccessSentReq.value = false;
      _waveCompleter = Completer<bool>();

      sendConversationRequest(receiverId);

      final success = await _waveCompleter!.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => false,
      );

      if (success) {
        await fetchWaveLimit();
        await showWaveSentDialog(stopSearching: stopSearching);

        if (stopSearching.value) {
          matchState.value = MatchState.idle;
        } else {
          await _showNextMatch();
        }
      } else {
        Snack.showError("Couldn't send your wave. Please try again.");
      }
    } else {
      isPassLoading.value = false;
      matchState.value = MatchState.idle;
      await Future.delayed(const Duration(milliseconds: 600));
      await _showNextMatch();
    }
  }

  void sendConversationRequest(String receiverId) {
    socket.emit(SocketEvents.sendConversationRequest, {
      "receiverId": receiverId,
    });
  }

  /// Advances to the next match in the cached list.
  /// Only hits the API again when the list is fully exhausted.
  Future<void> _showNextMatch() async {
    _currentMatchIndex++;

    if (_currentMatchIndex < fetchedMatches.length) {
      // Still have local matches — just update the displayed index
      // fetchedMatches is already observed; rebuild is triggered by
      // matchState staying as MatchState.found while currentMatch getter
      // returns the new index. Force a notify by toggling state briefly.
      matchState.value = MatchState.searching;
      await Future.delayed(
        const Duration(milliseconds: 400),
      ); // brief transition
      matchState.value = MatchState.found;

      log(
        "➡️ Next local match: $_currentMatchIndex / ${fetchedMatches.length - 1} "
        "(${fetchedMatches[_currentMatchIndex].name})",
      );
    } else {
      // List exhausted — fetch fresh batch from API
      log("🔄 Match list exhausted — fetching new batch from API");
      _currentMatchIndex = 0;
      fetchedMatches.clear();
      await startSearching();
    }
  }

  Future<void> onTapUpgradeNow() async {
    if (Get.isDialogOpen ?? false) Get.back();
    final result = await Get.toNamed(RoutePaths.subscriptionUpgrade);
    log("result: $result");
  }
}



/*


startSearching()
│
├─ FREE + limit hit
│     showDailyLimitDialog()           ← shows immediately (non-blocking)
│     _fetchMatchesAndUpgrade()        ← runs in background concurrently
│           fetches API while dialog visible
│           navToSubUpgrade()          ← closes dialog, goes to upgrade screen
│
└─ Normal search (free within limit OR paid)
      searchesToday++  (free only)
      matchState = searching
      await 5s delay                   ← simulated UX delay
      if cancelled → bail
      fetchMatches() from backend      ← real API call
      matchState = found / noMatch



      */


      /*

user 1" ananda:
I/flutter (10351):  token :eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoSWQiOiI2OWI1Mjg0ZTJhNjg1YjQwOGQ4ZmY4MDciLCJlbWFpbCI6ImFuYW5kYUB5b3BtYWlsLmNvbSIsInByb2ZpbGVJZCI6IjY5YjUyODRlMmE2ODViNDA4ZDhmZjgwOSIsImlhdCI6MTc3NDM0ODQ3OCwiZXhwIjoxODA1ODg0NDc4fQ.jtVoZZOpuniKm4gbc7FCO746cffDZP7esa9Zp_SbchY


     user 2 : abc

I/flutter (18447):  token :eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoSWQiOiI2OWI2NjFkNmFiYzExMDM3MDVhYTc3MDIiLCJlbWFpbCI6ImFiY0B5b3BtYWlsLmNvbSIsInByb2ZpbGVJZCI6IjY5YjY2MWQ2YWJjMTEwMzcwNWFhNzcwNCIsImlhdCI6MTc3NDM0ODQ5NCwiZXhwIjoxODA1ODg0NDk0fQ.yX446f1F8PQGLIYxpB_bpWmtBHUg64qZow_XeQzf7H0
      */
