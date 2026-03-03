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
      },
      appBar: CommonAppBarContent(title: Strings.newWaves),
      child: Column(
        children: [
          ...wrc.fakeNewWavesList.map((e) {
            return NewWavesListItem(chatModel: e, wrc: wrc);
          }),
        ],
      ).getcm,
    );
  }
}
