import 'package:purchases_flutter/models/promotional_offer.dart';

import '../../../../app/service_export.dart';
import '../model/subscription_price_model.dart';

class SubscriptionService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<SubscriptionPriceModel?> getDiscountedPrice() async {
    apiCall() {
      return ApiClient().post(
        Endpoints.getSubscriptionPrice.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await _apiHelper.request<SubscriptionPriceModel?>(
      apiCall: apiCall,
      parser: (p0) {
        return SubscriptionPriceModel.fromJson(p0);
      },
    );

    if (response == null) return null;
    return response.data;
  }

  Future<PromotionalOffer?> getIosPromoSignature() async {
    return null;
  }

  Future<void> confirmPurchaseWithBackend() async {}
}
