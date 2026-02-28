import '../../../app/helper_widgets_export.dart';
import '../../../core/state_screens/not_found/not_found_page.dart';
import '../../home/controller/home_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/screen/profile_screen.dart';
import '../../station_location/controller/station_location_controller.dart';

class MainNavController extends GetxController {
  static MainNavController get to => Get.find<MainNavController>();
  DateTime? currentBackPressTime;

  final currentIndex = 0.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> get pages => [
    const ProfileScreen(),
    const ProfileScreen(),
    const ProfileScreen(),
    const ProfileScreen(),
  ];

  Widget _roleBased({
    required bool isCustomer,
    required bool isSupplier,
    required Widget customerPage,
    required Widget supplierPage,
  }) {
    if (isCustomer) return customerPage;
    if (isSupplier) return supplierPage;
    return const RouteNotFoundPage();
  }

  @override
  void onInit() async {
    super.onInit();

    _loadProfile();

    await _getCurrLocAndSave();

    _loadNearestSuppilers();
  }

  Future<void> _getCurrLocAndSave() async {
    try {
      await Get.find<StationLocationController>().getAndSaveInBackendCurrLoc();
    } catch (_) {}
  }

  Future<void> _loadNearestSuppilers() async {
    final slc = Get.find<StationLocationController>();

    try {
      await Get.find<HomeController>().getNearbySuppliersWithPriceStats(
        latitude: slc.latitude.value,
        longitude: slc.longitude.value,
      );
    } catch (_) {}
  }

  Future<void> _loadProfile() async {
    try {
      await Get.find<ProfileController>().fetchMyProfile();
    } catch (_) {}
  }

  // Icons & labels can stay getters (cheap)
  List<String> get icons => [
    IconsPath.home,
    IconsPath.chat,
    IconsPath.match,
    IconsPath.userGroup,
    IconsPath.experts,
  ];

  List<String> get labels => [
    Strings.home.capEachWord(),
    Strings.chat.capEachWord(),
    Strings.inventory.capEachWord(),
    Strings.profile.capEachWord(),
  ];

  /// 🔁 Change tab programmatically
  void goToTab(int index) {
    if (index < 0 || index >= pages.length) return;
    currentIndex.value = index;
  }

  /// 👆 Bottom nav tap
  void onTapIndex(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
  }

  /// 🔙 Back button logic (smooth & safe)
  Future<bool> willPopFunction() async {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
      return false;
    }

    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      // showToast("Press again to exit");
      return false;
    }

    return true; // let system handle exit
  }
}
