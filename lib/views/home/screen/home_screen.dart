import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/compare_component.dart';
import '../../../core/common_widgets/cus_search_bar.dart';
import '../../../core/common_widgets/main_nav_app_bar_content.dart';
import '../../../core/network/helpers/network_helpers.dart';
import '../../main_nav/controller/main_nav_controller.dart';
import '../controller/home_controller.dart';
import '../widgets/home_supplier_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final hc = Get.find<HomeController>();
    final homeRefreshKey = GlobalKey<RefreshIndicatorState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return CusRefreshIndicator(
          refreshKey: homeRefreshKey,
          onRefresh: () async {
            final mnc = Get.find<MainNavController>();
            mnc.onInit();
          },
          child: Obx(() {
            final isLoading = hc.isNearbySupplierLoading;

            final showLoading = isLoading || hc.nearbySuppliersPriceData.value == null;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // 🔑 REQUIRED
              child: Column(
                children: [
                  Gap(itemGap * 5),
                  MainNavProfileCard(
                    username: hc.userInfo.name,
                    userImageUrl: makeImageUrl(imageUrl: storage.getUserImageUrl),
                  ),
                  Gap(itemGap * 1),

                  CusSearchBar(onTap: () => GNav.pushNamed(RoutePaths.googleMap)),
                  Gap(itemGap * 2),

                  //    Gap(itemGap * 0.6),
                  // Text(location.cap, style: TxtStyle.inter(fs: 11, color: grey200, w: 600)),

                  //
                  showLoading
                      ? Loading()
                      : Column(
                          children: [
                            FuelDieselCompareComp(
                              isLeftSelected: hc.isLeftSelected,
                              changeToOtherTab: hc.changeToOtherTab,
                              lowestData: hc.isLeftSelected.value
                                  ? hc.statsLowestFuel
                                  : hc.statsLowestDiesel,
                              highestData: hc.isLeftSelected.value
                                  ? hc.statsHighestFuel
                                  : hc.statsHighestDiesel,
                            ),

                            Gap(itemGap * 2),

                            // list of items component
                            HomeSupplierList(
                              selFuelType: hc.selectedFuelType,
                              onChanged: (criteria) =>
                                  (String selected) => hc.onTapSortOfCriteria(selected),
                              hasShadow: true,
                              leftTitle: Strings.suppliers,

                              onTapSupplierItem: (supplierId) {},
                              showSortOfStackList: hc.showSortOfStack.value,

                              onTapRightTitle: hc.toggleSortOfStack,
                              onTapSortOfCriteria: (String selected) =>
                                  hc.onTapSortOfCriteria(selected),

                              selSortOfCriteria: hc.selSortCriteria,
                              list: hc.sortedSuppliers,
                            ),
                          ],
                        ),
                ],
              ).getcm,
            );
          }),
        );
      },
    );
  }
}
