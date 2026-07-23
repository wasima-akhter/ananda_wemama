// enum OfferType

// class OfferEligibility

// class OfferValidationResult
import '../model/subscription_price_model.dart';

enum OfferType { none, referral, promo, fundingMum }

class OfferEligibility {
  final bool referralAvailable;
  final bool promoAvailable;
  final bool fundingMumAvailable;

  final bool referralRedeemed;
  final bool promoRedeemed;
  final bool fundingMumRedeemed;

  const OfferEligibility({
    required this.referralAvailable,
    required this.promoAvailable,
    required this.fundingMumAvailable,
    required this.referralRedeemed,
    required this.promoRedeemed,
    required this.fundingMumRedeemed,
  });

  factory OfferEligibility.fromSubscription(
    SubscriptionPriceModel eligibility,
  ) {
    return OfferEligibility(
      referralAvailable:
          (eligibility.referralCode ?? '').trim().isEmpty &&
          !eligibility.isRedeemed,

      // TODO replace with backend flags later
      promoAvailable: true,

      // TODO replace with backend flags later
      fundingMumAvailable: true,

      referralRedeemed: eligibility.isRedeemed,

      // TODO replace with backend values
      promoRedeemed: false,

      // TODO replace with backend values
      fundingMumRedeemed: false,
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
