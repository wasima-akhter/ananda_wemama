import 'package:mama_app/core/components/ui/layout/home_app_bar_content.dart';
import 'package:mama_app/features/shared/community_spotlight/community_spotlight.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/network/helpers/location/location_status_overlay.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../../../shared/mood/mood_check_in/mood_chip_card.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../controller/home_controller.dart';
import '../modules/gentle_reminder_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static void showLocationStatusOverlay({required bool isActive}) {
    log("🪟 showLocationStatusOverlay called — isActive: $isActive");
    log("🪟 Get.context: ${Get.context}");
    log("🪟 isDialogOpen: ${Get.isDialogOpen}");

    if (Get.isDialogOpen ?? false) Get.back();

    Get.dialog(
      LocationStatusOverlay(isActive: isActive),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  static void triggerPermissionFlow() {
    log("🔑 triggerPermissionFlow called");
    Get.find<HomeController>().runLocationPermissionFlow();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    log("🏠 HomeScreen initState");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("🏠 HomeScreen postFrameCallback — notifying MainNavController");
      MainNavController.to.notifyHomeFirstBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();

    return AppScreenTemplate(
      onRefresh: () async {
        await hc.getCommunitySpotLight();
      },
      appBar: HomeAppBarContent(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: itemGap * 1.2,
        children: [
          MoodCheckInCard(mcc: hc.mcc),
          GentleReminderCard(),
          CommunitySpotlight(),
          // if none, show: no live session available right now
          Obx(() {
            final liveSessionData = hc.spotLightData.value?.liveSession;

            final isLoading = hc.isSpotLightLoading_.value;
            final state = getUIStateDetail(isLoading: isLoading);

            return SizedBox(
              height: S.h * 0.25,
              child: UIStateHandler(
                loading: () =>
                    const LiveOngoingSessionCardShimmer(), // change to li
                state: state,
                data: () => Container(
                  child: LiveOngoingSessionCard(data: liveSessionData),
                ),
              ),
            );
          }),
        ],
      ).getcm,
    );
  }
}
