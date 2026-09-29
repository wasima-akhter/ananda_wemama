// subscription_confirm_controller.dart
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide PurchaseResult;
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/controller_export.dart';
import '../../../../post_auth_setup/promo_code/controller/promo_code_controller.dart';
import '../model/subscription_price_model.dart';
import '../service/purchase_service.dart';
import '../service/subscription_service.dart';
import '../type/offer_type.dart';

class SubscriptionConfirmController extends GetxController {
  final SubscriptionPriceModel eligibility;

  SubscriptionConfirmController(this.eligibility);

  final PurchaseService _purchaseService = PurchaseService.to;

  late OfferEligibility offerEligibility;

  OfferType get currentOffer {
    if (!Get.isRegistered<PromoCodeController>()) {
      Get.lazyPut<PromoCodeController>(
        () => PromoCodeController(),
        fenix: true,
      );
    }

    return Get.find<PromoCodeController>().currentOffer.value;
  }

  final RxBool isProcessing = false.obs;

  final RxBool isLoadingOption = true.obs;

  final RxString errorMessage = ''.obs;

  final Rx<SubscriptionOption?> selectedOption = Rx<SubscriptionOption?>(null);

  Package? _package;

  static const String _iosAppStoreAppId = '6790629482';

  final RxBool isWaitingForRedemption = false.obs;

  AppLifecycleListener? _lifecycleListener;

  Worker? _entitlementWorker;

  final Rx<StoreProductDiscount?> iosPromoDiscount = Rx<StoreProductDiscount?>(
    null,
  );

  bool _isSubmitting = false;

  @override
  void onInit() {
    super.onInit();

    offerEligibility = OfferEligibility.fromSubscription(eligibility);

    print('🟢 SubscriptionConfirmController INIT');

    print('🟢 Current offer = ${currentOffer.name}');

    _resolveOption();

    if (GetPlatform.isIOS) {
      _entitlementWorker = ever<bool>(_purchaseService.isActive, (active) {
        print('🟢 Entitlement update active=$active');

        if (active && isWaitingForRedemption.value) {
          isWaitingForRedemption.value = false;

          _onRedeemedSuccessfully();
        }
      });

      _lifecycleListener = AppLifecycleListener(
        onResume: () async {
          print("🟢 APP RESUME");

          if (isWaitingForRedemption.value) {
            print("🟢 Refreshing CustomerInfo after redeem");

            await _purchaseService.refreshCustomerInfo();
          }
        },
      );
    }
  }

  @override
  void onClose() {
    _entitlementWorker?.dispose();

    _lifecycleListener?.dispose();

    super.onClose();
  }

  bool get isPurchaseBlocked =>
      _package == null ||
      (selectedOption.value == null && GetPlatform.isAndroid);

