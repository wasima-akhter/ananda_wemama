import 'package:we_mama/features/main_tabs/chat/screen/chat_screen.dart';
import 'package:we_mama/features/main_tabs/experts/screen/experts_screen.dart';
import 'package:we_mama/features/main_tabs/match/screen/match_screen.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../core/network/helpers/location/location_manager_global/app_location_manager.dart';
import '../../../core/network/helpers/location/location_observer.dart';
import '../../../core/services/socket/socket_service.dart';
import '../../../core/state_screens/not_found/not_found_page.dart';
import '../../main_tabs/chat/controller/chat_controller.dart';
import '../../main_tabs/community/feed/screens/community_screen.dart';
import '../../main_tabs/home/screen/home_screen.dart';
import '../../main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../station_location/controller/station_location_controller.dart';

class MainNavController extends GetxController {
  static MainNavController get to => Get.find<MainNavController>();

  final currentIndex = 0.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastBackPressTime;

  bool _homePermissionFlowDone = false;
  bool _locationStateChangedWhileAway = false;
  bool _locationTurnedOnWhileAway = false;

  late final List<Widget> pages = [
    const HomeScreen(),
    const ChatScreen(),
    const MatchScreen(),
    const CommunityScreen(),
    const ExpertsScreen(),
  ];

  late final List<String> icons = [
    IconsPath.home,
    IconsPath.chat,
    IconsPath.match,
    IconsPath.community,
    IconsPath.experts,
  ];

  late final List<String> labels = [
    Strings.home.capEachWord(),
    Strings.chat.capEachWord(),
    Strings.match.capEachWord(),
    Strings.community.capEachWord(),
    Strings.experts.capEachWord(),
  ];

