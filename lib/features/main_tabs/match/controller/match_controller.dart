import 'dart:math';

import 'package:mama_app/core/common_widgets/popups.dart';
import 'package:mama_app/core/services/socket/socket_events.dart';
import 'package:mama_app/features/main_tabs/match/services/match_service.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../station_location/controller/station_location_controller.dart';
import '../model/match_model.dart';

enum MatchState { idle, searching, found, noMatch }

class MatchController extends GetxController {
  Rx<MatchState> matchState = MatchState.idle.obs;

  static MatchController get to => Get.find<MatchController>();

  RxBool isLoading = false.obs;
  RxBool isSeeMore = false.obs;
  RxBool subUpgradeNeeded = false.obs;

  /// ---------------- MOCK DATA ----------------

  /// change this to simulate subscription
  bool isPaidUser = false;

  /// free user limit
  int freeDailyLimit = 10;

  /// how many searches done today
  int searchesToday = 0;
  int _searchId = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    cancelSearch();
    resetState();
    super.onClose();
  }

  @override
  void dispose() {
    cancelSearch(); // cancel when leaving page
    super.dispose();
  }

  /// ------- Load address ---------///
  /// Cache: matchId → resolved one-line address string
  final _addressCache = <String, String>{};

  /// Returns the resolved address for a given match.
  /// Priority: address field → reverse geocode from coordinates → placeholder
  Future<String> resolveAddress(MatchResponseModel user) async {
    final id = user.id ?? '';

    // Return cached value immediately if already resolved
    if (_addressCache.containsKey(id)) return _addressCache[id]!;

    // ── 1. Use address field if non-empty ────────────────────────────────────
    final rawAddress = user.address?.trim() ?? '';
    if (rawAddress.isNotEmpty) {
      _addressCache[id] = rawAddress.capEachWord();
      return _addressCache[id]!;
    }

    // ── 2. Fall back to reverse geocoding from coordinates ───────────────────
    final coords = user.location?.coordinates;
    // GeoJSON order is [longitude, latitude]
    if (coords != null && coords.length >= 2) {
      final lng = coords[0];
      final lat = coords[1];

      final resolved = await getOneLineAddress(latitude: lat.toString(), longitude: lng.toString());

      _addressCache[id] = resolved;
      return resolved;
    }

    // ── 3. Nothing available ─────────────────────────────────────────────────
    _addressCache[id] = 'N/A';
    return 'N/A';
  }
  ////////

  /// ---------------- SEARCH ----------------
  RxBool isSearchLoading = false.obs;
  final fetchedMatches = <MatchResponseModel>[].obs;

  Future<void> startSearching() async {
    final int currentSearchId = ++_searchId;

    // ── 1. FREE USER DAILY LIMIT HIT ─────────────────────────────────────────
    // Show dialog + fetch matches in background so we can pass them to the
    // upgrade screen. The user sees the limit dialog while we load.
    if (!isPaidUser && searchesToday >= freeDailyLimit) {
      subUpgradeNeeded.value = true;
      showDailyLimitDialog(); // non-blocking — dialog shows, flow continues

      _fetchMatchesAndUpgrade(); // fire-and-forget background fetch
      return;
    }

    // ── 2. FREE USER WITHIN LIMIT ─────────────────────────────────────────────
    if (!isPaidUser) {
      searchesToday++;
    }

    // ── 3. SEARCHING STATE + SIMULATED DELAY ─────────────────────────────────
    matchState.value = MatchState.searching;
    await Future.delayed(const Duration(seconds: 5));

    // Cancelled or superseded by a newer search — bail out silently
    if (currentSearchId != _searchId) return;

    // ── 4. FETCH REAL MATCHES FROM BACKEND ────────────────────────────────────
    if (isSearchLoading.value) return; // prevent duplicate concurrent calls
    isSearchLoading.value = true;

    try {
      final slc = Get.find<StationLocationController>();
      final data = await MatchService().fetchMatches(
        latitude: slc.latitude.toString(),
        longitude: slc.longitude.toString(),
      );

      // Cancelled while awaiting network — discard result
      if (currentSearchId != _searchId) return;

      if (data.isEmpty) {
        matchState.value = MatchState.noMatch;
        return;
      }

      fetchedMatches.value = data;
      matchState.value = MatchState.found;
    } catch (e) {
      debugPrint('startSearching fetch error: $e');
      // Don't leave the user on MatchState.searching on error
      if (currentSearchId == _searchId) {
        matchState.value = MatchState.noMatch;
      }
    } finally {
      isSearchLoading.value = false;
    }
  }

  /// Fetches matches in the background while the daily-limit dialog is visible,
  /// then navigates to the upgrade screen with the results pre-loaded.
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
      }

      // Small pause so the dialog has time to render before navigating away
      await Future.delayed(const Duration(milliseconds: 600));
      navToSubUpgrade();
    } catch (e) {
      debugPrint('_fetchMatchesAndUpgrade error: $e');
      // Still navigate — upgrade screen can handle empty state
      navToSubUpgrade();
    } finally {
      isSearchLoading.value = false;
    }
  }

  void navToSubUpgrade() {
    if (Get.isDialogOpen ?? false) Get.back(); // close daily-limit dialog first
    Get.toNamed(RoutePaths.subscriptionUpgrade);
  }

  /// simulate backend matching
  bool _mockMatchResult() {
    /// 60% chance to find match
    return Random().nextInt(100) < 60;
  }

  /// ---------------- CANCEL SEARCH ----------------

  void cancelSearch() {
    _searchId++; // invalidate previous search
    matchState.value = MatchState.idle;
  }

  /// ---------------- SEE MORE ----------------

  void toggleSeeMore() {
    isSeeMore.toggle();
  }

  void resetState() {
    matchState.value = MatchState.idle;
  }

  /// ---------------- ACTION (WAVE / PASS) ----------------
  final socket = Get.find<SocketService>();
  Future<void> onAction(bool hasWaved, {required String receiverId}) async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    if (hasWaved) {
      // send socket request to the userid first, then show the popup.

      sendConversationRequest(receiverId);

      /// show wave sent popup
      showWaveSentDialog();

      /// search again after delay
      Future.delayed(const Duration(seconds: 1), () async {
        Get.back(); // close popup

        await startSearching();
      });
    } else {
      /// pass → find next match
      startSearching();
    }
  }

  void sendConversationRequest(String receiverId) {
    socket.emit(SocketEvents.sendConversationRequest, {"receiverId": receiverId});
  }

  Future<void> onTapUpgradeNow() async {
    if (Get.isDialogOpen ?? false) {
      Get.back(); // close popup
    }

    final result = await Get.toNamed(RoutePaths.subscriptionUpgrade);

    print("result: $result");
  }
}

/* socket 


 final socket = Get.find<SocketService>();

  @override
  void onInit() {
    super.onInit();

    socket.on("new_match", (data) {
      print("🔥 New Match: $data");

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