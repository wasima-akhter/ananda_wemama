import 'package:we_mama/features/main_tabs/experts/controller/session_action_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../shared/mood/ongoing_sessions/past_sessions_library_card.dart';
import '../../../shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';
import '../../../shared/subscription/subscription_access/premium_gate.dart';
import '../controller/experts_controller.dart';
import '../controller/session_controller.dart';
import '../widgets/card_session_list.dart';
import '../widgets/live_session_lock_card.dart';
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
        exc.getPastSessions();
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: itemGap,
        children: [
          /// 🔴 ONGOING + 🟡 UPCOMING (combined reactive block)
          Obx(() {
            final isOngoingLoading = sc.isOngoingLoading.value;
            final isUpcomingLoading = sc.isUpcomingLoading.value;

            final ongoingList = exc.limitList(sc.ongoingList.value);
            final upcomingList = exc.limitList(sc.upcomingList.value);

            final ongoingEmpty = !isOngoingLoading && ongoingList.isEmpty;
            final upcomingEmpty = !isUpcomingLoading && upcomingList.isEmpty;

            log(
              "ongoingEmpty && upcomingEmpty : $ongoingEmpty , $upcomingEmpty",
            );

            log(
              "ongoingEmpty ongoingList && upcomingEmpty upcomingList : ${ongoingList.length} , ${upcomingList.length}",
            );
            log(
              "ongoingEmpty ongoingList_api && upcomingEmpty upcomingList_api : ${sc.ongoingList.value.length} , ${sc.upcomingList.value.length}",
            );

            // Still loading at least one — show both shimmer placeholders
            if (isOngoingLoading || isUpcomingLoading) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: itemGap,
                children: [
                  if (isOngoingLoading)
                    CardHorizontalList(
                      height: Responsive.ongoingSessionCardHeight,
                      title: Strings.ongoingExpertSession,
                      exc: exc,
                      onViewAll: () {},
                      itemCount: 5,
                      itemBuilder: (_) => const LiveOngoingSessionCardShimmer(),
                    ),
                  if (isUpcomingLoading)
                    CardHorizontalList(
                      height: Responsive.upcomingSessionCardHeight,
                      title: Strings.upcomingExpertSession,
                      exc: exc,
                      onViewAll: () {},
                      itemCount: 5,
                      itemBuilder: (_) => const LiveOngoingSessionCardShimmer(),
                    ),
                ],
              );
            }

            // Both empty → single empty state card
            if (ongoingEmpty && upcomingEmpty) {
              return _NoSessionsCard();
            }

            // At least one has data — show only the non-empty sections
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: itemGap,
              children: [
                if (!ongoingEmpty)
                  PremiumGate(
                    waitForReady: false,
                    child: CardHorizontalList(
                      aspectRatio: 1.8,
                      height: Responsive.ongoingSessionCardHeight,
                      title: Strings.ongoingExpertSession,
                      exc: exc,
                      onViewAll: () => exc.onTapViewAll(true),
                      itemCount: ongoingList.length,
                      itemBuilder: (index) =>
                          LiveOngoingSessionCard(data: ongoingList[index]),
                    ),
                    lockedBuilder: (_) => LiveSessionLockedCard(
                      onTap: () => Get.toNamed(RoutePaths.promoCodeScreen),
                    ),
                  ),

                if (!upcomingEmpty)
                  CardHorizontalList(
                    aspectRatio: 1.45,
                    height: Responsive.ongoingSessionCardHeight,
                    title: Strings.upcomingExpertSession,
                    exc: exc,
                    onViewAll: () => exc.onTapViewAll(false),
                    itemCount: upcomingList.length,
                    itemBuilder: (index) {
                      final item = upcomingList[index];
                      return UpcomingExpertSessionCard(
                        isRemindMeLoading: () => act.isReminderLoading(item.id),
                        isReminderActive: () => act.isReminderSet(item.id),
                        onTapRemindMe: () {
                          act.toggleReminder(sessionId: item.id);
                        },
                        data: item,
                        onTapQues: ({required expertId, required sessionId}) =>
                            act.uploadSessionQues(
                              expertId: expertId,
                              sessionId: sessionId,
                              question: exc.writeQuesCtrl.text.trim(),
                            ),
                        writeQuesCtrl: exc.writeQuesCtrl,
                        writeQuesFocusNode: exc.writeQuesFocusNode,
                        isSendQuesLoading: act.isSendQuesLoading,
                      );
                    },
                  ),
              ],
            );
          }),

          PremiumGate(
            waitForReady: false,
            child: PaidPastSessionsComponent(),
            lockedBuilder: (_) => PastSessionsLibraryCard(
              onTapSubscribe: () => Get.toNamed(RoutePaths.promoCodeScreen),
            ),
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
        style: TxtStyle.outfitSemiB(
          fs: 13,
          w: 600,
          color: c.foregroundSecondary,
        ),
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

class _NoSessionsCard extends StatelessWidget {
  const _NoSessionsCard();

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 28,
      hp: 20,
      contClr: newCardClr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 40,
            color: c.foregroundSecondary,
          ),
          Gap(12),
          Text(
            "No Sessions Available",
            style: TxtStyle.outfitSemiB(
              fs: 15,
              w: 600,
              color: c.foregroundPrimary,
            ),
          ),
          Gap(6),
          Text(
            "You have no ongoing or upcoming sessions at the moment.",
            textAlign: TextAlign.center,
            style: TxtStyle.outfitSemiB(
              fs: 13,
              w: 400,
              color: c.foregroundSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
