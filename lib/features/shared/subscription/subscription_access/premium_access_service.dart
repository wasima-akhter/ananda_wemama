import 'package:flutter/foundation.dart';

import '../../../../app/service_export.dart';
import '../subscription_upgrade/service/purchase_service.dart';

class PremiumAccessService extends GetxService {
  static PremiumAccessService get to => Get.find();

  final PurchaseService _purchaseService = PurchaseService.to;

  static final bool _kFakePremiumEnabled = GetPlatform.isAndroid;

  final RxBool _fakePremiumOverride = false.obs;

  bool get isFakePremiumActive =>
      _kFakePremiumEnabled && _fakePremiumOverride.value;

  void debugSetFakePremium(bool enabled) {
    if (!_kFakePremiumEnabled) return;
    print('🧪 FAKE_PREMIUM set to $enabled');
    _fakePremiumOverride.value = enabled;
    _recompute();
  }

  final RxBool isReady = false.obs;
  final RxBool isPremiumUser = false.obs;

  Worker? _readyWorker;
  Worker? _entitlementWorker;
  Worker? _fakeWorker;

  @override
  void onInit() {
    super.onInit();

    print('═══════════════════════════════════════');
    print('🎯 [PremiumAccessService] onInit() START');
    print('═══════════════════════════════════════');

    // ✅ Check initial customer info
    if (_purchaseService.customerInfo.value != null) {
      isReady.value = true;
      print('✅ [PremiumAccessService] customerInfo already available');
    } else {
      print('⏳ [PremiumAccessService] customerInfo NOT available yet');
    }

    _recompute();
    _printCurrentState('After initial _recompute()');

    // ✅ Listen for customerInfo changes
    _readyWorker = ever(_purchaseService.customerInfo, (info) {
      print('🔄 [PremiumAccessService] customerInfo CHANGED');
      print('   info != null: ${info != null}');
      if (info != null) {
        isReady.value = true;
        print('✅ [PremiumAccessService] isReady set to TRUE');
      }
      _recompute();
      _printCurrentState('After customerInfo change');
    });

    // ✅ Listen for entitlement changes
    _entitlementWorker = ever(_purchaseService.isActive, (isActive) {
      print('🔄 [PremiumAccessService] isActive CHANGED to: $isActive');
      _recompute();
      _printCurrentState('After isActive change');
    });

    // ✅ Listen for fake premium changes
    _fakeWorker = ever(_fakePremiumOverride, (fake) {
      print('🔄 [PremiumAccessService] _fakePremiumOverride CHANGED to: $fake');
      _recompute();
      _printCurrentState('After fake premium change');
    });

    print('═══════════════════════════════════════');
    print('🎯 [PremiumAccessService] onInit() DONE');
    print('═══════════════════════════════════════\n');
  }

  /// Manually verify premium status by checking multiple sources
  Future<bool> verifyPremiumStatusManually() async {
    print('\n🔍 [verifyPremiumStatusManually] START');

    // Force refresh from backend
    await _purchaseService.refreshCustomerInfo();

    final customerInfo = _purchaseService.customerInfo.value;
    final isActiveViaService = _purchaseService.isActive.value;
    final hasEntitlements =
        customerInfo?.activeSubscriptions.isNotEmpty ?? false;

    print('   After refresh:');
    print('   - purchaseService.isActive: $isActiveViaService');
    print('   - activeSubscriptions: ${customerInfo?.activeSubscriptions}');
    print('   - hasEntitlements: $hasEntitlements');

    final finalStatus = isActiveViaService || hasEntitlements;
    print('   → FINAL VERIFIED STATUS: $finalStatus\n');

    return finalStatus;
  }

  /// Print current state for debugging
  void _printCurrentState(String context) {
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📊 [PremiumAccessService] STATE: $context');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('  isReady.value: ${isReady.value}');
    print('  isPremiumUser.value: ${isPremiumUser.value}');
    print('  isPremiumUserNow: $isPremiumUserNow');
    print(
      '  customerInfo available: ${_purchaseService.customerInfo.value != null}',
    );
    print('  purchaseService.isActive: ${_purchaseService.isActive.value}');
    print('  isFakePremiumActive: $isFakePremiumActive');
    print('  Platform: ${GetPlatform.isAndroid ? "Android" : "iOS"}');
    print('  kDebugMode: $kDebugMode');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }

  @override
  void onClose() {
    print('🔴 [PremiumAccessService] onClose() - disposing workers');
    _readyWorker?.dispose();
    _entitlementWorker?.dispose();
    _fakeWorker?.dispose();
    super.onClose();
  }

  bool get isPremiumUserNow => isPremiumUser.value;

  Future<bool> refreshPremiumStatus() async {
    print('\n🔄 [PremiumAccessService.refreshPremiumStatus] START');

    // Force purchase service to refresh
    await _purchaseService.refreshCustomerInfo();

    // Wait a moment for data to settle
    await Future.delayed(const Duration(milliseconds: 500));

    _recompute();
    _printCurrentState('After refreshPremiumStatus()');

    print('🔄 [PremiumAccessService.refreshPremiumStatus] END');
    print('   Final status: isPremiumUserNow = $isPremiumUserNow\n');

    return isPremiumUserNow;
  }

  void _recompute() {
    final bool wasActive = isPremiumUser.value;

    if (GetPlatform.isIOS) {
      print('📱 [iOS Premium Recompute]');

      final serviceActive = _purchaseService.isActive.value;
      final customerInfo = _purchaseService.customerInfo.value;
      final hasEntitlements =
          customerInfo?.activeSubscriptions.isNotEmpty ?? false;

      print('   purchaseService.isActive: $serviceActive');
      print('   hasActiveSubscriptions: $hasEntitlements');

      // ✅ PRIMARY: Use purchaseService.isActive
      // ✅ FALLBACK: Check activeSubscriptions directly
      isPremiumUser.value = serviceActive || hasEntitlements;

      print('   → isPremiumUser: ${isPremiumUser.value}');

      // Force enable in debug for testing
      if (kDebugMode) {
        isPremiumUser.value = true;
        print('🧪 DEBUG: Force enabled premium');
      }
    } else {
      // Android path
      isPremiumUser.value =
          isFakePremiumActive || _purchaseService.isActive.value;
      print('🤖 [Android Premium Recompute]');
      print('   → isPremiumUser: ${isPremiumUser.value}');
    }

    if (wasActive != isPremiumUser.value) {
      print('⚠️  STATUS CHANGED: $wasActive → ${isPremiumUser.value}');
    }
  }

  /// Verify premium with max retries and detailed logging
  Future<bool> verifyPremiumStatusWithRetry({int maxAttempts = 3}) async {
    print('\n🔍 [verifyPremiumStatusWithRetry] START (iOS fallback)');

    for (int i = 0; i < maxAttempts; i++) {
      print('   Attempt ${i + 1}/$maxAttempts');

      await _purchaseService.refreshCustomerInfo();
      await Future.delayed(const Duration(milliseconds: 300));

      final customerInfo = _purchaseService.customerInfo.value;
      final isActive = _purchaseService.isActive.value;
      final hasEntitlements =
          customerInfo?.activeSubscriptions.isNotEmpty ?? false;

      print('     - isActive: $isActive');
      print('     - hasEntitlements: $hasEntitlements');

      if (isActive || hasEntitlements) {
        print('✅ [verifyPremiumStatusWithRetry] CONFIRMED PREMIUM\n');
        return true;
      }
    }

    print('❌ [verifyPremiumStatusWithRetry] NOT PREMIUM (all attempts)\n');
    return false;
  }

  /// Call this in your SessionNavigator to debug
  void printFullState() {
    _printCurrentState('MANUAL DEBUG CHECK');
  }

  // For UI
  /// Get premium status with iOS fallback verification
  /// Used by UI widgets that need reliable premium status
  Future<bool> getPremiumStatusWithFallback() async {
    // ✅ PRIMARY: If already determined to be premium, return true
    if (isPremiumUser.value) {
      print('✅ [getPremiumStatusWithFallback] Already premium');
      return true;
    }

    // ❌ PRIMARY failed, but we're ready — might be false negative on iOS
    if (!isReady.value) {
      print('⏳ [getPremiumStatusWithFallback] Not ready yet');
      return false;
    }

    // ✅ FALLBACK: Verify manually for iOS
    if (GetPlatform.isIOS) {
      print('🔍 [getPremiumStatusWithFallback] iOS fallback verification...');
      return await verifyPremiumStatusWithRetry(maxAttempts: 2);
    }

    // Already checked and false — return false
    return false;
  }

  //
}