  Future<void> _resolveOption() async {
    isLoadingOption.value = true;

    try {
      final offerings = await _purchaseService.getOfferings();

      print('🟢 Offerings=${offerings?.current?.identifier}');

      printOfferings(offerings);

      // 1. Resolve package first
      _package = offerings?.current?.availablePackages.firstOrNull;

      if (_package == null) {
        errorMessage.value = 'Subscription plan is currently unavailable.';

        _showErrorSnackbar(errorMessage.value);

        return;
      }
      final options = _package!.storeProduct.subscriptionOptions ?? [];

      switch (currentOffer) {
        case OfferType.promo:
          if (GetPlatform.isAndroid) {
            selectedOption.value = options.firstWhereOrNull(
              (o) => o.id.contains('promo'),
            );
          } else {
            selectedOption.value = options.firstWhereOrNull(
              (o) => o.id.startsWith('promo_'),
            );
          }

          if (selectedOption.value == null) {
            print('⚠️ No promo option found');
          }
          break;

        case OfferType.referral:
          if (GetPlatform.isAndroid) {
            selectedOption.value = options.firstWhereOrNull(
              (o) => o.id.contains('referral'),
            );
          } else {
            selectedOption.value = options.firstWhereOrNull(
              (o) => o.id.startsWith('referral_'),
            );
          }
          break;

        case OfferType.foundingMum:
          if (GetPlatform.isAndroid) {
            selectedOption.value = options.firstWhereOrNull(
              (o) => o.id.contains('founding'),
            );
          } else {
            selectedOption.value = options.firstWhereOrNull(
              (o) => o.id.startsWith('founding_'),
            );
          }
          break;

        case OfferType.none:
          selectedOption.value =
              _package!.storeProduct.defaultOption ?? options.firstOrNull;
          break;
      }

      print('🟢 Selected option=${selectedOption.value?.id}');

      print(_package!.storeProduct.toString());
      print("Identifier = ${_package!.storeProduct.identifier}");

      print("Price = ${_package!.storeProduct.priceString}");

      print("Intro = ${_package!.storeProduct.introductoryPrice}");

      print("Discounts = ${_package!.storeProduct.discounts}");

      print("========== IOS DISCOUNTS ==========");

      print("Discount count = ${_package!.storeProduct.discounts?.length}");

      for (final d in _package!.storeProduct.discounts ?? []) {
        print("---------------------------");
        print("Identifier : ${d.identifier}");
        print("Price      : ${d.priceString}");
      }

      print("==================================");

      print('OfferType = $currentOffer');
      print('Eligible = $_isEligibleForOffer');
      print('Selected = ${selectedOption.value?.id}');
      print('Phases = ${selectedOption.value?.pricingPhases.length}');

      for (final phase in selectedOption.value?.pricingPhases ?? []) {
        print(
          'Price=${phase.price.formatted}, '
          'Cycles=${phase.billingCycleCount}, '
          'Mode=${phase.recurrenceMode}',
        );
      }

      if (selectedOption.value == null && GetPlatform.isAndroid) {
        errorMessage.value = 'Plan option not available.';

        _showErrorSnackbar(errorMessage.value);
      }

      if (GetPlatform.isIOS &&
          // (currentOffer == OfferType.promo ||
          //     currentOffer == OfferType.foundingMum)
          //  &&
          _isEligibleForOffer) {
        if (GetPlatform.isIOS && _isEligibleForOffer) {
          switch (currentOffer) {
            case OfferType.foundingMum:
              iosPromoDiscount.value = _package!.storeProduct.discounts
                  ?.firstWhereOrNull(
                    (d) => d.identifier.startsWith('founding'),
                  );
              break;

            case OfferType.promo:
              iosPromoDiscount.value = _package!.storeProduct.discounts
                  ?.firstWhereOrNull((d) => d.identifier.startsWith('promo'));
              break;

            default:
              break;
          }

          print('🟢 iOS discount=${iosPromoDiscount.value}');
        }
        // iosPromoDiscount.value = _package!.storeProduct.discounts?.firstOrNull;

        print(
          "_package!.storeProduct.discounts: ${_package!.storeProduct.discounts.toString()}",
        );

        print('🟢 iOS discount=${iosPromoDiscount.value}');
      }
    } catch (e, stack) {
      print('❌ Resolve option error=$e');

      debugPrintStack(stackTrace: stack);

      errorMessage.value = 'Failed to load subscription plan.';

      _showErrorSnackbar(errorMessage.value);
    } finally {
      isLoadingOption.value = false;
    }
  }

  //

  Future<void> onConfirmPayment() async {
    if (_isSubmitting) {
      print('🟡 Payment already running');

      return;
    }

    _isSubmitting = true;

    print('🟢 CONFIRM PAYMENT');

    print('🟢 OFFER=${currentOffer.name}');

    print('🟢 PLATFORM=${GetPlatform.isIOS ? "IOS" : "ANDROID"}');

    if (isPurchaseBlocked) {
      _isSubmitting = false;

      _showErrorSnackbar('Subscription plan is unavailable.');

      return;
    }

    try {
      switch (currentOffer) {
        case OfferType.none:
          await purchaseNormal();

          break;

        case OfferType.referral:
          await purchaseReferral();

          break;

        case OfferType.promo:
          await purchasePromo();

          break;

        case OfferType.foundingMum:
          await purchaseFundingMum();

          break;
      }
    } finally {
      _isSubmitting = false;
    }
  }

