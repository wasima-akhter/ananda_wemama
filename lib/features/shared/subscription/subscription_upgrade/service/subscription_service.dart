import 'package:we_mama/core/services/profile/profile_info_service.dart';

import '../../../../../app/service_export.dart';
import '../model/subscription_price_model.dart';

class SubscriptionService {
  Future<SubscriptionPriceModel?> getDiscountedPrice() async {
    final res = await ProfileInfoService().fetchProfile();

    final rawCode = res?.referral?.code;
    final code = (rawCode == null || rawCode.trim().isEmpty) ? 'abc' : rawCode;

    print(
      "res profile info : is referral code applied: ${res?.referral?.isRedeemed}",
    );

    return SubscriptionPriceModel(
      referralCode: code,
      isRedeemed: res?.referral?.isRedeemed ?? false,
    );
  }

  Future<String?> getIosOfferCode() async {
    // TODO: replace with a real backend call, e.g.
    // final res = await ApiClient().get(Endpoints.iosOfferCode.getUrl);
    // return res?.data?['code'] as String?;
    return 'REFERRAL50'; // ← temp stub, matches exactly what you type into ASC
  }

  // subscription_service.dart
  Future<void> confirmPurchaseWithBackend() async {
    await ApiClient().post(
      Endpoints.confirmPurchase.getUrl,
      headers: HeaderHelpers.getAuthHeader(),
    );
  }
}
