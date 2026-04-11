import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../../core/components/ui/scroll/cus_scrollbar_widget.dart';
import '../../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../controller/experts_controller.dart';

class OngoingSessionsScreen extends StatelessWidget {
  const OngoingSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exc = Get.find<ExpertsController>();

    return AppScreenTemplate(
      isScrollable: false,
      appBar: CommonAppBarContent(title: Strings.ongoingSession),
      onRefresh: () async {
        await exc.getOngoingSessions();
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔍 SEARCH
          CusSearchBar(
            fillColor: ctransp,
            rad: 12,
            controller: exc.searchOngoingCtrl,
            focusNode: exc.searchOngoingFocusNode,
          ),

          Gap(itemGap * 0.5),

          /// 🔥 LIST SECTION
          Expanded(
            child: Obx(() {
              final list = exc.ongoingList;
              final isLoading = exc.isOngoingLoading.value;

              final state = getSessionState(isLoading: isLoading, list: list);

              return UIStateHandler(
                state: state,

                /// 🔵 LOADING
                loading: () => ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) => const LiveOngoingSessionCardShimmer(),
                ),

                /// 🟡 EMPTY
                empty: () => const Center(child: EmptySessionWidget(title: "No ongoing sessions")),

                /// 🟢 DATA
                data: () => CusScrollbarWidget(
                  controller: exc.ongoingScrollController,
                  child: ListView.separated(
                    controller: exc.ongoingScrollController,
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: list.length + 1, // 🔥 for loader at bottom
                    separatorBuilder: (_, __) => Gap(itemGap),

                    itemBuilder: (context, index) {
                      /// 🔥 pagination loader
                      if (index == list.length) {
                        return Obx(() {
                          return exc.isOngoingLoading.value
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              : const SizedBox.shrink();
                        });
                      }

                      final item = list[index];

                      return LiveOngoingSessionCard(data: item, isFromOngoingScreen: true);
                    },
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
