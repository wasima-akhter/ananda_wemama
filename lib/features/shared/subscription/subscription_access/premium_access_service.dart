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

  void _recompute() {
    final bool wasActive = isPremiumUser.value;

    if (GetPlatform.isIOS) {
      isPremiumUser.value = _purchaseService.isActive.value;
      debugPrint('📱 [PremiumAccessService._recompute] iOS path');
      debugPrint(
        '   purchaseService.isActive: ${_purchaseService.isActive.value}',
      );
      debugPrint('   → isPremiumUser: ${isPremiumUser.value}');

      // ✅ Debug mode force premium
      if (kDebugMode) {
        debugPrint('🧪 [PremiumAccessService] DEBUG MODE DETECTED');
        isPremiumUser.value = true;
        debugPrint(
          '⚠️  [PremiumAccessService] isPremiumUser FORCED to TRUE (debug mode)',
        );
        _printCurrentState('After DEBUG MODE force');
      }
    } else {
      // Android
      isPremiumUser.value =
          isFakePremiumActive || _purchaseService.isActive.value;
      debugPrint('🤖 [PremiumAccessService._recompute] Android path');
      debugPrint('   isFakePremiumActive: $isFakePremiumActive');
      debugPrint(
        '   purchaseService.isActive: ${_purchaseService.isActive.value}',
      );
      debugPrint('   → isPremiumUser: ${isPremiumUser.value}');
    }

    if (wasActive != isPremiumUser.value) {
      debugPrint('⚠️  [PremiumAccessService._recompute] STATUS CHANGED!');
      debugPrint('   Before: $wasActive → After: ${isPremiumUser.value}');
    }
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
    await _purchaseService.refreshCustomerInfo();
    _recompute();
    _printCurrentState('After refreshPremiumStatus()');
    debugPrint('🔄 [PremiumAccessService.refreshPremiumStatus] END\n');
    return isPremiumUserNow;
  }

  /// Call this in your SessionNavigator to debug
  void debugPrintFullState() {
    _printCurrentState('MANUAL DEBUG CHECK');
  }
}
