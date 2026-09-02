import 'package:we_mama/core/components/ui/inputs/cus_search_bar.dart';
import 'package:we_mama/features/main_tabs/experts/widgets/session_component.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/past_sessions_controller.dart';

class PastSessionsScreen extends StatelessWidget {
  const PastSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final psc = Get.find<PastSessionsController>();

    return AppScreenTemplate(
      isScrollable: false,
      appBar: CommonAppBarContent(title: Strings.pastSessions),
      child: Column(
        children: [
          CusSearchBar(
            controller: psc.searchCtrl,
            focusNode: psc.searchFocusNode,
            onClear: psc.clearSearch,
            onEditingComplete: () {
              // covers the "hit search on keyboard" case too — cancels
              // any pending debounce and searches immediately
              psc.getPastSessions(search: psc.searchCtrl.text.trim());
            },
          ),

          Gap(itemGap),

          Expanded(
            child: Obx(() {
              if (psc.isLoading.value && psc.sessions.isEmpty) {
                return const Center(child: LoadingPrimary());
              }

              if (psc.sessions.isEmpty) {
                return const Center(child: Text("No sessions found"));
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

                  final itemWidth =
                      (constraints.maxWidth -
                          ((crossAxisCount - 1) * itemGap)) /
                      crossAxisCount;

                  final desiredHeight = 220.0.h;
                  final childAspectRatio = itemWidth / desiredHeight;

                  return GridView.builder(
                    controller: psc.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 24.h),
                    // +1 slot for a trailing loader/footer row
                    itemCount:
                        psc.sessions.length +
                        (psc.hasMore ? crossAxisCount : 0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: itemGap,
                      mainAxisSpacing: itemGap,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (_, index) {
                      if (index >= psc.sessions.length) {
                        // trailing cell(s) reserved for the loader —
                        // only render something in the first one
                        if (index == psc.sessions.length &&
                            psc.isLoadMore.value) {
                          return const Center(child: LoadingPrimary());
                        }
                        return const SizedBox.shrink();
                      }
                      return SessionComponent(session: psc.sessions[index]);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ).getcm,
    );
  }
}
