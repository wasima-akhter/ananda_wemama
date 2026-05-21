import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';
import 'package:mama_app/features/main_tabs/experts/controller/session_action_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../shared/mood/mood_library/widgets/mood_library_chip_card.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../shared/mood/ongoing_sessions/past_sessions_library_card.dart';
import '../../../shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';
import '../controller/experts_controller.dart';
import '../controller/session_controller.dart';
import '../widgets/card_session_list.dart';
import '../widgets/paid_past_sessions_component.dart';

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exc = Get.find<ExpertsController>();
    final sc = Get.find<SessionController>();
    final act = Get.find<SessionActionController>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.experts,
        hasBackNavArrow: false,
      ),
      onRefresh: () async {
        sc.getOngoingSessions();
        sc.getUpcomingSessions();
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: itemGap,
        children: [
          /// 🔴 ONGOING sessions
          Obx(() {
            final isLoading = sc.isOngoingLoading.value;
            final displayList = exc.limitList(sc.ongoingList);
            final state = getUIStateList(
              isLoading: isLoading,
              list: displayList,
            );

            return UIStateHandler(
              state: state,

              loading: () => CardHorizontalList(
                height: Responsive.ongoingSessionCardHeight,
                title: Strings.ongoingExpertSession,
                exc: exc,
                onViewAll: () {},
                itemCount: 5,
                itemBuilder: (_) => const LiveOngoingSessionCardShimmer(),
              ),

              empty: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  makeCardHeader(Strings.ongoingExpertSession, onTap: () {}),
                  Gap(itemGap),
                  const EmptyNoSearchWidget(title: Strings.noSessionsFound),
                ],
              ),

              data: () => CardHorizontalList(
                aspectRatio: 1.8,
                height: Responsive.ongoingSessionCardHeight,
                title: Strings.ongoingExpertSession,
                exc: exc,
                onViewAll: () => exc.onTapViewAll(true),
                itemCount: displayList.length,
                itemBuilder: (index) =>
                    LiveOngoingSessionCard(data: displayList[index]),
              ),
            );
          }),

          Gap(itemGap * 0.5),

          /// 🟡 UPCOMING sessions
          Obx(() {
            final isLoading = sc.isUpcomingLoading.value;
            final displayList = exc.limitList(sc.upcomingList);
            final state = getUIStateList(
              isLoading: isLoading,
              list: displayList,
            );

            return UIStateHandler(
              state: state,

              loading: () => CardHorizontalList(
                height: Responsive.upcomingSessionCardHeight,
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
                  const EmptyNoSearchWidget(title: "No upcoming sessions"),
                ],
              ),

              data: () => CardHorizontalList(
                aspectRatio: 1.45,

                height: Responsive.upcomingSessionCardHeight,
                title: Strings.upcomingExpertSession,
                exc: exc,
                onViewAll: () => exc.onTapViewAll(false),
                itemCount: displayList.length,
                itemBuilder: (index) {
                  final item = displayList[index];
                  return UpcomingExpertSessionCard(
                    data: item,
                    onTapQues: ({required expertId, required sessionId}) =>
                        act.uploadSessionQues(
                          expertId: expertId,
                          sessionId: sessionId,
                        ),
                    writeQuesCtrl: act.writeQuesCtrl,
                    writeQuesFocusNode: act.writeQuesFocusNode,
                    isSendQuesLoading: act.isSendQuesLoading,
                  );
                },
              ),
            );
          }),

          Gap(itemGap * 0.5),

          PastSessionsLibraryCard(
            onTapSubscribe: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
          ),

          Text(
            " This component is for you to see the pov of paid user:"
                .capEachWord(),
            style: TxtStyle.outfitSmTitle,
          ),

          PaidPastSessionsComponent(),

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
      Text(
        title.capEachWord(),
        style: TxtStyle.outfitSemiB(fs: 13, w: 600, color: c.primary),
      ),
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
