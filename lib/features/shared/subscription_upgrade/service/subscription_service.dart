import 'package:purchases_flutter/models/promotional_offer.dart';

import '../../../../app/service_export.dart';
import '../model/subscription_price_model.dart';

class SubscriptionService {
  Future<SubscriptionPriceModel?> getDiscountedPrice() async {
    apiCall() {
      return ApiClient().post(
        Endpoints.getSubscriptionPrice.getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<SubscriptionPriceModel?>(
      apiCall: apiCall,
      parser: (p0) {
        return SubscriptionPriceModel.fromJson(p0);
      },
    );
    return response.data;
  }

  Future<PromotionalOffer?> getIosPromoSignature() async {
    return null;
  }

  // subscription_service.dart
  Future<void> confirmPurchaseWithBackend() async {
    await ApiClient().post(
      Endpoints.confirmPurchase.getUrl,
      headers: HeaderHelpers.getAuthHeader(),
    );
  }
}
