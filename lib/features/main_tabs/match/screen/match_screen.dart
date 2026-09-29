import 'package:flutter/foundation.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/network/helpers/location/location_status_overlay.dart';
import '../controller/match_controller.dart';
import '../widgets/match_states/match_found_state.dart';
import '../widgets/match_states/match_idle_state.dart';
import '../widgets/match_states/match_location_unavailable_state.dart';
import '../widgets/match_states/match_no_match_state.dart';
import '../widgets/match_states/match_searching_state.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  static void showLocationStatusOverlay({required bool isActive}) {
    print("📍 Match location overlay — active: $isActive");

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    Get.dialog(
      LocationStatusOverlay(isActive: isActive),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  static void triggerPermissionFlow() {
    print("🔑 triggerPermissionFlow called");
    // MatchController.to.runLocationPermissionFlow();
  }

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MatchController.to.runLocationPermissionFlow();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MatchController>();

    return AppScreenTemplate(
      onRefresh: () async {},

      appBar: CommonAppBarContent(title: Strings.match, hasBackNavArrow: false),
      child: Column(
        children: [
          if (kDebugMode) ...[
            // TextButton(
            //   onPressed: () => mc.matchState.value = MatchState.noMatch,
            //   child: Text("No match state"),
            // ),
          ],

          //
          Obx(() {
            return switch (mc.matchState.value) {
              MatchState.idle => MatchIdleState(mc: mc),
              MatchState.searching => MatchSearchingState(mc: mc),
              MatchState.found => MatchFoundState(mc: mc),
              MatchState.noMatch => MatchNoMatchState(mc: mc),
              MatchState.locationUnavailable => MatchLocationUnavailableState(
                mc: mc,
              ),
            };
          }).getcm,
        ],
      ),
    );
  }
}
