import 'package:we_mama/core/components/ui/loaders/empty_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/scroll/custom_scroll_view_widget.dart';
import '../../../../gen/assets.gen.dart';
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

      appBar: CommonAppBarContent(title: Strings.newWaves),
      isScrollable: false,

      child: Obx(() {
        if (wrc.isLoading_.value) {
          return const Center(child: LoadingPrimary()).getcm;
        }

        final list = wrc.newWaveList;

        if (list.isEmpty) {
          return CusRefreshIndicator(
            onRefresh: () async {
              print("wave request refreshed");
              await wrc.getNewWavesList();
            },
            child: EmptyNoSearchWidgetScrollable(
              title: "No waves request yet",
              assetPath: Assets.images.noWaveIcon.path,
              subTitle:
                  "Your new wave requests will appear here.\n"
                  "Connect with more mums to start\n"
                  "receiving waves.",
            ).getcm,
          );
        }

        return CusRefreshIndicator(
          onRefresh: () async {
            print("wave request refreshed");
            await wrc.getNewWavesList();
          },
          child: CustomScrollViewWidget(
            controller: ScrollController(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(bottom: itemGap * 2),
                sliver: SliverList.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final item = list[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == list.length - 1 ? 0 : itemGap * 0.6,
                      ),
                      child: NewWavesListItem(model: item, wrc: wrc).getcm,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
