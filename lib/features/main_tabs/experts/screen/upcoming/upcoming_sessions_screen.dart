import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../../shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';
import '../../controller/experts_controller.dart';

class UpcomingSessionsScreen extends StatelessWidget {
  const UpcomingSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exc = Get.find<ExpertsController>();

    return AppScreenTemplate(
      isScrollable: false,
      appBar: CommonAppBarContent(title: Strings.upcomingSession),
      onRefresh: () async {
        await exc.getUpcomingSessions();
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔍 SEARCH
          CusSearchBar(
            fillColor: ctransp,
            rad: 12,
            controller: exc.searchUpcomingCtrl,
            focusNode: exc.searchUpcomingFocusNode,
          ),

          Gap(itemGap),

          Expanded(
            child: Obx(() {
              final realList = exc.upcomingList;
              final list = realList;
              // [...realList, ...realList, ...realList, ...realList];
              final isLoading = exc.isUpcomingLoading.value;

              // final validFetchNext =

              final state = getUIStateList(isLoading: isLoading, list: list);

              return UIStateHandler(
                state: state,

                /// 🔵 LOADING
                loading: () => PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  itemBuilder: (_, __) => const LiveOngoingSessionCardShimmer(),
                ),

                /// 🟡 EMPTY
                empty: () => Center(child: EmptySessionWidget(title: "No Upcoming sessions")),

                /// 🟢 DATA
                data: () => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(list.length, (index) {
                      final item = list[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: itemGap),
                        child: UpcomingExpertSessionCard(
                          isFromUpcomgScreen: true,
                          isSendQuesLoading: exc.isuploadQuesLoading,
                          data: item,
                          writeQuesCtrl: exc.writeQuesCtrl,
                          writeQuesFocusNode: exc.writeQuesFocusNode,
                          onTapQues: exc.onTapQues,
                        ),
                      );
                    }),
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
