import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../../../shared/mood/mood_library/widgets/mood_library_chip_card.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../shared/mood/ongoing_sessions/past_sessions_library_card.dart';
import '../../../shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';
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
          CusSearchBar(controller: ec.searchCtrl, focusNode: ec.searchFocusNode),

          Gap(itemGap),
          ...List.generate(3, (index) {
            return LiveOngoingSessionCard().mB(4);
          }),

          Gap(itemGap),
          ...List.generate(1, (index) {
            return UpcomingExpertSessionCard(
              writeQuesCtrl: ec.writeQuesCtrl,
              writeQuesFocusNode: ec.writeQuesFocusNode,
              onTapQues: ec.onTapQues,
            ).mB(4);
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
