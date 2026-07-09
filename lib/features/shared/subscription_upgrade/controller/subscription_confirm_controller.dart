// subscription_confirm_controller.dart
import 'package:purchases_flutter/models/promotional_offer.dart';

import '../../../../app/controller_export.dart';
import '../model/subscription_price_model.dart';
import '../service/purchase_service.dart';
import '../service/subscription_service.dart';

class SubscriptionConfirmController extends GetxController {
  final SubscriptionPriceModel priceModel;
  SubscriptionConfirmController(this.priceModel);

  final PurchaseService _purchaseService = PurchaseService();
  final RxBool isProcessing = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> onConfirmPayment() async {
    errorMessage.value = '';
    isProcessing.value = true;

    try {
      final offerings = await _purchaseService.getOfferings();
      final package = offerings?.current?.monthly;

      if (package == null) {
        errorMessage.value = 'Subscription plan is currently unavailable.';
        return;
      }

      PurchaseOutcome outcome;

      final promoParams = priceModel.discount > 0
          ? await _fetchIosPromoSignature()
          : null;

      if (promoParams != null) {
        outcome = await _purchaseService.purchaseWithDiscount(
          package,
          promoParams,
        );
      } else {
        outcome = await _purchaseService.purchasePackage(package);
      }

      await _handleOutcome(outcome);
    } catch (e, s) {
      debugPrint('Confirm payment error: $e');
      debugPrintStack(stackTrace: s);

      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isProcessing.value = false;
    }
  }

  Future<PromotionalOffer?> _fetchIosPromoSignature() async {
    if (!GetPlatform.isIOS) return null;

    try {
      final resp = await SubscriptionService().getIosPromoSignature();

      if (resp == null) return null;

      return PromotionalOffer(
        resp.identifier,
        resp.keyIdentifier,
        resp.nonce,
        resp.signature,
        resp.timestamp,
      );
    } catch (e, s) {
      debugPrint('Promo signature error: $e');
      debugPrintStack(stackTrace: s);

      // fallback to normal purchase
      return null;
    }
  }

  Future<void> _handleOutcome(PurchaseOutcome outcome) async {
    try {
      switch (outcome.result) {
        case PurchaseResult.success:
          try {
            await SubscriptionService().confirmPurchaseWithBackend();
          } catch (e, s) {
            debugPrint('Backend confirmation error: $e');
            debugPrintStack(stackTrace: s);
            // Webhook can still confirm later
          }

          Get.offAllNamed(RoutePaths.subscriptionSuccess);
          break;

        case PurchaseResult.pending:
          Get.offAllNamed(RoutePaths.subscriptionPending);
          break;

        case PurchaseResult.userCancelled:
          break;

        case PurchaseResult.error:
          errorMessage.value =
              outcome.errorMessage ?? 'Payment failed. Please try again.';
          break;
      }
    } catch (e, s) {
      debugPrint('Handle purchase outcome error: $e');
      debugPrintStack(stackTrace: s);

      errorMessage.value = 'Unable to complete purchase.';
    }
  }
}
