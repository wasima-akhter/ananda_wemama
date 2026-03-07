import 'package:mama_app/features/main_tabs/chat/screen/chat_screen.dart';
import 'package:mama_app/features/main_tabs/community/screen/community_screen.dart';
import 'package:mama_app/features/main_tabs/experts/screen/experts_screen.dart';
import 'package:mama_app/features/main_tabs/match/screen/match_screen.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../core/state_screens/not_found/not_found_page.dart';
import '../../main_tabs/home/controller/home_controller.dart';
import '../../main_tabs/home/screen/home_screen.dart';
import '../../main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../station_location/controller/station_location_controller.dart';

class MainNavController extends GetxController {
  /// Singleton access
  static MainNavController get to => Get.find<MainNavController>();

  // ─────────────────────────────
  // 🔹 Bottom Nav & UI state
  // ─────────────────────────────
  final currentIndex = 0.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastBackPressTime;

  /// Tabs / pages
  late final List<Widget> pages = [
    const HomeScreen(),
    const ChatScreen(),
    const MatchScreen(),
    const CommunityScreen(),
    const ExpertsScreen(),
  ];

  /// Bottom nav icons
  late final List<String> icons = [
    IconsPath.home,
    IconsPath.chat,
    IconsPath.match,
    IconsPath.community,
    IconsPath.experts,
  ];

  /// Bottom nav labels
  late final List<String> labels = [
    Strings.home.capEachWord(),
    Strings.chat.capEachWord(),
    Strings.match.capEachWord(),
    Strings.community.capEachWord(),
    Strings.experts.capEachWord(),
  ];

  // ─────────────────────────────
  // 🔹 Lifecycle / Initialization
  // ─────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initializeAppData();
  }

  /// Loads initial profile and location data
  Future<void> _initializeAppData() async {
    await Future.wait([_loadProfile(), _getCurrentLocation(), _loadNearbySuppliers()]);
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

  Future<void> _loadNearbySuppliers() async {
    try {
      final slc = Get.find<StationLocationController>();
      await Get.find<HomeController>().getNearbySuppliersWithPriceStats(
        latitude: slc.latitude.value,
        longitude: slc.longitude.value,
      );
    } catch (e) {
      debugPrint("Error loading nearby suppliers: $e");
    }
  }

  // ─────────────────────────────
  // 🔹 Tab Navigation
  // ─────────────────────────────

  /// Change tab programmatically
  void goToTab(int index) {
    if (_isValidIndex(index)) {
      currentIndex.value = index;
    } else {
      debugPrint("Attempted to goToTab with invalid index: $index");
    }
  }

  /// Bottom nav tap
  void onTapIndex(int index) {
    if (_isValidIndex(index) && index != currentIndex.value) {
      currentIndex.value = index;
    }
  }

  /// Safely get current page widget
  Widget get currentPageWidget {
    if (_isValidIndex(currentIndex.value)) {
      return pages[currentIndex.value];
    } else {
      return const RouteNotFoundPage();
    }
  }

  /// Safely get current icon
  String get currentIcon =>
      _isValidIndex(currentIndex.value) ? icons[currentIndex.value] : IconsPath.home;

  /// Safely get current label
  String get currentLabel =>
      _isValidIndex(currentIndex.value) ? labels[currentIndex.value] : Strings.home.capEachWord();

  /// Checks if index is within bounds
  bool _isValidIndex(int index) => index >= 0 && index < pages.length;

  // ─────────────────────────────
  // 🔹 Back button / exit logic
  // ─────────────────────────────
  Future<bool> handleWillPop() async {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
      return false; // navigate to home tab instead of exiting
    }

    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      // Optionally show toast: "Press again to exit"
      return false;
    }

    return true; // allow system exit
  }

  // ─────────────────────────────
  // 🔹 Role-based Page Helper
  // ─────────────────────────────
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