  Future<void> purchaseNormal() async {
    print('🟢 FLOW=Normal purchase');

    errorMessage.value = '';

    isProcessing.value = true;

    try {
      final outcome = await _purchaseService.purchasePackage(
        _package!,
        selectedOption.value,
      );

      print('🟢 Normal result=${outcome.result}');

      await _handleOutcome(outcome);
    } catch (e, stack) {
      print('❌ Normal purchase error=$e');

      debugPrintStack(stackTrace: stack);

      errorMessage.value = 'Payment failed. Please try again.';

      _showErrorSnackbar(errorMessage.value);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> purchaseReferral() async {
    print('🟢 FLOW=Referral');

    if (!offerEligibility.referralAvailable) {
      _showErrorSnackbar('Referral offer unavailable.');
      return;
    }

    if (offerEligibility.referralRedeemed) {
      errorMessage.value = 'This referral code has already been redeemed.';
      _showErrorSnackbar(errorMessage.value);
      return;
    }

    isProcessing.value = true;
    errorMessage.value = '';

    try {
      if (GetPlatform.isIOS) {
        await _redeemIosOfferCode();
        return;
      }

      print('🤖 Referral Android offer purchase');

      final outcome = await _purchaseService.purchaseWithAndroidOffer(
        _package!,
        OfferType.referral,
      );

      await _handleOutcome(outcome);
    } catch (e, stack) {
      print('❌ Referral purchase error=$e');
      debugPrintStack(stackTrace: stack);

      errorMessage.value = 'Unable to apply referral offer.';

      _showErrorSnackbar(errorMessage.value);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> purchasePromo() async {
    print('🟢 FLOW=Promo');

    if (!offerEligibility.promoAvailable) {
      _showErrorSnackbar('Promo offer unavailable.');

      return;
    }

    isProcessing.value = true;

    errorMessage.value = '';

    try {
      PurchaseOutcome outcome;

      if (GetPlatform.isIOS && iosPromoDiscount.value != null) {
        print('🟢 iOS signed promotional offer');

        final promoOffer = await Purchases.getPromotionalOffer(
          _package!.storeProduct,
          iosPromoDiscount.value!,
        );

        outcome = await _purchaseService.purchaseWithDiscount(
          _package!,
          promoOffer,
        );
      } else {
        print('🤖 Android promo offer purchase');

        outcome = await _purchaseService.purchaseWithAndroidOffer(
          _package!,
          OfferType.promo,
        );
      }

      await _handleOutcome(outcome);
    } catch (e, stack) {
      print('❌ Promo error=$e');

      debugPrintStack(stackTrace: stack);

      errorMessage.value = 'Payment failed. Please try again.';

      _showErrorSnackbar(errorMessage.value);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> purchaseFundingMum() async {
    print('🟢 FLOW=Funding Mum');

    if (!offerEligibility.foundingMumAvailable) {
      _showErrorSnackbar('Funding Mum offer unavailable.');
      return;
    }

    isProcessing.value = true;
    errorMessage.value = '';

    try {
      late PurchaseOutcome outcome;

      if (GetPlatform.isIOS) {
        print('🍎 Funding Mum iOS promotional offer');

        final discount = await _getFundingMumDiscount();

        if (discount == null) {
          throw Exception('Funding Mum offer not available');
        }

        final promoOffer = await Purchases.getPromotionalOffer(
          _package!.storeProduct,
          discount,
        );
        final eligibility =
            await Purchases.checkTrialOrIntroductoryPriceEligibility([
              _package!.storeProduct.identifier,
            ]);

        final status = eligibility[_package!.storeProduct.identifier]?.status;

        print("🍎 Apple eligibility=$status");
        outcome = await _purchaseService.purchaseWithDiscount(
          _package!,
          promoOffer,
        );
      } else {
        print('🤖 Funding Mum Android offer');

        outcome = await _purchaseService.purchaseWithAndroidOffer(
          _package!,
          OfferType.foundingMum,
        );
      }

      await _handleOutcome(outcome);
    } on PlatformException catch (e) {
      print('Payment exception code=${e.code}');
      print('Payment exception details=${e.details}');
      print('Payment exception message=${e.message}');

      final isIneligible =
          e.code.toString() == '18' ||
          e.message?.contains('ineligible') == true ||
          e.details.toString().contains('INELIGIBLE_ERROR');

      if (isIneligible) {
        const msg =
            'This promotional offer is no longer available for your Apple ID. '
            'Please use another subscription option.';

        Get.snackbar(
          'Offer unavailable',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );

        errorMessage.value = msg;
      }

      Get.snackbar(
        'Payment Error',
        e.message ?? 'Purchase failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stack) {
      print('❌ Funding Mum error=$e');

      debugPrintStack(stackTrace: stack);

      _showErrorSnackbar(errorMessage.value);

      errorMessage.value = 'Unable to activate Funding Mum offer.';

      _showErrorSnackbar(errorMessage.value);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<StoreProductDiscount?> _getFundingMumDiscount() async {
    final discounts = _package?.storeProduct.discounts ?? [];

    for (final d in discounts) {
      print("Discount id=${d.identifier}, price=${d.priceString}");
    }

    return discounts.firstWhereOrNull(
      (d) => d.identifier.toLowerCase() == 'founding_mum_100',
    );
  }

  Future<void> _redeemIosOfferCode() async {
    print('🟢 Opening iOS redeem code flow');

    isProcessing.value = true;

    errorMessage.value = '';

    try {
      final code = await SubscriptionService().getIosOfferCode();

      if (code == null || code.isEmpty) {
        _showErrorSnackbar(
          'Offer unavailable right now. Please try again later.',
        );

        return;
      }

      final url = Uri.parse(
        'https://apps.apple.com/redeem?ctx=offercodes&id=$_iosAppStoreAppId&code=$code',
      );

      // Make sure we have fresh entitlement state first.
      await _purchaseService.refreshCustomerInfo();

      isWaitingForRedemption.value = true;

      print('🟢 Launching redeem URL=$url');

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e, stack) {
      print('❌ Redeem error=$e');

      debugPrintStack(stackTrace: stack);

      _showErrorSnackbar('Unable to open redemption. Please try again.');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _onRedeemedSuccessfully() async {
    // await _purchaseService.refreshCustomerInfo();

    final info = _purchaseService.customerInfo.value;

    if (info == null) {
      return;
    }

    final entitlement = info.entitlements.all[PurchaseService.entitlementId];

    if (entitlement?.isActive != true) {
      return;
    }

    Get.offAllNamed(RoutePaths.subscriptionSuccess, arguments: eligibility);
  }

  bool get _isEligibleForOffer {
    switch (currentOffer) {
      case OfferType.referral:
        return offerEligibility.referralAvailable;

      case OfferType.promo:
        return offerEligibility.promoAvailable;

      case OfferType.foundingMum:
        return offerEligibility.foundingMumAvailable;

      case OfferType.none:
        return false;
    }
  }

  Future<void> _handleOutcome(PurchaseOutcome outcome) async {
    print('🟢 Handling outcome=${outcome.result}');

    switch (outcome.result) {
      case PurchaseResult.success:
        print('🟢 Purchase success offer=${currentOffer.name}');

        switch (currentOffer) {
          case OfferType.referral:
            print('🟢 Referral completed');

            break;

          case OfferType.promo:
            print('🟢 Promo completed');

            break;

          case OfferType.foundingMum:
            print('🟢 Funding Mum completed');

            break;

          case OfferType.none:
            print('🟢 Normal subscription completed');

            break;
        }

        Get.offAllNamed(RoutePaths.subscriptionSuccess, arguments: eligibility);

        break;

      case PurchaseResult.pending:
        print('🟡 Purchase pending');

        Get.offAllNamed(RoutePaths.subscriptionPending, arguments: eligibility);

        break;

      case PurchaseResult.userCancelled:
        print('🟡 User cancelled');

        break;

      case PurchaseResult.error:
        errorMessage.value =
            outcome.errorMessage ?? 'Payment failed. Please try again.';

        _showErrorSnackbar(errorMessage.value);

        break;
    }
  }

  String get confirmButtonText {
    switch (currentOffer) {
      case OfferType.referral:
        return GetPlatform.isIOS
            ? "Redeem Referral Offer"
            : "Apply Referral Offer";

      case OfferType.promo:
        return "Apply Promo Offer";

      case OfferType.foundingMum:
        return "Activate Funding Mum";

      case OfferType.none:
        return "Confirm And Pay";
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  List<PriceRowData> get priceRows {
    final phases = selectedOption.value?.pricingPhases ?? [];

    if (phases.isEmpty) {
      if (GetPlatform.isIOS && iosPromoDiscount.value != null) {
        final discount = iosPromoDiscount.value!;

        final originalPrice = _package!.storeProduct.priceString;

        final isFreeTrial = discount.price == 0;

        return [
          PriceRowData('Subscription price', '$originalPrice/month'),

          if (isFreeTrial) ...[
            PriceRowData(
              'Offer Duration',
              'Free for 3 months',
              isDiscount: true,
            ),

            PriceRowData(
              'After free period',
              '$originalPrice/month',
              isBold: true,
            ),
          ] else ...[
            PriceRowData('Offer price', discount.priceString, isDiscount: true),

            PriceRowData('Offer duration', 'Limited promotional period'),

            PriceRowData('After offer', '$originalPrice/month', isBold: true),
          ],
        ];
      }
      final price = _package?.storeProduct.priceString;

      return price == null ? [] : [PriceRowData('Total', price, isBold: true)];
    }

    final discountAvailable = phases.length > 1 && _isEligibleForOffer;

    if (GetPlatform.isAndroid &&
        currentOffer == OfferType.foundingMum &&
        phases.length >= 2) {
      final trialPhase = phases.first;
      final recurringPhase = phases.last;

      final isFreeTrial = trialPhase.price.amountMicros == 0;

      if (isFreeTrial) {
        final months = trialPhase.billingPeriod?.value;

        return [
          PriceRowData(
            'Subscription price',
            '${recurringPhase.price.formatted}/month',
          ),

          PriceRowData('Offer', 'Free for $months months', isDiscount: true),

          PriceRowData(
            'After free period',
            '${recurringPhase.price.formatted}/month',
            isBold: true,
          ),
        ];
      }
    }
    if (GetPlatform.isAndroid &&
        currentOffer == OfferType.referral &&
        phases.length >= 2) {
      final offerPhase = phases.first;
      final recurringPhase = phases.last;

      final months = offerPhase.billingPeriod?.value ?? 1;

      return [
        PriceRowData(
          'Subscription price',
          '${recurringPhase.price.formatted}/month',
        ),

        PriceRowData(
          'Referral offer',
          '${offerPhase.price.formatted}/month',
          isDiscount: true,
        ),

        PriceRowData(
          'After offer',
          '${recurringPhase.price.formatted}/month',
          isBold: true,
        ),
      ];
    }
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
}

void printOfferings(Offerings? offerings) {
  if (offerings == null) {
    print("❌ Offerings: null");
    return;
  }

  print("========== REVENUECAT OFFERINGS ==========");

  print("Current Offering: ${offerings.current?.identifier}");

  for (final entry in offerings.all.entries) {
    final offering = entry.value;

    print("------------------------------------------");
    print("Offering ID: ${offering.identifier}");
    print("Packages:");

    for (final package in offering.availablePackages) {
      print("  Package Identifier: ${package.identifier}");
      print("  Package Type: ${package.packageType}");

      print("  Product ID: ${package.storeProduct.identifier}");
      print("  Product Title: ${package.storeProduct.title}");
      print("  Price: ${package.storeProduct.priceString}");

      final options = package.storeProduct.subscriptionOptions ?? [];

      if (options.isNotEmpty) {
        print("  Subscription Options:");

        for (final option in options) {
          print("    Option ID: ${option.id}");
          print("    Pricing Phases:");

          for (final phase in option.pricingPhases) {
            print(
              "      ${phase.price.formatted} "
              "${phase.billingPeriod?.unit} "
              "cycles=${phase.billingCycleCount}",
            );
          }
        }
      }

      print("");
    }
  }

  print("==========================================");
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

/*
class SubscriptionConfirmController extends GetxController {
  final SubscriptionPriceModel eligibility;
  SubscriptionConfirmController(this.eligibility);

  final PurchaseService _purchaseService = PurchaseService.to;

  final RxBool isProcessing = false.obs;
  final RxBool isLoadingOption = true.obs;
  final RxString errorMessage = ''.obs;
  final Rx<SubscriptionOption?> selectedOption = Rx<SubscriptionOption?>(null);
  Package? _package;

  static const String _iosAppStoreAppId = '6790629482'; // from your ASC URL

  final RxBool isWaitingForRedemption = false.obs;
  AppLifecycleListener? _lifecycleListener;
  Worker? _entitlementWorker;

  @override
  void onInit() {
    super.onInit();
    _resolveOption();

    if (GetPlatform.isIOS) {
      // Catches the case where RevenueCat's own transaction observer
      // picks up the redemption automatically.
      _entitlementWorker = ever<bool>(_purchaseService.isActive, (active) {
        if (active && isWaitingForRedemption.value) {
          isWaitingForRedemption.value = false;
          _onRedeemedSuccessfully();
        }
      });

      // Belt-and-suspenders: actively re-check when the user comes back
      // from the App Store app, instead of only waiting passively.
      _lifecycleListener = AppLifecycleListener(
        onResume: () async {
          if (isWaitingForRedemption.value) {
            await _purchaseService.refreshCustomerInfo();
          }
        },
      );
    }
  }

  @override
  void onClose() {
    _entitlementWorker?.dispose();
    _lifecycleListener?.dispose();
    super.onClose();
  }

  Future<void> _redeemIosOfferCode() async {
    isProcessing.value = true;
    errorMessage.value = '';
    try {
      final code = await SubscriptionService().getIosOfferCode();
      if (code == null || code.isEmpty) {
        _showErrorSnackbar(
          'Offer unavailable right now. Please try again later.',
        );
        return;
      }

      final url = Uri.parse(
        'https://apps.apple.com/redeem?ctx=offercodes&id=$_iosAppStoreAppId&code=$code',
      );

      isWaitingForRedemption.value = true;
      await launchUrl(url, mode: LaunchMode.externalApplication);
      // No callback here — the listeners in onInit() pick up success
      // once the App Store finishes the redemption and the user returns.
    } catch (e, stack) {
      print('❌ Offer code redemption error: $e');
      debugPrintStack(stackTrace: stack);
      _showErrorSnackbar('Unable to open redemption. Please try again.');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _onRedeemedSuccessfully() async {
    // TODO: mark redeemed on your backend now that entitlement is confirmed active
    // await SubscriptionService().confirmPurchaseWithBackend();
    Get.offAllNamed(RoutePaths.subscriptionSuccess, arguments: eligibility);
  }

  /// Eligible for the referral discount/offer only if a real referral
  /// code is present AND it hasn't already been redeemed.
  bool get _isEligibleForOffer =>
      (eligibility.referralCode ?? '').trim().isEmpty &&
      eligibility.isRedeemed == false;

  final Rx<StoreProductDiscount?> iosPromoDiscount = Rx<StoreProductDiscount?>(
    null,
  );

  Future<void> _resolveOption() async {
    isLoadingOption.value = true;
    try {
      final offerings = await _purchaseService.getOfferings();

      print('🔍 offerings.current: ${offerings?.current?.identifier}');
      print('🔍 all offerings: ${offerings?.all.keys}');
      print(
        '🔍 available packages: ${offerings?.current?.availablePackages.map((p) => p.storeProduct.identifier)}',
      );

      print(
        '🔍 oofferings?.current?.availablePackages.toString(): ${offerings?.current?.availablePackages.toString()}',
      );

      Get.snackbar(
        "identifier: ${offerings?.current?.identifier}",
        "${offerings?.current?.availablePackages.toString()}",
      );

      _package = offerings?.current?.monthly;
      print('🔍 _package: ${_package?.storeProduct.identifier}');
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
      // Only Android's purchase path needs a resolved SubscriptionOption
      // (base plan + offer). iOS purchases the Package directly.
      if (selectedOption.value == null && GetPlatform.isAndroid) {
        errorMessage.value = 'Plan option not available.';
        _showErrorSnackbar(errorMessage.value);
      }

      print("_isEligibleForOffer: $_isEligibleForOffer");

      // ── NEW: iOS promotional offer lookup ──────────────────────────
      // No hardcoded identifier — RevenueCat/Apple only require one when
      // a single product has multiple competing promotional offers.
      // With a single configured offer, the first discount IS the offer.
      if (GetPlatform.isIOS && _isEligibleForOffer) {
        iosPromoDiscount.value = _package!.storeProduct.discounts?.firstOrNull;
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
      // iOS — show original + promotional price if eligible
      if (GetPlatform.isIOS && iosPromoDiscount.value != null) {
        final discount = iosPromoDiscount.value!;
        return [
          PriceRowData('Original price', _package!.storeProduct.priceString),
          PriceRowData(
            'Discounted price',
            discount.priceString,
            isDiscount: true,
          ),
          PriceRowData('Total', discount.priceString, isBold: true),
        ];
      }

      final price = _package?.storeProduct.priceString;
      return price == null ? [] : [PriceRowData('Total', price, isBold: true)];
    }

    final discountAvailable = phases.length > 1 && _isEligibleForOffer;

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
  /*
  Future<void> onConfirmPayment() async {
    print('🟢 onConfirmPayment TAPPED');
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
      print('🟢 calling _purchaseService.purchasePackage...');
      // final outcome = await _purchaseService.purchasePackage(
      //   _package!,
      //   selectedOption.value,
      // );

      final PurchaseOutcome outcome;
      // ── NEW: route eligible iOS users through the signed promo offer ──
      if (GetPlatform.isIOS && iosPromoDiscount.value != null) {
        print('🟢 purchasing with iOS promotional offer');
        final promoOffer = await Purchases.getPromotionalOffer(
          _package!.storeProduct,
          iosPromoDiscount.value!,
        );
        outcome = await _purchaseService.purchaseWithDiscount(
          _package!,
          promoOffer,
        );
      } else {
        print('🟢 calling _purchaseService.purchasePackage...');
        outcome = await _purchaseService.purchasePackage(
          _package!,
          selectedOption.value,
        );
      }

      print('🟢 purchasePackage returned: ${outcome.result}');

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
*/

  bool _isSubmitting =
      false; // synchronous guard, doesn't depend on UI rebuild timing

  Future<void> onConfirmPayment() async {
    if (_isSubmitting) return;
    _isSubmitting = true;

    print('🟢 onConfirmPayment TAPPED');
    if (isPurchaseBlocked) {
      _isSubmitting = false;
      _showErrorSnackbar('Subscription plan is unavailable.');
      return;
    }
    if (eligibility.isRedeemed) {
      _isSubmitting = false;
      errorMessage.value = 'This referral code has already been redeemed.';
      _showErrorSnackbar(errorMessage.value);
      return;
    }

    errorMessage.value = '';
    isProcessing.value = true;

    try {
      final PurchaseOutcome outcome;
      if (GetPlatform.isIOS && _isEligibleForOffer) {
        await _redeemIosOfferCode();
        _isSubmitting = false;
        return;
      } else {
        outcome = await _purchaseService.purchasePackage(
          _package!,
          selectedOption.value,
        );
      }

      print('🟢 purchasePackage returned: ${outcome.result}');
      if (outcome.result == PurchaseResult.error) {
        _showErrorSnackbar(
          outcome.errorMessage ??
              'Unable to complete purchase. Please try again.',
        );
      }
      await _handleOutcome(outcome);
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.ineligibleError) {
        // Not eligible for the promo per Apple's own rules — fall back to full price
        print(
          'ℹ️ Not eligible for promo offer, falling back to full price',
        );
        // outcome = await _purchaseService.purchasePackage(
        //   _package!,
        //   selectedOption.value,
        // );
      } else {
        rethrow;
      }
    } catch (e, stack) {
      // ── was silently swallowing the real error — fixed ──
      print('❌ Purchase error: $e');
      debugPrintStack(stackTrace: stack);
      errorMessage.value = 'Payment failed. Please try again.';
      _showErrorSnackbar(errorMessage.value);
    } finally {
      isProcessing.value = false;
      _isSubmitting = false;
    }
  }

  Future<void> _handleOutcome(PurchaseOutcome outcome) async {
    switch (outcome.result) {
      case PurchaseResult.success:
        if (_isEligibleForOffer) {
          // await SubscriptionService().confirmPurchaseWithBackend();
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



*/

/*
UI Button
    |
    v
SubscriptionConfirmController
    |
    |---- OfferType.none
    |        |
    |        --> purchasePackage()
    |
    |---- OfferType.referral
    |        |
    |        --> iOS: App Store redeem code
    |        --> Android: purchaseWithAndroidOffer()
    |
    |---- OfferType.promo
    |        |
    |        --> iOS: purchaseWithDiscount()
    |        --> Android: purchasePackage()
    |
    |---- OfferType.foundingMum
             |
             --> iOS: purchaseWithDiscount()
             --> Android: purchaseWithAndroidOffer()

                    |
                    v

              PurchaseService

                    |
                    v

              RevenueCat SDK

                    |
                    v

             Apple App Store / Google Play

             */
