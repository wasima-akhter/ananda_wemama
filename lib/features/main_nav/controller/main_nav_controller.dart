import 'package:mama_app/features/main_tabs/chat/screen/chat_screen.dart';
import 'package:mama_app/features/main_tabs/community/screen/community_screen.dart';
import 'package:mama_app/features/main_tabs/experts/screen/experts_screen.dart';
import 'package:mama_app/features/main_tabs/match/screen/match_screen.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../core/network/helpers/location/location_observer.dart';
import '../../../core/state_screens/not_found/not_found_page.dart';
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
    debugPrint("🧭 MainNavController onInit");
    _initLocationObserver();
    _initializeAppData();
  }

  @override
  void onClose() {
    LocationStatusObserver.instance.stopListening();
    super.onClose();
  }

  // ─────────────────────────────
  // 🔹 Called by HomeScreen.initState → postFrameCallback
  // ─────────────────────────────
  void notifyHomeFirstBuild() {
    debugPrint("🧭 notifyHomeFirstBuild — _homePermissionFlowDone: $_homePermissionFlowDone");
    if (_homePermissionFlowDone) return;
    _homePermissionFlowDone = true;
    HomeScreen.triggerPermissionFlow();
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

  void _onOsLocationEnabled() {
    debugPrint("📍 OS: Location turned ON");

    // ✅ Only react if permission flow is already done —
    // otherwise the flow itself handles the first overlay
    if (!_homePermissionFlowDone) return;

    _updateLocationInBackground();

    if (currentIndex.value == 0) {
      HomeScreen.showLocationStatusOverlay(isActive: true);
    } else {
      _locationStateChangedWhileAway = true;
      _locationTurnedOnWhileAway = true;
    }
  }

  void _onOsLocationDisabled() {
    debugPrint("📍 OS: Location turned OFF");

    // ✅ Same guard — ignore if permission flow hasn't completed yet
    if (!_homePermissionFlowDone) return;

    if (currentIndex.value == 0) {
      HomeScreen.showLocationStatusOverlay(isActive: false);
    } else {
      _locationStateChangedWhileAway = true;
      _locationTurnedOnWhileAway = false;
    }
  }

  Future<void> _updateLocationInBackground() async {
    try {
      await Get.find<StationLocationController>().getAndSaveInBackendCurrLoc();
    } catch (e) {
      debugPrint("Background location update failed: $e");
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

  void _onTabChanged(int index) {
    if (index == 0) _handleReturnToHome();
  }

  void _handleReturnToHome() {
    if (!_homePermissionFlowDone) return; // first build handles itself via notifyHomeFirstBuild

    if (_locationStateChangedWhileAway) {
      _locationStateChangedWhileAway = false;
      Future.delayed(const Duration(milliseconds: 400), () {
        HomeScreen.showLocationStatusOverlay(isActive: _locationTurnedOnWhileAway);
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
      debugPrint("Error loading profile: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      await Get.find<StationLocationController>().getAndSaveInBackendCurrLoc();
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  Widget get currentPageWidget =>
      _isValidIndex(currentIndex.value) ? pages[currentIndex.value] : const RouteNotFoundPage();

  String get currentIcon =>
      _isValidIndex(currentIndex.value) ? icons[currentIndex.value] : IconsPath.home;

  String get currentLabel =>
      _isValidIndex(currentIndex.value) ? labels[currentIndex.value] : Strings.home.capEachWord();

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

