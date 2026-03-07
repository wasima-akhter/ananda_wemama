import 'package:mama_app/core/components/mood_check_in/mood_check_in_controller.dart';

import '../../../../app/controller_export.dart';
 
 
class HomeController extends GetxController {
  // get the global moodcheckin controller
  final mcc = findCont<MoodCheckInController>();
 
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

 
  void closeAllPopups() {
    // showSortOfStack.value = false;
    // dropdownController.hide();
  }
 

  // API loading state
  var isNearbySupplierLoading_ = false.obs;
  bool get isNearbySupplierLoading => isNearbySupplierLoading_.value;
 
  /// Fetch the latest profile from API
  Future<void> getNearbySuppliersWithPriceStats({
    required double latitude,
    required double longitude,
  }) async {
    if (isNearbySupplierLoading_.value) return; // Prevent duplicate calls
    isNearbySupplierLoading_.value = true;

    try {
      // final data = await NearbySuppliersWPriceStatsService().fetchNearestSuppliersAndPriceStats(
     
      // );

      // if (data != null) {
 
      // }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isNearbySupplierLoading_.value = false;
    }
  }
}
