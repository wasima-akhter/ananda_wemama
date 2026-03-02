import 'package:get/get.dart';

import '../../../../core/services/more/review/get_review_service.dart';
import '../model/review_model.dart';

class ReviewAndRatingController extends GetxController {
  final String supplierId;

  ReviewAndRatingController(this.supplierId);
  var showAllReviews = false.obs;

  void readAllReviewOnTap() {
    showAllReviews.value = true;
  }

  @override
  void onInit() {
    print("supplierId from ReviewAndRatingController: $supplierId");
    super.onInit();
    getAllReviews(); // Then fetch fresh data from API
  }

  /////////
  ///
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final allReviewsData = AllReviewsResponseModel().obs;

  /// Fetch the latest profile from API
  Future<void> getAllReviews() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      final data = await GetReviewService().fetchAllReviews(supplierId: supplierId);

      if (data != null) {
        allReviewsData.value = data; //
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  ///
}
