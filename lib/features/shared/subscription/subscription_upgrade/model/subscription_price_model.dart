// subscription_price_model.dart
class SubscriptionPriceModel {
  final int originalPrice;
  final int discountPercentage;
  final int discountAmount;
  final int finalPrice;
  final String? referralCode;
  final bool isReferralApplied;
  final bool isRedeemed;

  const SubscriptionPriceModel({
    this.originalPrice = 0,
    this.discountPercentage = 0,
    this.discountAmount = 0,
    this.finalPrice = 0,
    this.referralCode,
    this.isReferralApplied = false,
    this.isRedeemed = false,
  });

  factory SubscriptionPriceModel.fromJson(Map<String, dynamic>? json) {
    return SubscriptionPriceModel(
      originalPrice: json?['originalPrice'] ?? 0,
      discountPercentage: json?['discountPercentage'] ?? 0,
      discountAmount: json?['discountAmount'] ?? 0,
      finalPrice: json?['finalPrice'] ?? 0,
      referralCode: json?['referralCode'],
      isReferralApplied: json?['isReferralApplied'] ?? false,
      isRedeemed: json?['isRedeemed'] ?? false,
    );
  }

  bool get hasDiscount => isReferralApplied;
}

/*
class SubscriptionPriceModel {
  final OfferType offerType;

  final bool referralAvailable;
  final bool promoAvailable;
  final bool foundingMumAvailable;

  final bool referralRedeemed;
  final bool promoRedeemed;
  final bool foundingMumRedeemed;

  const SubscriptionPriceModel({
    required this.offerType,
    this.referralAvailable = false,
    this.promoAvailable = false,
    this.foundingMumAvailable = false,
    this.referralRedeemed = false,
    this.promoRedeemed = false,
    this.foundingMumRedeemed = false,
  });

  factory SubscriptionPriceModel.fromJson(Map<String, dynamic>? json) {
    return SubscriptionPriceModel(
      offerType: OfferType.values.firstWhere(
        (e) => e.name == json?['offerType'],
        orElse: () => OfferType.none,
      ),

      referralAvailable: json?['referralAvailable'] ?? false,
      promoAvailable: json?['promoAvailable'] ?? false,
      foundingMumAvailable: json?['foundingMumAvailable'] ?? false,

      referralRedeemed: json?['referralRedeemed'] ?? false,
      promoRedeemed: json?['promoRedeemed'] ?? false,
      foundingMumRedeemed: json?['foundingMumRedeemed'] ?? false,
    );
  }
}
*/
