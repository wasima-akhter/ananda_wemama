import 'package:we_mama/features/main_tabs/experts/controller/session_action_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';
import '../controller/experts_controller.dart';
import '../controller/session_controller.dart';
import '../model/expert_session_list_model.dart';
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
        exc.getPastSessions();
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: itemGap,
        children: [
          // if (kDebugMode) ...[
          //   Obx(() {
          //     final ongoingList = exc.limitList(sc.ongoingList.value);

          //     if (ongoingList.isEmpty) {
          //       return const Text("no live session for now");
          //     }

          //     final isOverflowing = ongoingList.any(
          //       (element) => willTextOverflow(
          //         text: element.description,
          //         style: TxtStyle.outfit(fs: 14, color: c.strokePrimary),
          //       ),
          //     );
          //     return CardHorizontalList(
          //       aspectRatio: 1.8,
          //       height:
          //           Responsive.ongoingSessionCardHeight +
          //           (isOverflowing ? 40.h : 30.h),
          //       title: Strings.ongoingExpertSession,
          //       exc: exc,
          //       onViewAll: () => exc.onTapViewAll(true),
          //       itemCount: ongoingList.length,
          //       itemBuilder: (index) =>
          //           LiveOngoingSessionCard(data: ongoingList[index]),
          //     );
          //   }),
          //   Gap(20.h),
          //   PaidPastSessionsComponent(),
          // ],

          /// 🔴 ONGOING + 🟡 UPCOMING (combined reactive block)
          Obx(() {
            final isOngoingLoading = sc.isOngoingLoading.value;
            final isUpcomingLoading = sc.isUpcomingLoading.value;

            final ongoingList = exc.limitList(sc.ongoingList.value);
            //[fakeSession];
            final upcomingList = [...exc.limitList(sc.upcomingList.value)];

            final ongoingEmpty = !isOngoingLoading && ongoingList.isEmpty;
            final upcomingEmpty = !isUpcomingLoading && upcomingList.isEmpty;

            print(
              "ongoingEmpty && upcomingEmpty : $ongoingEmpty , $upcomingEmpty",
            );

            print(
              "ongoingEmpty ongoingList && upcomingEmpty upcomingList : ${ongoingList.length} , ${upcomingList.length}",
            );
            print(
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
            final isOverflowing = ongoingList.any(
              (element) => willTextOverflow(
                text: element.description,
                style: TxtStyle.outfit(fs: 14, color: c.strokePrimary),
              ),
            );
            // At least one has data — show only the non-empty sections
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: itemGap,
              children: [
                if (!ongoingEmpty)
                  CardHorizontalList(
                    aspectRatio: 1.8,
                    height:
                        Responsive.ongoingSessionCardHeight +
                        (isOverflowing ? 40.h : 30.h),
                    title: Strings.ongoingExpertSession,
                    exc: exc,
                    onViewAll: () => exc.onTapViewAll(true),
                    itemCount: ongoingList.length,
                    itemBuilder: (index) =>
                        LiveOngoingSessionCard(data: ongoingList[index]),
                  ),

                // PremiumGate(
                //   waitForReady: false,
                //   child: CardHorizontalList(
                //     aspectRatio: 1.8,
                //     height:
                //         Responsive.ongoingSessionCardHeight +
                //         (isOverflowing ? 40.h : 30.h),
                //     title: Strings.ongoingExpertSession,
                //     exc: exc,
                //     onViewAll: () => exc.onTapViewAll(true),
                //     itemCount: ongoingList.length,
                //     itemBuilder: (index) =>
                //         LiveOngoingSessionCard(data: ongoingList[index]),
                //   ),
                //   lockedBuilder: (_) => LiveSessionLockedCard(
                //     onTap: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
                //   ),
                // ),
                if (!upcomingEmpty)
                  CardHorizontalList(
                    aspectRatio: 1.45,
                    height: Responsive.ongoingSessionCardHeight + 60,
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
          PaidPastSessionsComponent(),

          // PremiumGate(
          //   waitForReady: false,
          //   child: PaidPastSessionsComponent(),
          //   lockedBuilder: (_) => PastSessionsLibraryCard(
          //     onTapSubscribe: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
          //   ),
          // ),
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
          fs: 15,
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
            "Your next session is coming soon 🤎",
            style: TxtStyle.outfitSemiB(
              fs: 15,
              w: 600,
              color: c.foregroundPrimary,
            ),
          ),
          Gap(6),
          Text(
            "There aren't any sessions available right now.\n"
            "We'll let you know when a new one is ready for you.",
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

//

final fakeSession = Session(
  id: "session_001",
  expert: Expert(
    // add your Expert fields here
    name: "asudas dhasd ahsdiuashdhas",
  ),
  status: "completed",
  title: "Career Guidance Session",
  description: "A one-on-one consultation session with an expert advisor.",
  time: "10:30 AM",
  date: DateTime.now().add(const Duration(days: 2)),
  channelName: "session_channel_001",

  doctorUid: "doctor_123",
  recordingUid: "recording_123",

  resourceId: "resource_001",
  sid: "sid_12345",

  recordingMp4Url: "https://example.com/recordings/session_001.mp4",
  recordingHlsUrl: "https://example.com/recordings/session_001.m3u8",

  duration: 3600,
  startedAt: DateTime.now().subtract(const Duration(hours: 1)),
  finishedAt: DateTime.now(),

  isApproved: true,

  recordingFiles: [
    RecordingFile(
      // add your RecordingFile fields here
    ),
  ],

  createdAt: DateTime.now().subtract(const Duration(days: 5)),
  updatedAt: DateTime.now(),

  deepLinkUrl: "wemama://session/session_001",

  v: 0,
  reminderEnabled: true,
);
