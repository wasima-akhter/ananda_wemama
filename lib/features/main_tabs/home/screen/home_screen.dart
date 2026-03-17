import 'package:mama_app/core/common_widgets/common_components/community_spotlight.dart';
import 'package:mama_app/core/common_widgets/home_app_bar_content.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/mood_check_in/mood_chip_card.dart';
import '../../../../core/components/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../controller/home_controller.dart';
import '../modules/gentle_reminder_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

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
