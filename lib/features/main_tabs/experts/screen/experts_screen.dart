import 'package:mama_app/core/common_widgets/cus_search_bar.dart';
import 'package:mama_app/core/components/ongoing_sessions/ongoing_expert_session_card.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/experts_controller.dart';

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<ExpertsController>();
    final matchRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.experts, hasBackNavArrow: false),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CusSearchBar(controller: TextEditingController()),

          Gap(itemGap),
          ...List.generate(3, (index) {
            return OngoingSessionCard().mB(4);
          }),

          // show past sessions
          // show mood chip librtary
        ],
      ).getcm,
    );
  }
}
