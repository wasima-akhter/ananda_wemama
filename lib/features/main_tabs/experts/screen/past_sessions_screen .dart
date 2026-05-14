import 'package:mama_app/core/components/ui/inputs/cus_search_bar.dart';
import 'package:mama_app/features/main_tabs/experts/widgets/session_component.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/past_sessions_controller.dart';

class PastSessionsScreen extends StatelessWidget {
  const PastSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final psc = Get.find<PastSessionsController>();
    final matchRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.pastSessions),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: itemGap,
        children: [
          CusSearchBar(controller: psc.searchCtrl, focusNode: psc.searchFocusNode),

          Gap(itemGap),
          Wrap(
            spacing: itemGap,
            runSpacing: itemGap * 2,
            children: List.generate(3, (index) {
              return SessionComponent();
            }),
          ),
        ],
      ).getcm,
    );
  }
}
