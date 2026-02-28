import '../../../../app/service_export.dart';
import '../../../views/review_and_rating/model/review_model.dart';

class GetReviewService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  /// Fetch inventory details from API

  Future<AllReviewsResponseModel?> fetchAllReviews({required String supplierId}) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getAllReviews(supplierId: supplierId).getUrl,
        reqName: Strings.reviewAndRatings,
        headers: HeaderHelpers.jsonHeader(),
      );
    }

    final response = await _apiHelper.request<AllReviewsResponseModel?>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: ${data}");

        return AllReviewsResponseModel.fromJson(data);
      },
    );

    if (response?.data == null) return null;

    print("response data: ${response?.data}");
    return response?.data;
  }
}
