import 'package:we_mama/features/main_tabs/experts/controller/session_controller.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../controller/experts_controller.dart';

class OngoingSessionsScreen extends StatelessWidget {
  const OngoingSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exc = Get.find<ExpertsController>();
    final sc = Get.find<SessionController>();

    return AppScreenTemplate(
      isScrollable: false,
      appBar: CommonAppBarContent(
        title: Strings.ongoingSession,
        onTapBack: () => goToMainNavWithTab(4),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔍 SEARCH BAR
          CusSearchBar(
            fillColor: ctransp,
            rad: 12,
            controller: exc.searchOngoingCtrl,
            focusNode: exc.searchOngoingFocusNode,
            onEditingComplete: () => exc.onSubmitOngoingSearch(),
          ),

          Gap(itemGap * 0.5),

          /// 🏷️ SEARCH TAG
          Obx(() {
            if (!exc.showOngoingTag.value) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: itemGap * 0.5),
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
                          exc.searchedOngoingTxt.value,
                          style: TxtStyle.urbanistSemiB(
                            fs: 14,
                            w: 600,
                            color: c.primary,
                          ),
                        ),
                        Gap(8),
                        CusGestureDetector(
                          onTap: exc.clearOngoingSearch,
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

          /// 🔥 LIST SECTION
          Expanded(
            child: Obx(() {
              final list = sc.ongoingList;
              final isLoading = sc.isOngoingLoading.value;
              final state = getUIStateList(isLoading: isLoading, list: list);
              final isPaginating = sc.isOngoingPaginating.value;
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
                    exc.clearOngoingSearch();
                    await sc.getOngoingSessions();
                  },
                  child: EmptyWidgetScrollable(title: "No ongoing sessions"),
                ),

                /// 🟢 DATA
                data: () => RefreshIndicator(
                  onRefresh: () async {
                    exc.clearOngoingSearch();
                    await sc.getOngoingSessions();
                  },
                  child: ListView.separated(
                    controller: sc.ongoingScrollController,
                    physics:
                        const AlwaysScrollableScrollPhysics(), // ← refresh works even on short lists
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: list.length + 1, // ← +1 for pagination loader
                    separatorBuilder: (_, _) => Gap(itemGap),
                    itemBuilder: (_, index) {
                      /// 🔥 pagination loader
                      if (index == list.length) {
                        return isPaginating
                            ? const LoadingPrimary()
                            : const SizedBox.shrink();
                      }

                      return LiveOngoingSessionCard(
                        data: list[index],
                        isFromOngoingScreen: true,
                      );
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
