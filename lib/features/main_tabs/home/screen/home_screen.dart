import 'package:mama_app/core/common_widgets/common_components/community_spotlight.dart';
import 'package:mama_app/core/common_widgets/home_app_bar_content.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/mood_check_in/mood_chip_card.dart';
import '../../../../core/components/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();
    final homeRefreshKey = GlobalKey<RefreshIndicatorState>();

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

class GentleReminderCard extends StatelessWidget {
  const GentleReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardReminder,
      rad: 20,
      hp: 16,
      vp: 12,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.todaysReminder.capEachWord(), style: TxtStyle.outfitSmTitle),
          Gap(4),
          Text(Strings.restCounts.capEachWord(), style: TxtStyle.outfitSmSecNor),
        ],
      ),
    );
  }
}
