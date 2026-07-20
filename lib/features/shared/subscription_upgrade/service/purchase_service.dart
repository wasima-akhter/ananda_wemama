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
      revenueCatPublicKeyGoogolePlay,
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
  Future<PurchaseOutcome> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
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
}

class SubscriptionDisplayInfo {
  final String planName;
  final String priceString;
  final DateTime? expiresAt;
  final bool willRenew;
  final String? managementUrl; // RC gives this directly!
  final PurchaseResult status; // active / expired / billingIssue

  SubscriptionDisplayInfo({
    required this.planName,
    required this.priceString,
    this.expiresAt,
    required this.willRenew,
    this.managementUrl,
    required this.status,
  });
}

extension PurchaseServiceInfo on PurchaseService {
  SubscriptionDisplayInfo? getDisplayInfo() {
    final info = customerInfo.value;
    if (info == null) return null;

    final entitlement = info.entitlements.all[PurchaseService.entitlementId];
    if (entitlement == null || !entitlement.isActive) return null;

    log('productIdentifier: ${entitlement.productIdentifier}');

    return SubscriptionDisplayInfo(
      planName: entitlement
          .productIdentifier, // map this to a friendly name in your UI
      priceString: '',
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
