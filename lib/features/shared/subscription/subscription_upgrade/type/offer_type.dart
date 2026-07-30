// enum OfferType

// class OfferEligibility

// class OfferValidationResult
import '../model/subscription_price_model.dart';

enum OfferType { none, referral, promo, foundingMum }

class OfferEligibility {
  final bool referralAvailable;
  final bool promoAvailable;
  final bool foundingMumAvailable;

  final bool referralRedeemed;
  final bool promoRedeemed;
  final bool foundingMumRedeemed;

  const OfferEligibility({
    required this.referralAvailable,
    required this.promoAvailable,
    required this.foundingMumAvailable,
    required this.referralRedeemed,
    required this.promoRedeemed,
    required this.foundingMumRedeemed,
  });

  factory OfferEligibility.fromSubscription(
    SubscriptionPriceModel eligibility,
  ) {
    return OfferEligibility(
      referralAvailable:
          (eligibility.referralCode ?? '').trim().isNotEmpty &&
          !eligibility.isRedeemed,

      // TODO replace with backend flags later
      promoAvailable: true,

      // TODO replace with backend flags later
      foundingMumAvailable: true,

      referralRedeemed: eligibility.isRedeemed,

      // TODO replace with backend values
      promoRedeemed: false,

      // TODO replace with backend values
      foundingMumRedeemed: false,
    );
  }
}

class OfferValidationResult {
  final bool success;
  final OfferType type;
  final String? message;

  const OfferValidationResult({
    required this.success,
    required this.type,
    this.message,
  });
}
