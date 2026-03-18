import 'package:mama_app/core/common_widgets/common_components/community_spotlight.dart';
import 'package:mama_app/core/common_widgets/home_app_bar_content.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/mood_check_in/mood_chip_card.dart';
import '../../../../core/components/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../../core/network/helpers/location/location_status_overlay.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../controller/home_controller.dart';
import '../modules/gentle_reminder_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static void showLocationStatusOverlay({required bool isActive}) {
    debugPrint("🪟 showLocationStatusOverlay called — isActive: $isActive");
    debugPrint("🪟 Get.context: ${Get.context}");
    debugPrint("🪟 isDialogOpen: ${Get.isDialogOpen}");

    if (Get.isDialogOpen ?? false) Get.back();

    Get.dialog(
      LocationStatusOverlay(isActive: isActive),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  static void triggerPermissionFlow() {
    debugPrint("🔑 triggerPermissionFlow called");
    Get.find<HomeController>().runLocationPermissionFlow();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("🏠 HomeScreen initState");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("🏠 HomeScreen postFrameCallback — notifying MainNavController");
      MainNavController.to.notifyHomeFirstBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();

    return AppScreenTemplate(
      appBar: HomeAppBarContent(),
      child: Column(
        spacing: itemGap * 1.2,
        children: [
          MoodCheckInCard(mcc: hc.mcc),
          GentleReminderCard(),
          CommunitySpotlight(),
          LiveOngoingSessionCard(),
        ],
      ).getcm,
    );
  }
}
