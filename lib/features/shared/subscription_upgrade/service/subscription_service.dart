import 'package:mama_app/core/services/profile/profile_info_service.dart';
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

    final res = await ProfileInfoService().fetchProfile();

    print(
      "res profile info : is refferal code applied: ${res?.referral?.isRedeemed}",
    );

    return SubscriptionPriceModel(
      referralCode: res?.referral?.code ?? 'abc',
      isRedeemed: res?.referral?.isRedeemed ?? false,
    );
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