  @override
  void onInit() {
    super.onInit();
    print("🧭 MainNavController onInit");
    _initLocationObserver();
    _initializeAppData();

    // ✅ Pre-fetch chat list as soon as mainNav loads
    // Use addPostFrameCallback so socket is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchChatList();
    });

    //
    print('🔧 [MainNavController] onInit');
  }

  // new logic
  bool _matchLocationCheckDone = false;
  bool? _lastMatchLocationStatus;

  // ─────────────────────────────────────────────────────────────────────────
  // 🔹 MATCH LOCATION POPUP CONTROL
  // ─────────────────────────────────────────────────────────────────────────

  /// Called whenever the user enters the Match tab.
  ///
  /// Rules:
  /// FIRST VISIT:
  ///   ON  -> popup
  ///   OFF -> popup
  ///
  /// LATER VISITS:
  ///   same status  -> no popup
  ///   changed      -> popup
  ///
  /// The MainNavController is the single owner of Match-entry popup logic.
  ///

  Future<void> checkMatchLocationOnEnter() async {
    final result = await AppLocationManager.to.ensureFreshLocation(
      showDialogs: true,
      forceRefresh: false,
    );

    await checkMatchLocationStatus(
      isActive: result == LocationFlowResult.success,
      showPopupIfChanged: true,
    );
  }

  Future<bool> checkMatchLocationStatus({
    required bool isActive,
    bool showPopupIfChanged = true,
  }) async {
    // FIRST CHECK
    if (!_matchLocationCheckDone) {
      _matchLocationCheckDone = true;
      _lastMatchLocationStatus = isActive;

      if (showPopupIfChanged) {
        MatchScreen.showLocationStatusOverlay(isActive: isActive);
      }

      print(
        "📍 Match location FIRST CHECK → "
        "active: $isActive, "
        "popup: $showPopupIfChanged",
      );

      return true;
    }

    // LATER CHECK
    final changed = _lastMatchLocationStatus != isActive;

    if (changed) {
      _lastMatchLocationStatus = isActive;

      if (showPopupIfChanged) {
        MatchScreen.showLocationStatusOverlay(isActive: isActive);
      }

      print(
        "📍 Match location CHANGED → "
        "active: $isActive → POPUP",
      );

      return true;
    }

    print(
      "📍 Match location UNCHANGED → "
      "active: $isActive → NO POPUP",
    );

    return false;
  }

  //
  void _onOsLocationEnabled() {
    print("📍 OS: Location turned ON");

    if (!_homePermissionFlowDone) return;

    _updateLocationInBackground();

    if (currentIndex.value == 2) {
      checkMatchLocationStatus(isActive: true, showPopupIfChanged: true);
      return;
    }

    if (currentIndex.value == 0) {
      MatchScreen.showLocationStatusOverlay(isActive: true);
    } else {
      _locationStateChangedWhileAway = true;
      _locationTurnedOnWhileAway = true;
    }
  }

  void _onOsLocationDisabled() {
    print("📍 OS: Location turned OFF");

    if (!_homePermissionFlowDone) return;

    if (currentIndex.value == 2) {
      checkMatchLocationStatus(isActive: false, showPopupIfChanged: true);
      return;
    }

    if (currentIndex.value == 0) {
      MatchScreen.showLocationStatusOverlay(isActive: false);
    } else {
      _locationStateChangedWhileAway = true;
      _locationTurnedOnWhileAway = false;
    }
  }

  // end of new logic
  // ─────────────────────────────
  // 🔹 Called by HomeScreen.initState → postFrameCallback
  // ─────────────────────────────
  void notifyHomeFirstBuild() {
    print(
      "🧭 notifyHomeFirstBuild — _homePermissionFlowDone: $_homePermissionFlowDone",
    );
    if (_homePermissionFlowDone) return;
    _homePermissionFlowDone = true;
    MatchScreen.triggerPermissionFlow();
  }

  // ─────────────────────────────
  // 🔹 Location OS Observer
  // ─────────────────────────────
  Future<void> _initLocationObserver() async {
    // ✅ Seed AFTER permission flow has had a chance to run
    // Observer only handles changes AFTER first build — not the initial state
    await LocationStatusObserver.instance.seedCurrentStatus();
    LocationStatusObserver.instance.startListening(
      onLocationEnabled: _onOsLocationEnabled,
      onLocationDisabled: _onOsLocationDisabled,
    );
  }

  /*
// old code
  void _onOsLocationEnabled() {
    print("📍 OS: Location turned ON");

    // ✅ Only react if permission flow is already done —
    // otherwise the flow itself handles the first overlay
    if (!_homePermissionFlowDone) return;

    _updateLocationInBackground();

    if (currentIndex.value == 0) {
      MatchScreen.showLocationStatusOverlay(isActive: true);
    } else {
      _locationStateChangedWhileAway = true;
      _locationTurnedOnWhileAway = true;
    }
  }

  void _onOsLocationDisabled() {
    print("📍 OS: Location turned OFF");

    // ✅ Same guard — ignore if permission flow hasn't completed yet
    if (!_homePermissionFlowDone) return;

    if (currentIndex.value == 0) {
      MatchScreen.showLocationStatusOverlay(isActive: false);
    } else {
      _locationStateChangedWhileAway = true;
      _locationTurnedOnWhileAway = false;
    }
  }
*/
  Future<void> _updateLocationInBackground() async {
    try {
      await Get.find<StationLocationController>().getAndSaveInBackendCurrLoc();
    } catch (e) {
      print("Background location update failed: $e");
    }
  }

  // ─────────────────────────────
  // 🔹 Tab Navigation
  // ─────────────────────────────
  void goToTab(int index) {
    if (_isValidIndex(index)) {
      currentIndex.value = index;
      _onTabChanged(index);
    }
  }

  void onTapIndex(int index) {
    if (_isValidIndex(index) && index != currentIndex.value) {
      currentIndex.value = index;
      _onTabChanged(index);
    }
  }

  // void _onTabChanged(int index) {
  //   if (index == 0) _handleReturnToHome();
  // }
  // new logic
  void _onTabChanged(int index) {
    if (index == 2) {
      checkMatchLocationOnEnter();
    }

    if (index == 0) {
      _handleReturnToHome();
    }
  }

  void _handleReturnToHome() {
    if (!_homePermissionFlowDone)
      return; // first build handles itself via notifyHomeFirstBuild

    if (_locationStateChangedWhileAway) {
      _locationStateChangedWhileAway = false;
      Future.delayed(const Duration(milliseconds: 400), () {
        MatchScreen.showLocationStatusOverlay(
          isActive: _locationTurnedOnWhileAway,
        );
      });
    }
  }

  // ─────────────────────────────
  // 🔹 Data Initialization
  // ─────────────────────────────
  Future<void> _initializeAppData() async {
    await Future.wait([_loadProfile()]);
  }

  Future<void> _loadProfile() async {
    try {
      await Get.find<ProfileController>().fetchMyProfile();
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  void _prefetchChatList() {
    // Only fetch if socket is connected
    if (Get.isRegistered<SocketService>()) {
      final socket = Get.find<SocketService>();
      if (socket.isConnected) {
        // Force-create ChatController if not already created
        final chatCtrl = Get.put(ChatController());
        chatCtrl.getChatList();
        print("💬 Chat list pre-fetched from MainNav");
      } else {
        print("⚠️ Socket not connected — skipping chat prefetch");
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      await Get.find<StationLocationController>().getAndSaveInBackendCurrLoc();
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Widget get currentPageWidget => _isValidIndex(currentIndex.value)
      ? pages[currentIndex.value]
      : const RouteNotFoundPage();

  String get currentIcon => _isValidIndex(currentIndex.value)
      ? icons[currentIndex.value]
      : IconsPath.home;

  String get currentLabel => _isValidIndex(currentIndex.value)
      ? labels[currentIndex.value]
      : Strings.home.capEachWord();

  bool _isValidIndex(int index) => index >= 0 && index < pages.length;

  Future<bool> handleWillPop() async {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
      _handleReturnToHome();
      return false;
    }
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      return false;
    }
    return true;
  }

  Widget roleBasedPage({
    required bool isCustomer,
    required bool isSupplier,
    required Widget customerPage,
    required Widget supplierPage,
  }) {
    if (isCustomer) return customerPage;
    if (isSupplier) return supplierPage;
    return const RouteNotFoundPage();
  }
}
////
 /*
runLocationPermissionFlow()
  ├─ service ON + permission granted → _refreshLocationData() (silent)
  ├─ service OFF                     → _showTurnOnServiceDialog()
  │                                      └─ user said "not now" → showOverlay(inactive)
  │                                      └─ user opened settings → re-check → showOverlay
  ├─ permission denied               → _showRationaleDialog() → system dialog
  └─ permanently denied              → _showPermanentlyDeniedDialog() → app settings
///
 */


/*

1. FOREGROUND (app open, user using it)
   → Show local notification banner (already doing this ✅)
   → On tap → route to relevant screen
   → Optionally: refresh the current screen's data silently without routing

2. BACKGROUND (app open but minimized)
   → System shows the notification (FCM/local) ✅
   → On tap → app comes to foreground → route to relevant screen

3. TERMINATED (app fully closed)
   → System shows the notification ✅
   → On tap → app cold launches → route to relevant screen AFTER login check

   */
