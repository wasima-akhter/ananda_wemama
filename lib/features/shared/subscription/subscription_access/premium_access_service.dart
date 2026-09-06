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
    debugPrint('🧪 FAKE_PREMIUM set to $enabled');
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

    debugPrint('═══════════════════════════════════════');
    debugPrint('🎯 [PremiumAccessService] onInit() START');
    debugPrint('═══════════════════════════════════════');

    // ✅ Check initial customer info
    if (_purchaseService.customerInfo.value != null) {
      isReady.value = true;
      debugPrint('✅ [PremiumAccessService] customerInfo already available');
    } else {
      debugPrint('⏳ [PremiumAccessService] customerInfo NOT available yet');
    }

    _recompute();
    _printCurrentState('After initial _recompute()');

    // ✅ Listen for customerInfo changes
    _readyWorker = ever(_purchaseService.customerInfo, (info) {
      debugPrint('🔄 [PremiumAccessService] customerInfo CHANGED');
      debugPrint('   info != null: ${info != null}');
      if (info != null) {
        isReady.value = true;
        debugPrint('✅ [PremiumAccessService] isReady set to TRUE');
      }
      _recompute();
      _printCurrentState('After customerInfo change');
    });

    // ✅ Listen for entitlement changes
    _entitlementWorker = ever(_purchaseService.isActive, (isActive) {
      debugPrint('🔄 [PremiumAccessService] isActive CHANGED to: $isActive');
      _recompute();
      _printCurrentState('After isActive change');
    });

    // ✅ Listen for fake premium changes
    _fakeWorker = ever(_fakePremiumOverride, (fake) {
      debugPrint(
        '🔄 [PremiumAccessService] _fakePremiumOverride CHANGED to: $fake',
      );
      _recompute();
      _printCurrentState('After fake premium change');
    });

    debugPrint('═══════════════════════════════════════');
    debugPrint('🎯 [PremiumAccessService] onInit() DONE');
    debugPrint('═══════════════════════════════════════\n');
  }

  /// Manually verify premium status by checking multiple sources
  Future<bool> verifyPremiumStatusManually() async {
    debugPrint('\n🔍 [verifyPremiumStatusManually] START');

    // Force refresh from backend
    await _purchaseService.refreshCustomerInfo();

    final customerInfo = _purchaseService.customerInfo.value;
    final isActiveViaService = _purchaseService.isActive.value;
    final hasEntitlements =
        customerInfo?.activeSubscriptions.isNotEmpty ?? false;

    debugPrint('   After refresh:');
    debugPrint('   - purchaseService.isActive: $isActiveViaService');
    debugPrint(
      '   - activeSubscriptions: ${customerInfo?.activeSubscriptions}',
    );
    debugPrint('   - hasEntitlements: $hasEntitlements');

    final finalStatus = isActiveViaService || hasEntitlements;
    debugPrint('   → FINAL VERIFIED STATUS: $finalStatus\n');

    return finalStatus;
  }

  /// Print current state for debugging
  void _printCurrentState(String context) {
    debugPrint('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📊 [PremiumAccessService] STATE: $context');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('  isReady.value: ${isReady.value}');
    debugPrint('  isPremiumUser.value: ${isPremiumUser.value}');
    debugPrint('  isPremiumUserNow: $isPremiumUserNow');
    debugPrint(
      '  customerInfo available: ${_purchaseService.customerInfo.value != null}',
    );
    debugPrint(
      '  purchaseService.isActive: ${_purchaseService.isActive.value}',
    );
    debugPrint('  isFakePremiumActive: $isFakePremiumActive');
    debugPrint('  Platform: ${GetPlatform.isAndroid ? "Android" : "iOS"}');
    debugPrint('  kDebugMode: $kDebugMode');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }

  @override
  void onClose() {
    debugPrint('🔴 [PremiumAccessService] onClose() - disposing workers');
    _readyWorker?.dispose();
    _entitlementWorker?.dispose();
    _fakeWorker?.dispose();
    super.onClose();
  }

  bool get isPremiumUserNow => isPremiumUser.value;

  Future<bool> refreshPremiumStatus() async {
    debugPrint('\n🔄 [PremiumAccessService.refreshPremiumStatus] START');

    // Force purchase service to refresh
    await _purchaseService.refreshCustomerInfo();

    // Wait a moment for data to settle
    await Future.delayed(const Duration(milliseconds: 500));

    _recompute();
    _printCurrentState('After refreshPremiumStatus()');

    debugPrint('🔄 [PremiumAccessService.refreshPremiumStatus] END');
    debugPrint('   Final status: isPremiumUserNow = $isPremiumUserNow\n');

    return isPremiumUserNow;
  }

  void _recompute() {
    final bool wasActive = isPremiumUser.value;

    if (GetPlatform.isIOS) {
      debugPrint('📱 [iOS Premium Recompute]');

      final serviceActive = _purchaseService.isActive.value;
      final customerInfo = _purchaseService.customerInfo.value;
      final hasEntitlements =
          customerInfo?.activeSubscriptions.isNotEmpty ?? false;

      debugPrint('   purchaseService.isActive: $serviceActive');
      debugPrint('   hasActiveSubscriptions: $hasEntitlements');

      // ✅ PRIMARY: Use purchaseService.isActive
      // ✅ FALLBACK: Check activeSubscriptions directly
      isPremiumUser.value = serviceActive || hasEntitlements;

      debugPrint('   → isPremiumUser: ${isPremiumUser.value}');

      // Force enable in debug for testing
      if (kDebugMode) {
        isPremiumUser.value = true;
        debugPrint('🧪 DEBUG: Force enabled premium');
      }
    } else {
      // Android path
      isPremiumUser.value =
          isFakePremiumActive || _purchaseService.isActive.value;
      debugPrint('🤖 [Android Premium Recompute]');
      debugPrint('   → isPremiumUser: ${isPremiumUser.value}');
    }

    if (wasActive != isPremiumUser.value) {
      debugPrint('⚠️  STATUS CHANGED: $wasActive → ${isPremiumUser.value}');
    }
  }

  /// Verify premium with max retries and detailed logging
  Future<bool> verifyPremiumStatusWithRetry({int maxAttempts = 3}) async {
    debugPrint('\n🔍 [verifyPremiumStatusWithRetry] START (iOS fallback)');

    for (int i = 0; i < maxAttempts; i++) {
      debugPrint('   Attempt ${i + 1}/$maxAttempts');

      await _purchaseService.refreshCustomerInfo();
      await Future.delayed(const Duration(milliseconds: 300));

      final customerInfo = _purchaseService.customerInfo.value;
      final isActive = _purchaseService.isActive.value;
      final hasEntitlements =
          customerInfo?.activeSubscriptions.isNotEmpty ?? false;

      debugPrint('     - isActive: $isActive');
      debugPrint('     - hasEntitlements: $hasEntitlements');

      if (isActive || hasEntitlements) {
        debugPrint('✅ [verifyPremiumStatusWithRetry] CONFIRMED PREMIUM\n');
        return true;
      }
    }

    debugPrint('❌ [verifyPremiumStatusWithRetry] NOT PREMIUM (all attempts)\n');
    return false;
  }

  /// Call this in your SessionNavigator to debug
  void debugPrintFullState() {
    _printCurrentState('MANUAL DEBUG CHECK');
  }

  // For UI
  /// Get premium status with iOS fallback verification
  /// Used by UI widgets that need reliable premium status
  Future<bool> getPremiumStatusWithFallback() async {
    // ✅ PRIMARY: If already determined to be premium, return true
    if (isPremiumUser.value) {
      debugPrint('✅ [getPremiumStatusWithFallback] Already premium');
      return true;
    }

    // ❌ PRIMARY failed, but we're ready — might be false negative on iOS
    if (!isReady.value) {
      debugPrint('⏳ [getPremiumStatusWithFallback] Not ready yet');
      return false;
    }

    // ✅ FALLBACK: Verify manually for iOS
    if (GetPlatform.isIOS) {
      debugPrint(
        '🔍 [getPremiumStatusWithFallback] iOS fallback verification...',
      );
      return await verifyPremiumStatusWithRetry(maxAttempts: 2);
    }

    // Already checked and false — return false
    return false;
  }

  //
}
