import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/wave_request_controller.dart';
import '../widgets/new_waves_list_item.dart';

class WaveRequestScreen extends StatelessWidget {
  const WaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wrc = Get.find<WaveRequestController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: chatRefreshKey,
      onRefresh: () async {
        print("chat refreshed");
        // get the wave request list again
        wrc.getNewWavesList();
      },
      appBar: CommonAppBarContent(title: Strings.newWaves),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (wrc.isLoading_.value) {
              return LoadingPrimary();
            }
            final list_ = wrc.newWaveList;
            // final list = [...list_, ...list_, ...list_];
            final list = [...list_];

            if (list.isEmpty) {
              return const EmptyWidget(title: "No waves yet..!");
            }

            return Column(
              children: list.map((e) {
                return NewWavesListItem(model: e, wrc: wrc);
              }).toList(),
            );
          }),
        ],
      ).getcm,
    );
  }
}
