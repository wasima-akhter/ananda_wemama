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

  @override
  void onInit() {
    super.onInit();

    final premium = PremiumAccessService.to;
    isPaidUser.value = premium.isPremiumUserNow;
    _premiumWorker = ever<bool>(premium.isPremiumUser, (isPremium) {
      isPaidUser.value = isPremium;
    });

    _restoreSearchCount();

    // ✅ Await the profile fetch
    _initializeProfile();

    cancelSearch();
    resetState();
  }

  Future<void> _initializeProfile() async {
    print('⏳ [MatchController] Initializing profile...');
    await fetchWaveLimit();
    print('✅ [MatchController] Profile initialized');
  }

  // ✅ Update the wave limit check
  bool get isWaveLimitReached {
    // final premium = PremiumAccessService.to;

    // if (!premium.isReady.value) {
    //   print('⚠️  Premium not ready in isWaveLimitReached');
    //   return false;
    // }

    // print('🔍 isWaveLimitReached check:');
    // print('   isPremiumUserNow: ${premium.isPremiumUserNow}');
    // print('   isUnlimited: ${profile.value?.waveLimit?.isUnlimited}');
    // print('   remainingWaves: $remainingWaves');

    // if (premium.isPremiumUserNow) {
    //   print('   → PREMIUM: no limit');
    //   return false;
    // }

    // final isLimited =
    //     !(profile.value?.waveLimit?.isUnlimited ?? false) &&
    //     remainingWaves <= 0;

    // print('   → FREE: limited=$isLimited');
    // return isLimited;

    return false;
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
    print("📍 MatchController: starting location permission flow");

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
      print(
        "📍 MatchController: checking location status (service + permission)",
      );

      // ✅ ONLY check service and permission — don't fetch coordinates
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      LocationPermission permission = await Geolocator.checkPermission();
      final hasPermission =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      final isActive = serviceEnabled && hasPermission;

      print("📍 Service enabled: $serviceEnabled");
      print("📍 Has permission: $hasPermission");
      print("📍 Overall active: $isActive");

      // ─────────────────────────────────────────────
      // FIRST CHECK
      // ─────────────────────────────────────────────
      if (_lastKnownLocationActive == null) {
        _lastKnownLocationActive = isActive;

        print(
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
        print(
          "📍 Location status changed: "
          "$_lastKnownLocationActive → $isActive",
        );

        _lastKnownLocationActive = isActive;

        checkLocationPopup(isActive: isActive);
        return;
      }

      print(
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

  int get remainingWaves {
    // Premium users should never show a wave count
    final premium = PremiumAccessService.to;
    if (premium.isReady.value && premium.isPremiumUserNow) {
      return -1; // or some sentinel value meaning "unlimited"
    }

    // Free users show actual count from backend
    return profile.value?.waveLimit?.remaining ?? 0;
  }

  bool get isUnlimited =>
      true ??
      profile.value?.waveLimit?.isUnlimited ??
      false ||
          (PremiumAccessService.to.isReady.value &&
              PremiumAccessService.to.isPremiumUserNow);

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

  /// Ensures premium service is ready.
  /// Does NOT block free users — only ensures the service is initialized.
  Future<bool> _ensurePremiumServiceReady() async {
    final premiumService = PremiumAccessService.to;

    print('\n╔════════════════════════════════════════╗');
    print('║ [MatchController] SERVICE INIT START   ║');
    print('╚════════════════════════════════════════╝');

    premiumService.printFullState();

    // ─────────────────────────────────────────────
    // WAIT FOR PREMIUM SERVICE TO BE READY
    // ─────────────────────────────────────────────
    if (!premiumService.isReady.value) {
      print('⏳ [MatchController] Premium service NOT ready, waiting...');

      int attempts = 0;
      while (!premiumService.isReady.value && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      print('⏳ [MatchController] Waited $attempts attempts');

      if (!premiumService.isReady.value) {
        print('🔴 [MatchController] Service initialization TIMEOUT');
        premiumService.printFullState();

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        return false;
      }

      print('✅ [MatchController] Premium service is now READY');
      premiumService.printFullState();
    } else {
      print('✅ [MatchController] Premium service already READY');
    }

    print('╔════════════════════════════════════════╗');
    print('║ [MatchController] SERVICE INIT DONE    ║');
    print('╚════════════════════════════════════════╝\n');

    return true;
  }

  Future<void> startSearching() async {
    final int currentSearchId = ++_searchId;

    if (isSearchLoading.value) return;

    // ─────────────────────────────────────────────
    // ENSURE PREMIUM SERVICE IS READY
    // (Does NOT block free users)
    // ─────────────────────────────────────────────
    final serviceReady = await _ensurePremiumServiceReady();

    if (!serviceReady) {
      print('❌ Premium service failed to initialize');
      Snack.showError('Failed to initialize. Please try again.');
      return;
    }

    // ─────────────────────────────────────────────
    // FETCH LATEST WAVE LIMIT
    // ─────────────────────────────────────────────
    await fetchWaveLimit();

    // ✅ Check premium status
    final premium = PremiumAccessService.to;
    final isPremium = premium.isPremiumUserNow;

    print('\n🔍 [MatchController.startSearching] Premium check:');
    print('   isPremium: $isPremium');
    print('   isWaveLimitReached: $isWaveLimitReached');
    print('   remainingWaves: $remainingWaves');

    // ❌ FREE user with no waves → block
    if (!isPremium && isWaveLimitReached) {
      print('🔒 FREE user hit daily limit');
      subUpgradeNeeded.value = true;
      await handleDailyLimitReached();
      return;
    }

    // ✅ PREMIUM or FREE with waves remaining → proceed
    print(
      '✅ User can search: ${isPremium ? "PREMIUM" : "FREE ($remainingWaves waves)"}',
    );

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

      // ✅ ASSIGN MATCHES AND UPDATE UI
      fetchedMatches.assignAll(data.whereType<MatchResponseModel>());

      _currentMatchIndex = 0;
      matchState.value = MatchState.found;

      print('📊 Matches loaded: ${fetchedMatches.length}');
      print('📊 Current match: ${currentMatch?.name}');

      // ✅ Increment search count for FREE users only
      if (!isPremium) {
        _incrementSearchCount();
        print('📊 Search count incremented: $searchesToday / $freeDailyLimit');
      }
    } on MatchLimitExceededException {
      // Backend final validation
      subUpgradeNeeded.value = true;
      await handleDailyLimitReached();
    } catch (e) {
      print("❌ startSearching error: $e");

      if (currentSearchId == _searchId) {
        matchState.value = MatchState.noMatch;
      }
    } finally {
      isSearchLoading.value = false;
    }
  }

  // ✅ Remove the old _ensurePremiumAccess() method entirely
  // or keep it for backward compatibility but don't use it
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

      print(
        "➡️ Next local match: $_currentMatchIndex / ${fetchedMatches.length - 1} "
        "(${fetchedMatches[_currentMatchIndex].name})",
      );
    } else {
      // List exhausted — fetch fresh batch from API
      print("🔄 Match list exhausted — fetching new batch from API");
      _currentMatchIndex = 0;
      fetchedMatches.clear();
      await startSearching();
    }
  }

  Future<void> onTapUpgradeNow() async {
    if (Get.isDialogOpen ?? false) Get.back();
    final result = await Get.toNamed(RoutePaths.subscriptionUpgrade);
    print("result: $result");
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
