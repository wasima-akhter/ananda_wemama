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
