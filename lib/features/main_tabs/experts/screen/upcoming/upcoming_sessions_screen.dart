import 'package:we_mama/features/main_tabs/experts/controller/experts_controller.dart';
import 'package:we_mama/features/main_tabs/experts/controller/session_action_controller.dart';
import 'package:we_mama/features/main_tabs/experts/controller/session_controller.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../../shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';

class UpcomingSessionsScreen extends StatelessWidget {
  const UpcomingSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exc = Get.find<ExpertsController>();
    final sc = Get.find<SessionController>();
    final act = Get.find<SessionActionController>();

    return AppScreenTemplate(
      isScrollable: false,
      appBar: CommonAppBarContent(
        title: Strings.upcomingSession,
        onTapBack: () => goToMainNavWithTab(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔍 SEARCH BAR
          CusSearchBar(
            fillColor: ctransp,
            rad: 12,
            controller: exc.searchUpcomingCtrl,
            focusNode: exc.searchUpcomingFocusNode,
            onEditingComplete: () => exc.onSubmitUpcomingSearch(),
          ),

          Gap(itemGap),

          /// 🏷️ SEARCH TAG (shown after search submitted)
          Obx(() {
            if (!exc.showUpcomingTag.value) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: itemGap),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ContainerBordered(
                    vp: 6,
                    hp: 12,
                    rad: 30,
                    contClr: c.secondary.withOpacity(0.3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFit(
                          exc.searchedUpcomingTxt.value,
                          style: TxtStyle.urbanistSemiB(
                            fs: 14,
                            w: 600,
                            color: c.primary,
                          ),
                        ),
                        Gap(8),
                        CusGestureDetector(
                          onTap: exc.clearUpcomingSearch,
                          child: SvgIconColored(
                            iconPath: IconsPath.closeCircle,
                            iconColor: c.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          /// 🟢 SESSION LIST
          Expanded(
            child: Obx(() {
              final list = sc.upcomingList;
              final isLoading = sc.isUpcomingLoading.value;
              final state = getUIStateList(isLoading: isLoading, list: list);

              return UIStateHandler(
                state: state,

                /// 🔵 LOADING
                loading: () => ListView.separated(
                  separatorBuilder: (context, index) => Gap(itemGap),
                  itemCount: 6,
                  itemBuilder: (_, _) => const LiveOngoingSessionCardShimmer(),
                ),

                /// 🟡 EMPTY
                empty: () => CusRefreshIndicator(
                  onRefresh: () async {
                    exc.searchUpcomingCtrl.text = '';
                    exc.clearUpcomingSearch();
                    await sc.getUpcomingSessions();
                  },
                  child: EmptyWidgetScrollable(title: "No Upcoming sessions"),
                ),

                /// 🟢 DATA
                data: () => CusRefreshIndicator(
                  onRefresh: () async {
                    exc.searchUpcomingCtrl.text = '';
                    await sc.getUpcomingSessions();
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(list.length, (index) {
                        final item = list[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: itemGap),
                          child: UpcomingExpertSessionCard(
                            isRemindMeLoading: () =>
                                act.isReminderLoading(item.id),
                            isReminderActive: () => act.isReminderSet(item.id),
                            onTapRemindMe: () {
                              act.toggleReminder(sessionId: item.id);
                            },
                            isFromUpcomgScreen: true,
                            data: item,
                            onTapQues:
                                ({required expertId, required sessionId}) =>
                                    act.uploadSessionQues(
                                      expertId: expertId,
                                      sessionId: sessionId,
                                      question: exc.writeQuesCtrl.text.trim(),
                                    ),
                            writeQuesCtrl: exc.writeQuesCtrl,
                            writeQuesFocusNode: exc.writeQuesFocusNode,
                            isSendQuesLoading: act.isSendQuesLoading,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ).getcm,
    );
  }
}
