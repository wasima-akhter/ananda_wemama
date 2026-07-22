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

      debugPrint('🔍 offerings.current: ${offerings?.current?.identifier}');
      debugPrint('🔍 all offerings: ${offerings?.all.keys}');
      debugPrint(
        '🔍 available packages: ${offerings?.current?.availablePackages.map((p) => p.storeProduct.identifier)}',
      );
      Get.snackbar(
        "identifier: ${offerings?.current?.identifier}",
        "${offerings?.current?.availablePackages.toString()}",
      );

      _package = offerings?.current?.monthly;
      debugPrint('🔍 _package: ${_package?.storeProduct.identifier}');
      _package = offerings?.current?.monthly;
      if (_package == null) {
        errorMessage.value = 'Subscription plan is currently unavailable.';
        _showErrorSnackbar(errorMessage.value);
        return;
      }

      final options = _package!.storeProduct.subscriptionOptions ?? [];
      selectedOption.value =
          _package!.storeProduct.defaultOption ?? options.firstOrNull;

      // Only Android's purchase path needs a resolved SubscriptionOption
      // (base plan + offer). iOS purchases the Package directly.
      if (selectedOption.value == null && GetPlatform.isAndroid) {
        errorMessage.value = 'Plan option not available.';
        _showErrorSnackbar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load subscription plan.';
      _showErrorSnackbar(errorMessage.value);
    } finally {
      isLoadingOption.value = false;
    }
  }

  List<PriceRowData> get priceRows {
    final phases = selectedOption.value?.pricingPhases ?? [];
    if (phases.isEmpty) {
      final price = _package?.storeProduct.priceString;
      return price == null ? [] : [PriceRowData('Total', price, isBold: true)];
    }

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

  String _formatMicros(int amountMicros, String currencyCode) {
    final amount = amountMicros / 1000000;
    try {
      return NumberFormat.currency(
        name: currencyCode,
        decimalDigits: 2,
      ).format(amount);
    } catch (_) {
      return '$currencyCode ${amount.toStringAsFixed(2)}';
    }
  }

  bool get isPurchaseBlocked =>
      _package == null ||
      (selectedOption.value == null && GetPlatform.isAndroid);

  Future<void> onConfirmPayment() async {
    if (isPurchaseBlocked) {
      _showErrorSnackbar(
        '__package == null ||  (selectedOption.value == null && GetPlatform.isAndroid), isPurchaseBlocked Subscription plan is unavailable.',
      );
      return;
    }

    if (eligibility.isRedeemed) {
      errorMessage.value = 'This referral code has already been redeemed.';
      _showErrorSnackbar(errorMessage.value);
      return;
    }

    errorMessage.value = '';
    isProcessing.value = true;

    try {
      final outcome = await _purchaseService.purchasePackage(
        _package!,
        selectedOption.value,
      );

      if (outcome.result == PurchaseResult.error) {
        _showErrorSnackbar(
          outcome.errorMessage ??
              'Unable to complete purchase. Please try again.',
        );
      }

      await _handleOutcome(outcome);
    } catch (e) {
      errorMessage.value = 'Payment failed. Please try again.';
      _showErrorSnackbar(errorMessage.value);
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
        _showErrorSnackbar(errorMessage.value);
        break;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
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
