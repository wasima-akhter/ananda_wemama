// subscription_confirm_controller.dart
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide PurchaseResult;

import '../../../../app/controller_export.dart';
import '../model/subscription_price_model.dart';
import '../service/purchase_service.dart';

class SubscriptionConfirmController extends GetxController {
  final SubscriptionPriceModel eligibility;
  SubscriptionConfirmController(this.eligibility);

  final PurchaseService _purchaseService = PurchaseService.to;

  final RxBool isProcessing = false.obs;
  final RxBool isLoadingOption = true.obs;
  final RxString errorMessage = ''.obs;
  final Rx<SubscriptionOption?> selectedOption = Rx<SubscriptionOption?>(null);
  Package? _package;

  @override
  void onInit() {
    super.onInit();
    _resolveOption();
  }

  Future<void> _resolveOption() async {
    isLoadingOption.value = true;
    try {
      final offerings = await _purchaseService.getOfferings();
      _package = offerings?.current?.monthly;
      if (_package == null) {
        errorMessage.value = 'Subscription plan is currently unavailable.';
        return;
      }

      final options = _package!.storeProduct.subscriptionOptions ?? [];
      selectedOption.value =
          _package!.storeProduct.defaultOption ?? options.firstOrNull;

      if (selectedOption.value == null) {
        errorMessage.value = 'Plan option not available.';
      }
    } finally {
      isLoadingOption.value = false;
    }
  }

  List<PriceRowData> get priceRows {
    final phases = selectedOption.value?.pricingPhases ?? [];
    if (phases.isEmpty) return [];

    // Backend-tracked redemption state gates whether the discount is shown —
    // Play/RC's own phase data doesn't know about our referral code system,
    // so we can't rely on phases.length alone to decide eligibility.
    final discountAvailable = phases.length > 1 && !eligibility.isRedeemed;

    if (!discountAvailable) {
      final price = phases.length > 1 ? phases.last.price : phases.first.price;
      return [PriceRowData('Total', price.formatted, isBold: true)];
    }

    final introPrice = phases.first.price;
    final fullPrice = phases.last.price;

    final discountMicros = fullPrice.amountMicros - introPrice.amountMicros;
    final discountPercent = fullPrice.amountMicros > 0
        ? ((discountMicros / fullPrice.amountMicros) * 100).round()
        : 0;

    return [
      PriceRowData('Original price', fullPrice.formatted),
      if (discountMicros > 0)
        PriceRowData(
          'Discount ($discountPercent%)',
          '-${_formatMicros(discountMicros, fullPrice.currencyCode)}',
          isDiscount: true,
        ),
      PriceRowData('Total', introPrice.formatted, isBold: true),
    ];
  }

  /// Formats a raw micros amount (e.g. a computed difference between two
  /// phases) using the same currency as the store price it was derived from.
  /// Price.formatted is only pre-built for actual phase prices, not for a
  /// derived diff, so this rebuilds it consistently.
  String _formatMicros(int amountMicros, String currencyCode) {
    final amount = amountMicros / 1000000;
    try {
      return NumberFormat.currency(
        name: currencyCode,
        decimalDigits: 2,
      ).format(amount);
    } catch (_) {
      // Fallback if NumberFormat doesn't recognize the currency code locally
      return '$currencyCode ${amount.toStringAsFixed(2)}';
    }
  }

  // ASSUMPTION: originalPrice/discountAmount/finalPrice are minor units (cents).
  // Adjust to match your actual currency/formatting.
  String _formatPrice(int minorUnits) =>
      '\$${(minorUnits / 100).toStringAsFixed(2)}';

  Future<void> onConfirmPayment() async {
    if (_package == null || selectedOption.value == null) return;
    if (eligibility.isRedeemed) {
      errorMessage.value = 'This referral code has already been redeemed.';
      return;
    }

    errorMessage.value = '';
    isProcessing.value = true;
    try {
      final outcome = await _purchaseService.purchasePackage(
        _package!,
        selectedOption.value!,
      );
      await _handleOutcome(outcome);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _handleOutcome(PurchaseOutcome outcome) async {
    switch (outcome.result) {
      case PurchaseResult.success:
        if (eligibility.isRedeemed) {
          // settle the referral discount backend-side now that the store purchase succeeded
        }
        Get.offAllNamed(RoutePaths.subscriptionSuccess, arguments: eligibility);
        break;
      case PurchaseResult.pending:
        Get.offAllNamed(RoutePaths.subscriptionPending, arguments: eligibility);
        break;
      case PurchaseResult.userCancelled:
        break;
      case PurchaseResult.error:
        errorMessage.value =
            outcome.errorMessage ?? 'Payment failed. Please try again.';
        break;
    }
  }
}

class PriceRowData {
  final String label;
  final String formattedPrice;
  final bool isDiscount;
  final bool isBold;
  PriceRowData(
    this.label,
    this.formattedPrice, {
    this.isDiscount = false,
    this.isBold = false,
  });
}
