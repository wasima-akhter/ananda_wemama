import 'dart:math';

import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/controller_export.dart';
import '../../../../app/helper_widgets_export.dart';

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
  int freeDailyLimit = 3;

  /// how many searches done today
  int searchesToday = 0;
  int _searchId = 0;

  @override
  void onInit() {
    super.onInit();
  }

  /// ---------------- SEARCH ----------------

  Future<void> startSearching() async {
    final int currentSearchId = ++_searchId;

    /// ---------- CHECK SUBSCRIPTION ----------
    if (!isPaidUser && searchesToday >= freeDailyLimit) {
      subUpgradeNeeded.value = true;
      Get.toNamed(RoutePaths.subscriptionUpgrade);
      return;
    }

    if (!isPaidUser) {
      searchesToday++;
    }

    matchState.value = MatchState.searching;

    /// simulate backend delay
    await Future.delayed(const Duration(seconds: 5));

    /// if user cancelled or new search started → stop
    if (currentSearchId != _searchId) return;

    bool matchFound = _mockMatchResult();

    if (matchFound) {
      matchState.value = MatchState.found;
    } else {
      matchState.value = MatchState.noMatch;
    }
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

  Future<void> onAction(bool hasWaved) async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    if (hasWaved) {
      /// show wave sent popup
      showWaveSenDialog();

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

  Future<void> onTapUpgradeNow() async {
    if (Get.isDialogOpen ?? false) {
      Get.back(); // close popup
    }

    final result = await Get.toNamed(RoutePaths.subscriptionUpgrade);

    print("result: $result");
  }
}
