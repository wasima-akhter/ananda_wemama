import '../../../../app/controller_export.dart';
import '../../../../core/common_widgets/compare_component.dart';
import '../../../../core/local/app_storage.dart';
import '../model/nearby_suppliers_with_price_stats_model.dart';

class ChatController extends GetxController {
  var isLeftSelected = true.obs;
  var showSortOfStack = false.obs;

  void onTapSortOfCriteria(String criteria) {
    selSortCriteria.value = criteria; // update current selection
    showSortOfStack.value = false; // close popup

    // Your sorting logic here
    _sortList(criteria);
  }

  void _sortList(String criteria) {
    // Implement your sorting logic
    print("Sorting by criteria: $criteria");
    print("Sorting by fuelType: ${selectedFuelType.value}");
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// add reactive selCriteria
  var selSortCriteria = ("").obs; // default

  UserInfoModel get userInfo => storage.getUserInfo;

  void changeToOtherTab() {
    isLeftSelected.value = !isLeftSelected.value;
  }

  //
  void toggleSortOfStack() {
    showSortOfStack.value = true;
    print("clicked the sort of.....");

    // also, change the list to high to low
  }

  var selectedFuelType = FuelType.fuel.obs;

  /// Sorted list according to selected criteria
  List<NearestSupplierDataModel?> get sortedSuppliers {
    if (nearbySuppliersPriceData.value?.suppliers == null) return [];

    List<NearestSupplierDataModel?> sorted = [
      ...nearbySuppliersPriceData.value!.suppliers!,
      // ...[
      //   NearestSupplierDataModel(
      //     name: "sdbcisdbc",
      //     address: "sdncsndc",
      //     todayDieselRate: 500,
      //     todayFuelRate: 200,
      //   ),
      //   NearestSupplierDataModel(
      //     name: "sfdvsdfv",
      //     address: "rdvfrgvfd",
      //     todayDieselRate: 5000,
      //     todayFuelRate: 4000,
      //   ),
      //   NearestSupplierDataModel(
      //     name: "rtgbgfbfg",
      //     address: "fdbfgbfg",
      //     todayDieselRate: 123,
      //     todayFuelRate: 123,
      //   ),
      // ],
    ];

    final selSortCriteriaValue = selSortCriteria.value; // Fuel or Diesel

    final isFuel = selectedFuelType.value == FuelType.fuel;
    if (isFuel) {
      switch (selSortCriteriaValue) {
        case Strings.highToLow:
          sorted.sort((a, b) => (b?.todayFuelRate ?? 0).compareTo(a?.todayFuelRate ?? 0));
          break;
        case Strings.lowToHigh:
          sorted.sort((a, b) => (a?.todayFuelRate ?? 0).compareTo(b?.todayFuelRate ?? 0));
          break;
      }
    } else {
      switch (selSortCriteriaValue) {
        case Strings.highToLow:
          {
            sorted.sort((a, b) => (b?.todayDieselRate ?? 0).compareTo(a?.todayDieselRate ?? 0));
          }
          break;
        case Strings.lowToHigh:
          {
            sorted.sort((a, b) => (a?.todayDieselRate ?? 0).compareTo(b?.todayDieselRate ?? 0));
          }
          break;
      }
    }

    return sorted;
  }

  void closeAllPopups() {
    // showSortOfStack.value = false;
    // dropdownController.hide();
  }

  final nearbySuppliersPriceData = Rx<NearbySuppliersPriceDataModel?>(null);
  final stats = Rx<Stats?>(null);
  // Fuel Stats
  LowestHighestBarModel get statsLowestFuel =>
      _buildLowestHighestBar(stats.value?.fuel?.min, Strings.lowest);

  LowestHighestBarModel get statsHighestFuel =>
      _buildLowestHighestBar(stats.value?.fuel?.max, Strings.highest);

  // Diesel Stats
  LowestHighestBarModel get statsLowestDiesel =>
      _buildLowestHighestBar(stats.value?.diesel?.min, Strings.lowest);

  LowestHighestBarModel get statsHighestDiesel =>
      _buildLowestHighestBar(stats.value?.diesel?.max, Strings.highest);

  // Helper to reduce repetition
  LowestHighestBarModel _buildLowestHighestBar(dynamic data, String title) {
    return LowestHighestBarModel(
      title: title,
      name: data?.supplierName ?? '--',
      rate: (data?.rate ?? 0.0).toString(),
    );
  }

  // API loading state
  var isNearbySupplierLoading_ = false.obs;
  bool get isNearbySupplierLoading => isNearbySupplierLoading_.value;

  NearestSupplierDataModel? getSelectedSupplierData(String supplierId) =>
      sortedSuppliers.firstWhere((element) => element?.id == supplierId);

  /// Fetch the latest profile from API
  Future<void> getNearbySuppliersWithPriceStats({
    required double latitude,
    required double longitude,
  }) async {
    if (isNearbySupplierLoading_.value) return; // Prevent duplicate calls
    isNearbySupplierLoading_.value = true;

    try {
      // final data = await NearbySuppliersWPriceStatsService().fetchNearestSuppliersAndPriceStats(
      //   latitude: latitude,
      //   longitude: longitude,
      // );

      // if (data != null) {
      //   nearbySuppliersPriceData.value = data;
      //   stats.value = data.stats;

      //   print(
      //     "nearbySuppliersPriceData.value?.suppliers?[0].email: ${nearbySuppliersPriceData.value?.suppliers?[0].email}",
      //   );
      //   print("stats.value?.fuel?.max: ${stats.value?.fuel?.max?.rate}");

      //   // Save to local storage
      //   // storage.setUserInfo(
      //   //   email: data.email,
      //   //   name: data.name,
      //   //   phone: data.phone,
      //   //   imageUrl: data.image,
      //   //   location: data.location,
      //   // );
      // }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isNearbySupplierLoading_.value = false;
    }
  }
}
