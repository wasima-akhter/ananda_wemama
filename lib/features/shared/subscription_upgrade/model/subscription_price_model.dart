import '../../../../core/helpers/parser_helper.dart';

class SubscriptionPriceModel {
  final double originalPrice;
  final double discount;
  final double finalPrice;

  const SubscriptionPriceModel({
    this.originalPrice = 0.0,
    this.discount = 0.0,
    this.finalPrice = 0.0,
  });

  factory SubscriptionPriceModel.fromJson(Map<String, dynamic>? json) {
    return SubscriptionPriceModel(
      originalPrice: SafeParser.dbl(json?['originalPrice'], 0.0),
      discount: SafeParser.dbl(json?['discount'], 0.0),
      finalPrice: SafeParser.dbl(json?['finalPrice'], 0.0),
    );
  }

  Map<String, dynamic> toJson() => {
    'originalPrice': originalPrice,
    'discount': discount,
    'finalPrice': finalPrice,
  };

  SubscriptionPriceModel copyWith({
    double? originalPrice,
    double? discount,
    double? finalPrice,
  }) {
    return SubscriptionPriceModel(
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      finalPrice: finalPrice ?? this.finalPrice,
    );
  }
}
