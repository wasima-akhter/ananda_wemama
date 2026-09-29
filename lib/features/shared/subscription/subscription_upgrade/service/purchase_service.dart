// core/services/purchase_service.dart
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/config/app_info.dart';
import '../type/offer_type.dart';

enum PurchaseResult { success, userCancelled, error, pending }

class PurchaseOutcome {
  final PurchaseResult result;
  final CustomerInfo? customerInfo;
  final String? errorMessage;

  PurchaseOutcome(this.result, {this.customerInfo, this.errorMessage});
}

class PurchaseService {
  static PurchaseService get to => Get.find<PurchaseService>();
  static const String entitlementId = SubscriptionConstants.entitlementId;

  final RxBool isActive = false.obs;
  final Rx<CustomerInfo?> customerInfo = Rx<CustomerInfo?>(null);

  Future<PurchaseService> init() async {
    // Call this once at app start, after you know the logged-in user's id
    await Purchases.setLogLevel(
      LogLevel.debug,
    ); // switch to LogLevel.info in prod
    PurchasesConfiguration configuration = PurchasesConfiguration(
      // "YOUR_REVENUECAT_API_KEY_IOS_OR_ANDROID",
      revenueCatPublicKey, // use platform lonfirmgic
    );
    await Purchases.configure(configuration);

    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
    await refreshCustomerInfo();
    return this;
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
    customerInfo.value = info;
    isActive.value = info.entitlements.all[entitlementId]?.isActive ?? false;
  }

