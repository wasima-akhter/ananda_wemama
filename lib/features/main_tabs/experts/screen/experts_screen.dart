import 'package:mama_app/core/common_widgets/cus_search_bar.dart';
import 'package:mama_app/core/components/ongoing_sessions/ongoing_expert_session_card.dart';
import 'package:mama_app/core/components/ongoing_sessions/past_sessions_library_card.dart';
import 'package:mama_app/features/shared/mood/mood_library/widgets/mood_library_chip_card.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/experts_controller.dart';
import '../widgets/paid_past_sessions_component.dart';

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ec = Get.find<ExpertsController>();
    final matchRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.experts, hasBackNavArrow: false),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: itemGap,
        children: [
          CusSearchBar(controller: TextEditingController()),

          Gap(itemGap),
          ...List.generate(3, (index) {
            return OngoingSessionCard().mB(4);
          }),

          // show past sessions
          PastSessionsLibraryCard(
            onTapSubscribe: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
          ),

          Text(
            " This component is for you to see the pov of paid user:".capEachWord(),
            style: TxtStyle.outfitSmTitle,
          ),

          PaidPastSessionsComponent(),

          // show mood chip librtary
          MoodLibraryChipCard(
            moodDataList: ec.moodDataList,

            onTapSubscribe: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
          ),
        ],
      ).getcm,
    );
  }
}
