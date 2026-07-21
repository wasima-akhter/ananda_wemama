// core/services/purchase_service.dart
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/config/app_info.dart';

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
      revenueCatPublicKeyGoogolePlay, // use platform logic
    );
    await Purchases.configure(configuration);

    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
    await refreshCustomerInfo();
    return this;
  }

  /// Call after login, so purchases attach to the right backend user
  Future<void> loginRevenueCatUser(String appUserId) async {
    try {
      await Purchases.logIn(appUserId);
      await refreshCustomerInfo();
    } catch (e) {
      log('RC login error: $e');
    }
  }

  Future<void> logoutRevenueCatUser() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      log('RC logout error: $e');
    }
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
    customerInfo.value = info;
    isActive.value = info.entitlements.all[entitlementId]?.isActive ?? false;
  }

  Future<void> refreshCustomerInfo() async {
    try {
      final info = await Purchases.getCustomerInfo();
      _onCustomerInfoUpdated(info);
    } catch (e) {
      log('getCustomerInfo error: $e');
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (e) {
      log('getOfferings error: $e');
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
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome(PurchaseResult.userCancelled);
      }
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
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome(PurchaseResult.userCancelled);
      }
      return PurchaseOutcome(
        PurchaseResult.error,
        errorMessage: e.message ?? 'Purchase failed',
      );
    }
  }

  //
  Future<PurchaseOutcome> purchaseWithAndroidOffer(
    Package package,
    String basePlanId,
    String offerId,
  ) async {
    final targetId = '$basePlanId:$offerId';
    final option = package.storeProduct.subscriptionOptions?.firstWhereOrNull(
      (o) => o.id == targetId,
    );

    if (option == null) {
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

  Future<PurchaseOutcome> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      _onCustomerInfoUpdated(info);
      final active = info.entitlements.all[entitlementId]?.isActive ?? false;
      return PurchaseOutcome(
        active ? PurchaseResult.success : PurchaseResult.error,
        customerInfo: info,
        errorMessage: active
            ? null
            : 'No active subscription found for this account',
      );
    } on PlatformException catch (e) {
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
  });
}

extension PurchaseServiceInfo on PurchaseService {
  Future<SubscriptionDisplayInfo?> getDisplayInfo() async {
    final info = customerInfo.value;
    if (info == null) return null;

    final entitlement = info.entitlements.all[PurchaseService.entitlementId];
    if (entitlement == null || !entitlement.isActive) return null;

    log('productIdentifier: ${entitlement.productIdentifier}');

    String? priceString;
    try {
      final offerings = await Purchases.getOfferings();
      final pkg = offerings.current?.availablePackages.firstWhereOrNull(
        (p) => p.storeProduct.identifier == entitlement.productIdentifier,
      );
      priceString = pkg?.storeProduct.priceString;
    } catch (e) {
      debugPrint('Could not resolve price: $e');
    }

    return SubscriptionDisplayInfo(
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
    if (url == null) {
      // Fallback: platform default subscription settings
      final fallbackUrl = GetPlatform.isIOS
          ? 'https://apps.apple.com/account/subscriptions'
          : 'https://play.google.com/store/account/subscriptions';
      await launchUrl(
        Uri.parse(fallbackUrl),
        mode: LaunchMode.externalApplication,
      );
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
