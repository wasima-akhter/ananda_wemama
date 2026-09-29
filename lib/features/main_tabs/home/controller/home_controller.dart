import '../../../../app/controller_export.dart';
import '../../../../core/services/push_notification/utils/notification_permission_dialog.dart';
import '../../../shared/mood/mood_check_in/mood_check_in_controller.dart';
import '../../experts/controller/session_action_controller.dart';
import '../../experts/controller/session_controller.dart';
import '../model/community_spotlight_model.dart';
import '../service/home_service.dart';

class HomeController extends GetxController {
  final mcc = findCont<MoodCheckInController>();
  static HomeController get to => findCont<HomeController>();

  @override
  void onInit() {
    print(' token :$getToken ');

    getCommunitySpotLight();
    getGentleRemindData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _maybeAskNotificationPermission();
  }

  Future<void> _maybeAskNotificationPermission() async {
    // Small delay so the screen finishes painting before a dialog appears
    await Future.delayed(const Duration(seconds: 2));
    await NotificationPermissionHelper.askWithRationale();
  }

  final sessionCtrl = Get.find<SessionController>();
  final actionCtrl = Get.find<SessionActionController>();

  final TextEditingController writeQuesCtrl = TextEditingController();
  final FocusNode writeQuesFocusNode = FocusNode();

  @override
  void dispose() {
    writeQuesCtrl.dispose();
    writeQuesFocusNode.dispose();
    super.dispose();
  }

  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
    writeQuesCtrl.clear();
    writeQuesFocusNode.unfocus();
  }

  void closeAllPopups() {}

  // Future<void> runLocationPermissionFlow() async {
  //   final result = await AppLocationManager.to.ensureFreshLocation();

  //   final active = result == LocationFlowResult.success;

  //   // HomeScreen.showLocationStatusOverlay(isActive: active);
  //   checkLocationPopup(isActive: active);
  // }

  // void checkLocationPopup({required bool isActive}) {
  //   if (!storage.hasLoggedInBefore) {
  //     storage.setHasLoggedInBefore();
  //     return;
  //   }

  //   HomeScreen.showLocationStatusOverlay(isActive: isActive);
  // }
  // ─────────────────────────────────────────────────────────────────────────
  // 🔹 Nearby suppliers
  // ─────────────────────────────────────────────────────────────────────────

  var isSpotLightLoading_ = false.obs;
  bool get isSpotLightLoading => isSpotLightLoading_.value;

  // ✅ Correct way to declare nullable Rx
  final spotLightData = Rxn<CommunitySpotlightModel>();

  Future<void> getCommunitySpotLight() async {
    if (isSpotLightLoading_.value) return;
    isSpotLightLoading_.value = true;
    try {
      final data = await HomeService().fetchCommunitySpotLight();

      if (data != null) {
        spotLightData.value = data;
        print(
          ' spotlightData : ${spotLightData.value?.communitySpotlight?.name}',
        );
      }
    } catch (e) {
      print("Error fetch Community SpotLight : $e");
    } finally {
      isSpotLightLoading_.value = false;
    }
  }

  //---------------------------
  //---------------------------
  var isGentleRemindLoading_ = false.obs;
  bool get isGentleRemindLoading => isGentleRemindLoading_.value;

  // ✅ Correct way to declare nullable Rx
  final gentleRemindData = Rxn<GentleRemindData>();

  Future<void> getGentleRemindData() async {
    if (isGentleRemindLoading_.value) return;
    isGentleRemindLoading_.value = true;
    try {
      final data = await HomeService().fetchGentleRemindData();

      if (data != null) {
        gentleRemindData.value = data;
        print(' GentleRemindData : ${gentleRemindData.value?.message}');
      }
    } catch (e) {
      print("Error fetch Gentle Reminder Data : $e");
    } finally {
      isGentleRemindLoading_.value = false;
    }
  }
}

/*
First visit to HomeScreen
│
├─ Service ON + Permission granted
│     → _refreshLocationData()
│     → showOverlay(isActive: true)  ✅  ← this line was missing before
│
├─ Service OFF
│     → _showTurnOnServiceDialog()
│           "Not now"  → showOverlay(isActive: false)
│           "Turn On"  → openLocationSettings() → re-check
│                           still OFF → showOverlay(isActive: false)
│                           now ON    → fall through ↓
│
├─ Permission deniedForever
│     → _showPermanentlyDeniedDialog()
│     → showOverlay(isActive: false)
│
├─ Permission denied (requestable)
│     → _showRationaleDialog()
│           "Not now" → showOverlay(isActive: false)
│           "Allow"   → Geolocator.requestPermission()
│                           denied → showOverlay(isActive: false)
│                           granted → _refreshLocationData()
│                                   → showOverlay(isActive: true)  ✅

 */
