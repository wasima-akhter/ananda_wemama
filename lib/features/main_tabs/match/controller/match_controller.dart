import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mama_app/core/components/ui/dialogs/popups.dart';
import 'package:mama_app/core/services/socket/socket_events.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/network/helpers/location/location_manager_global/app_location_manager.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../model/match_model.dart';
import '../services/match_service.dart';

enum MatchState { idle, searching, found, noMatch, locationUnavailable }

class MatchController extends GetxController {
  Rx<MatchState> matchState = MatchState.idle.obs;

  static MatchController get to => Get.find<MatchController>();
  RxBool isWaveLoading = false.obs;
  RxBool isPassLoading = false.obs;
  RxBool isSeeMore = false.obs;
  RxBool subUpgradeNeeded = false.obs;

  bool isPaidUser = false;
  int freeDailyLimit = 10;
  int searchesToday = 0;
  int _searchId = 0;

  // ── Local match queue ──────────────────────────────────────────────────────
  // fetchedMatches holds ALL results from the last API call.
  // _currentMatchIndex tracks which one is currently displayed.
  // Pass advances the index locally — no new API call until the list is exhausted.
  final fetchedMatches = <MatchResponseModel>[].obs;
  int _currentMatchIndex = 0;

  MatchResponseModel? get currentMatch {
    if (fetchedMatches.isEmpty) return null;
    if (_currentMatchIndex >= fetchedMatches.length) return null;
    return fetchedMatches[_currentMatchIndex];
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onClose() {
    cancelSearch();
    resetState();
    super.onClose();
  }

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

    final rawAddress = user.address?.trim() ?? '';
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
  // SEARCH
  // ═══════════════════════════════════════════════════════════════════════════

  RxBool isSearchLoading = false.obs;

  /*
  Future<void> startSearching() async {
    final int currentSearchId = ++_searchId;

    // ─────────────────────────────────────
    // 1. LOCATION / PERMISSION CHECK
    // ─────────────────────────────────────
    final homeC = Get.find<HomeController>();

    final hasLocation = await homeC.runLocationPermissionFlowForSearch();

    if (!hasLocation) {
      matchState.value = MatchState.noMatch;
      return;
    }

    // ─────────────────────────────────────
    // 2. FREE USER LIMIT
    // ─────────────────────────────────────
    if (!isPaidUser && searchesToday >= freeDailyLimit) {
      subUpgradeNeeded.value = true;
      showDailyLimitDialog();
      _fetchMatchesAndUpgrade();
      return;
    }

    // ─────────────────────────────────────
    // 3. FREE USER COUNT
    // ─────────────────────────────────────
    if (!isPaidUser) searchesToday++;

    // ─────────────────────────────────────
    // 4. SEARCHING STATE
    // ─────────────────────────────────────
    matchState.value = MatchState.searching;

    await Future.delayed(const Duration(seconds: 5));

    if (currentSearchId != _searchId) return;

    // ─────────────────────────────────────
    // 5. FETCH MATCHES
    // ─────────────────────────────────────
    if (isSearchLoading.value) return;

    isSearchLoading.value = true;

    try {
      final slc = Get.find<StationLocationController>();

      final data = await MatchService().fetchMatches(
        latitude: slc.latitude.toString(),
        longitude: slc.longitude.toString(),
      );

      if (currentSearchId != _searchId) return;

      if (data.isEmpty) {
        matchState.value = MatchState.noMatch;
        return;
      }

      fetchedMatches.value = data;
      _currentMatchIndex = 0;

      matchState.value = MatchState.found;
    } catch (e) {
      log('startSearching fetch error: $e');

      if (currentSearchId == _searchId) {
        matchState.value = MatchState.noMatch;
      }
    } finally {
      isSearchLoading.value = false;
    }
  }

  //
  Future<void> _fetchMatchesAndUpgrade() async {
    if (isSearchLoading.value) return;
    isSearchLoading.value = true;

    try {
      final slc = Get.find<StationLocationController>();
      final data = await MatchService().fetchMatches(
        latitude: slc.latitude.toString(),
        longitude: slc.longitude.toString(),
      );

      if (data.isEmpty) {
        matchState.value = MatchState.noMatch;
      } else {
        fetchedMatches.value = data;
        _currentMatchIndex = 0;
      }

      await Future.delayed(const Duration(milliseconds: 600));
      navToSubUpgrade();
    } catch (e) {
      log('_fetchMatchesAndUpgrade error: $e');
      navToSubUpgrade();
    } finally {
      isSearchLoading.value = false;
    }
  }
*/
  Future<void> enableLocationGatewayFlow() async {
    final result = await AppLocationManager.to.enableLocationGateway();

    if (result == LocationFlowResult.success) {
      matchState.value = MatchState.searching;
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

    // ─────────────────────────────────────
    // 1. LOCATION + PERMISSION FLOW
    // ─────────────────────────────────────
    final locationResult = await AppLocationManager.to.ensureFreshLocation(
      showDialogs: true,
      forceRefresh: true,
    );

    if (locationResult != LocationFlowResult.success) {
      matchState.value = MatchState.locationUnavailable;
      return;
    }
    // ─────────────────────────────────────
    // 2. FREE USER LIMIT
    // ─────────────────────────────────────
    if (!isPaidUser && searchesToday >= freeDailyLimit) {
      subUpgradeNeeded.value = true;

      showDailyLimitDialog();

      await _fetchMatchesAndUpgrade();

      return;
    }

    // ─────────────────────────────────────
    // 3. FREE USER COUNT
    // ─────────────────────────────────────
    if (!isPaidUser) {
      searchesToday++;
    }

    // ─────────────────────────────────────
    // 4. SEARCHING UI STATE
    // ─────────────────────────────────────
    matchState.value = MatchState.searching;

    await Future.delayed(const Duration(seconds: 5));

    if (currentSearchId != _searchId) return;

    // ─────────────────────────────────────
    // 5. FETCH MATCHES
    // ─────────────────────────────────────
    if (isSearchLoading.value) return;

    isSearchLoading.value = true;

    try {
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

      fetchedMatches.value = data;

      _currentMatchIndex = 0;

      matchState.value = MatchState.found;
    } catch (e) {
      log("❌ startSearching fetch error: $e");

      if (currentSearchId == _searchId) {
        matchState.value = MatchState.noMatch;
      }
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<void> _fetchMatchesAndUpgrade() async {
    // ─────────────────────────────────────
    // 1. PREVENT DUPLICATE CALLS
    // ─────────────────────────────────────
    if (isSearchLoading.value) return;

    isSearchLoading.value = true;

    try {
      // ─────────────────────────────────────
      // 2. ENSURE LOCATION
      // ─────────────────────────────────────
      final locationResult = await AppLocationManager.to.ensureFreshLocation(
        showDialogs: true,
        forceRefresh: false,
      );

      if (locationResult != LocationFlowResult.success) {
        matchState.value = MatchState.locationUnavailable;

        navToSubUpgrade();

        return;
      }

      // ─────────────────────────────────────
      // 3. FETCH MATCHES
      // ─────────────────────────────────────
      final alm = AppLocationManager.to;

      final data = await MatchService().fetchMatches(
        latitude: alm.latitude.value.toString(),
        longitude: alm.longitude.value.toString(),
      );

      if (data.isEmpty) {
        matchState.value = MatchState.noMatch;
      } else {
        fetchedMatches.value = data;

        _currentMatchIndex = 0;
      }

      // ─────────────────────────────────────
      // 4. NAVIGATE TO SUBSCRIPTION
      // ─────────────────────────────────────
      await Future.delayed(const Duration(milliseconds: 600));

      navToSubUpgrade();
    } catch (e) {
      log("❌ _fetchMatchesAndUpgrade error: $e");

      navToSubUpgrade();
    } finally {
      isSearchLoading.value = false;
    }
  }

  void navToSubUpgrade() {
    if (Get.isDialogOpen ?? false) Get.back();
    Get.toNamed(RoutePaths.subscriptionUpgrade);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CANCEL / RESET
  // ═══════════════════════════════════════════════════════════════════════════

  void cancelSearch() {
    _searchId++;
    matchState.value = MatchState.idle;
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
      isWaveLoading.value = false;

      // Reset flag and set up completer BEFORE emitting
      isSuccessSentReq.value = false;
      _waveCompleter = Completer<bool>();

      sendConversationRequest(receiverId);

      // Wait for socket response (with timeout fallback)
      final success = await _waveCompleter!.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => false,
      );

      if (success) {
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

  void sendConversationRequest(String receiverId) {
    socket.emit(SocketEvents.sendConversationRequest, {
      "receiverId": receiverId,
    });
  }

  Future<void> onTapUpgradeNow() async {
    if (Get.isDialogOpen ?? false) Get.back();
    final result = await Get.toNamed(RoutePaths.subscriptionUpgrade);
    log("result: $result");
  }
}
/* socket


 final socket = Get.find<SocketService>();

  @override
  void onInit() {
    super.onInit();

    socket.on("new_match", (data) {
      log("🔥 New Match: $data");

      Get.snackbar("Match Found 🎉", "You got a new match!");
    });
  }

  */


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
