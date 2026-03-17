import '../../../../app/helper_widgets_export.dart';
import '../controller/match_controller.dart';
import '../widgets/match_states/match_found_state.dart';
import '../widgets/match_states/match_idle_state.dart';
import '../widgets/match_states/match_no_match_state.dart';
import '../widgets/match_states/match_searching_state.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MatchController>();

    return AppScreenTemplate(
      onRefresh: () async {},
      appBar: CommonAppBarContent(title: Strings.match, hasBackNavArrow: false),
      child: Obx(() {
        return switch (mc.matchState.value) {
          MatchState.idle => MatchIdleState(mc: mc),
          MatchState.searching => MatchSearchingState(mc: mc),
          MatchState.found => MatchFoundState(mc: mc),
          MatchState.noMatch => MatchNoMatchState(mc: mc),
        };
      }).getcm,
    );
  }
}