  Future<void> loginRevenueCatUser(String appUserId) async {
    try {
      await Purchases.logIn(appUserId);
      await refreshCustomerInfo();
    } catch (e) {
      print('RC login error: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logoutRevenueCatUser() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      print('RC logout error: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> refreshCustomerInfo() async {
    try {
      final info = await Purchases.getCustomerInfo();
      _onCustomerInfoUpdated(info);
    } catch (e) {
      print('getCustomerInfo error: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (e) {
      print('getOfferings error: $e');
      Get.snackbar(
        'Error',
        e.message ?? e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Standard purchase (no discount tier)
  // purchase_service.dart
  Future<PurchaseOutcome> purchasePackage(
    Package package,
    SubscriptionOption? option,
  ) async {
    try {
      late CustomerInfo customerInfo;

      if (GetPlatform.isAndroid && option != null) {
        // Android: purchase the specific base plan + offer combo
        final result = await Purchases.purchaseSubscriptionOption(option);
        customerInfo = result.customerInfo;
      } else {
        // iOS (and Android fallback if no option resolved): plain purchase
        // Apple promotional offers use a different signed-offer mechanism —
        // wire that in separately later when Apple setup happens.
        final result = await Purchases.purchasePackage(package);
        customerInfo = result.customerInfo;
      }

      _onCustomerInfoUpdated(customerInfo);
      final active =
          customerInfo.entitlements.all[entitlementId]?.isActive ?? false;

      return PurchaseOutcome(
        active ? PurchaseResult.success : PurchaseResult.pending,
        customerInfo: customerInfo,
      );
    } on PlatformException catch (e) {
      // final code = PurchasesErrorHelper.getErrorCode(e);
      // if (code == PurchasesErrorCode.purchaseCancelledError) {
      //   return PurchaseOutcome(PurchaseResult.userCancelled);
      // }
      // return PurchaseOutcome(
      //   PurchaseResult.error,
      //   errorMessage: e.message ?? 'Purchase failed',
      // );

      final code = PurchasesErrorHelper.getErrorCode(e);

      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome(PurchaseResult.userCancelled);
      }

      Get.snackbar(
        'Payment Error',
        e.message ?? e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

      return PurchaseOutcome(
        PurchaseResult.error,
        errorMessage: e.message ?? 'Purchase failed',
      );
    }
  }

  /// iOS promotional-offer purchase (referral discount tier)
  Future<PurchaseOutcome> purchaseWithDiscount(
    Package package,
    PromotionalOffer promoOffer,
  ) async {
    try {
      final result = await Purchases.purchaseDiscountedPackage(
        package,
        promoOffer,
      );
      _onCustomerInfoUpdated(result.customerInfo);
      final active =
          result.customerInfo.entitlements.all[entitlementId]?.isActive ??
          false;
      return PurchaseOutcome(
        active ? PurchaseResult.success : PurchaseResult.pending,
        customerInfo: result.customerInfo,
      );
    } on PlatformException catch (e) {
      // final code = PurchasesErrorHelper.getErrorCode(e);
      // if (code == PurchasesErrorCode.purchaseCancelledError) {
      //   return PurchaseOutcome(PurchaseResult.userCancelled);
      // }
      // return PurchaseOutcome(
      //   PurchaseResult.error,
      //   errorMessage: e.message ?? 'Purchase failed',
      // );

      final code = PurchasesErrorHelper.getErrorCode(e);

      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome(PurchaseResult.userCancelled);
      }

      Get.snackbar(
        'Payment Error',
        e.message ?? e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

      return PurchaseOutcome(
        PurchaseResult.error,
        errorMessage: e.message ?? 'Purchase failed',
      );
    }
  }

  //

  /*
  Future<PurchaseOutcome> purchaseWithAndroidOffer(
    Package package,
    String basePlanId,
    String offerId,
  ) async {
    final targetId = '$basePlanId:$offerId';
    final option = package.storeProduct.subscriptionOptions?.firstWhereOrNull(
      (o) => o.id == targetId,
    );

    // if (option == null) {
    //   return PurchaseOutcome(
    //     PurchaseResult.error,
    //     errorMessage: 'Offer not available',
    //   );
    // }
    if (option == null) {
      Get.snackbar(
        'Error',
        'Offer not available',
        snackPosition: SnackPosition.BOTTOM,
      );

      return PurchaseOutcome(
        PurchaseResult.error,
        errorMessage: 'Offer not available',
      );
    }

    final result = await Purchases.purchaseSubscriptionOption(option);
    _onCustomerInfoUpdated(result.customerInfo);
    final active =
        result.customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    return PurchaseOutcome(
      active ? PurchaseResult.success : PurchaseResult.pending,
      customerInfo: result.customerInfo,
    );
  }
*/

  Future<PurchaseOutcome> purchaseWithAndroidOffer(
    Package package,
    OfferType offerType,
  ) async {
    final options = package.storeProduct.subscriptionOptions ?? [];

    SubscriptionOption? option;

    switch (offerType) {
      case OfferType.referral:
        option = GetPlatform.isAndroid
            ? options.firstWhereOrNull((o) => o.id.contains('referral'))
            : options.firstWhereOrNull((o) => o.id.startsWith('referral_'));
        break;

      case OfferType.foundingMum:
        option = GetPlatform.isAndroid
            ? options.firstWhereOrNull((o) => o.id.contains('founding'))
            : options.firstWhereOrNull((o) => o.id.startsWith('founding_'));
        break;

      case OfferType.promo:
        option = GetPlatform.isAndroid
            ? options.firstWhereOrNull((o) => o.id.contains('promo'))
            : options.firstWhereOrNull((o) => o.id.startsWith('promo_'));
        break;

      case OfferType.none:
        option = package.storeProduct.defaultOption ?? options.firstOrNull;
        break;
    }
    if (option == null) {
      return PurchaseOutcome(
        PurchaseResult.error,
        errorMessage: 'Offer not available',
      );
    }

    print('🟢 Android purchasing option=${option.id}');

    final result = await Purchases.purchase(
      PurchaseParams.subscriptionOption(option),
    );

    print('🟢 Purchasing option=${option.id}');

    for (final phase in option.pricingPhases) {
      print(
        'Phase: ${phase.price.formatted}, '
        'Period=${phase.billingPeriod}, '
        'Cycles=${phase.billingCycleCount}',
      );
    }

    /*
    Referral

Purchasing option=monthly-auto:referral-50-1month
Phase: BDT 250.00
Phase: BDT 500.00

Funding Mum

Purchasing option=monthly-auto:founding-mum-100
Phase: Free
Phase: BDT 500.00
*/

    _onCustomerInfoUpdated(result.customerInfo);

    final active =
        result.customerInfo.entitlements.all[entitlementId]?.isActive ?? false;

    return PurchaseOutcome(
      active ? PurchaseResult.success : PurchaseResult.pending,
      customerInfo: result.customerInfo,
    );
  }

  Future<PurchaseOutcome> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      _onCustomerInfoUpdated(info);
      final active = info.entitlements.all[entitlementId]?.isActive ?? false;

      if (!active) {
        Get.snackbar(
          'Restore Error',
          'No active subscription found for this account',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return PurchaseOutcome(
        active ? PurchaseResult.success : PurchaseResult.error,
        customerInfo: info,
        errorMessage: active
            ? null
            : 'No active subscription found for this account',
      );
    } on PlatformException catch (e) {
      // return PurchaseOutcome(
      //   PurchaseResult.error,
      //   errorMessage: e.message ?? 'Restore failed',
      // );
      Get.snackbar(
        'Restore Error',
        e.message ?? e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

      return PurchaseOutcome(
        PurchaseResult.error,
        errorMessage: e.message ?? 'Restore failed',
      );
    }
  }

  Store? get activeStore =>
      customerInfo.value?.entitlements.all[entitlementId]?.store;
}

class SubscriptionDisplayInfo {
  final String productIdentifier;
  final String planName;
  final String priceString;
  final DateTime? expiresAt;
  final bool willRenew;
  final String? managementUrl; // RC gives this directly!
  final PurchaseResult status; // active / expired / billingIssue

  final Store store; // see #3

  SubscriptionDisplayInfo({
    required this.planName,
    required this.priceString,
    this.expiresAt,
    required this.willRenew,
    this.managementUrl,
    required this.status,
    required this.store,
    required this.productIdentifier,
  });
}

extension PurchaseServiceInfo on PurchaseService {
  Future<SubscriptionDisplayInfo?> getDisplayInfo() async {
    print('getDisplayInfo: started');

    final info = customerInfo.value;

    print('getDisplayInfo: customerInfo = $info');

    if (info == null) {
      print('getDisplayInfo: customerInfo is null, returning null');
      return null;
    }

    print('getDisplayInfo: all entitlements = ${info.entitlements.all}');

    final entitlement = info.entitlements.all[PurchaseService.entitlementId];

    print('getDisplayInfo: entitlementId = ${PurchaseService.entitlementId}');

    print('getDisplayInfo: entitlement = $entitlement');

    if (entitlement == null) {
      print('getDisplayInfo: entitlement is null, returning null');
      return null;
    }

    print('getDisplayInfo: entitlement.isActive = ${entitlement.isActive}');

    if (!entitlement.isActive) {
      print('getDisplayInfo: entitlement inactive, returning null');
      return null;
    }

    print(
      'getDisplayInfo: productIdentifier = ${entitlement.productIdentifier}',
    );

    String? priceString;

    try {
      print('getDisplayInfo: fetching offerings...');

      final offerings = await Purchases.getOfferings();

      print('getDisplayInfo: offerings = $offerings');

      print('getDisplayInfo: current offering = ${offerings.current}');

      print(
        'getDisplayInfo: available packages = ${offerings.current?.availablePackages}',
      );

      final pkg = offerings.current?.availablePackages.firstWhereOrNull(
        (p) => p.storeProduct.identifier == entitlement.productIdentifier,
      );

      print('getDisplayInfo: matched package = $pkg');

      print('getDisplayInfo: matched storeProduct = ${pkg?.storeProduct}');

      priceString = pkg?.storeProduct.priceString;

      print('getDisplayInfo: priceString = $priceString');
    } catch (e, stack) {
      print('getDisplayInfo: Could not resolve price: $e');
      print('getDisplayInfo: stack = $stack');
      print('Could not resolve price: $e');
    }

    return SubscriptionDisplayInfo(
      productIdentifier: entitlement.productIdentifier,
      store: entitlement.store,
      planName: entitlement
          .productIdentifier, // map this to a friendly name in your UI
      priceString: priceString ?? '',
      expiresAt: entitlement.expirationDate != null
          ? DateTime.tryParse(entitlement.expirationDate!)
          : null,
      willRenew: entitlement.willRenew,
      managementUrl:
          info.managementURL, // ✅ RC gives the correct App Store/Play Store URL
      status: PurchaseResult.success,
    );
  }

  Future<void> openManageSubscription() async {
    final url = customerInfo.value?.managementURL;

    if (url != null) {
      final launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw Exception(
          'Could not open subscription settings. Please try again.',
        );
      }
      return;
    }

    // No managementURL from RC — fall back based on the entitlement's actual store,
    // not just device platform.
    final store = activeStore;
    final fallbackUrl = switch (store) {
      Store.appStore => 'https://apps.apple.com/account/subscriptions',
      Store.playStore => 'https://play.google.com/store/account/subscriptions',
      _ => null, // promotional/stripe/amazon — no store deep link exists
    };

    if (fallbackUrl == null) {
      throw Exception("This subscription isn't managed through the app store.");
    }

    final launched = await launchUrl(
      Uri.parse(fallbackUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      throw Exception(
        'Could not open subscription settings. Please try again.',
      );
    }
  }
}

/*
Product:
premium_monthly

Base plan:
monthly-auto

Offers:
1. founding-mum-100
   - First phase: Free
   - Duration: 3 months
   - Then: BDT 500/month

2. referral-50-1month
   - First phase: BDT 250
   - Duration: 1 month
   - Then: BDT 500/month

3. Default:
   - BDT 500/month

   */
