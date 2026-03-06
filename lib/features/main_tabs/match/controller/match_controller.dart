import '../../../../app/controller_export.dart';
 

import '../../../../app/helper_widgets_export.dart';

enum MatchState {
  idle,
  searching,
  found,
}

class MatchController extends GetxController {
  Rx<MatchState> matchState = MatchState.idle.obs;

  RxBool isLoading = false.obs;
  RxBool isSeeMore = false.obs;

  /// Fake delay to simulate search
  Future<void> startSearching() async {
    matchState.value = MatchState.searching;

    await Future.delayed(const Duration(seconds: 3));

    /// After search complete
    matchState.value = MatchState.found;
  }

  void cancelSearch() {
    matchState.value = MatchState.idle;
  }

  void toggleSeeMore() {
    isSeeMore.toggle();
  }

  Future<void> onAction(bool hasWaved) async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    if (hasWaved) {
      print("hasWaved");
       //
      // show popup of wave sent
      // after 1 sec, get back and UI should show try again button to find more mums


    } else {
      print("passed");
      //
     startSearching();
    }
  }
}