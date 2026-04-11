import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../shared/mood/mood_library/widgets/mood_library_chip_card.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../shared/mood/ongoing_sessions/past_sessions_library_card.dart';
import '../../../shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';
import '../controller/experts_controller.dart';
import '../widgets/card_session_list.dart';
import '../widgets/paid_past_sessions_component.dart';

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exc = Get.find<ExpertsController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.experts, hasBackNavArrow: false),
      onRefresh: () async {
        exc.getOngoingSessions();
        exc.getUpcomingSessions();
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: itemGap,
        children: [
          /// horizontal live session list
          Obx(() {
            final isLoading = exc.isOngoingLoading.value;
            final list = exc.ongoingList;

            final displayList = list.length > 5 ? list.sublist(0, 5) : list;

            final state = getSessionState(isLoading: isLoading, list: displayList);

            return UIStateHandler(
              state: state,

              /// 🔵 LOADING
              loading: () => CardHorizontalList(
                title: Strings.ongoingExpertSession,
                exc: exc,
                onViewAll: () {},
                itemCount: 5,
                itemBuilder: (index) => const LiveOngoingSessionCardShimmer(),
              ),

              /// 🟡 EMPTY
              empty: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  makeCardHeader(Strings.ongoingExpertSession, onTap: () {}),
                  Gap(itemGap),
                  const EmptySessionWidget(title: Strings.noSessionsFound),
                ],
              ),

              /// 🟢 DATA
              data: () => CardHorizontalList(
                title: Strings.ongoingExpertSession,
                exc: exc,
                onViewAll: () => exc.onTapViewAll(false),
                itemCount: displayList.length,
                itemBuilder: (index) {
                  final item = displayList[index];
                  return LiveOngoingSessionCard(data: item);
                },
              ),
            );
          }),

          Gap(itemGap * 0.5),

          /// horizontal upcoming session list
          ///
          Obx(() {
            final isLoading = exc.isUpcomingLoading.value;
            final list = exc.upcomingList;

            final displayList = list.length > 5 ? list.sublist(0, 5) : list;

            final uiState = getSessionState(isLoading: isLoading, list: displayList);

            return UIStateHandler(
              state: uiState,

              loading: () => CardHorizontalList(
                title: Strings.upcomingExpertSession,
                exc: exc,
                itemCount: 5,
                onViewAll: () {},
                itemBuilder: (_) => const LiveOngoingSessionCardShimmer(),
              ),

              empty: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  makeCardHeader(Strings.upcomingExpertSession, onTap: () {}),
                  Gap(itemGap),
                  const EmptySessionWidget(title: "No upcoming sessions"),
                ],
              ),

              data: () => CardHorizontalList(
                aspectRatio: 1.5,
                onViewAll: () => exc.onTapViewAll(false),
                title: Strings.upcomingExpertSession,
                exc: exc,
                itemCount: displayList.length,
                itemBuilder: (index) {
                  final item = displayList[index];

                  return UpcomingExpertSessionCard(
                    data: item,
                    writeQuesCtrl: exc.writeQuesCtrl,
                    writeQuesFocusNode: exc.writeQuesFocusNode,
                    onTapQues: exc.onTapQues,
                  );
                },
              ),
            );
          }),
          Gap(itemGap * 0.5),

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
            moodDataList: exc.moodDataList,

            onTapSubscribe: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
          ),
        ],
      ).getcm,
    );
  }
}

Widget makeCardHeader(String title, {required void Function() onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title.capEachWord(), style: TxtStyle.outfitSemiB(fs: 13, w: 600, color: c.primary)),
      GestureDetector(
        onTap: onTap,
        child: Text(
          Strings.viewAll.capEachWord(),
          style: TxtStyle.outfitSemiB(fs: 13, w: 600, color: c.secondary),
        ),
      ),
    ],
  );
}
