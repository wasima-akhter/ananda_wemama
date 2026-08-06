import 'package:flutter/foundation.dart';

import '../../../../app/service_export.dart';
import '../subscription_upgrade/service/purchase_service.dart';

class PremiumAccessService extends GetxService {
  static PremiumAccessService get to => Get.find();

  final PurchaseService _purchaseService = PurchaseService.to;

  // Fake-premium is a QA/dev aid only. It is intentionally scoped to
  // Android — debug AND release — so testers can flip between free/premium
  // UX without a real subscription. iOS NEVER gets this override, in any
  // build type: premium status there must always come from the real store
  // entitlement so it can't silently drift from what the App Store says.

  static final bool _kFakePremiumEnabled =
      GetPlatform.isAndroid; // static final bool _kFakePremiumEnabled = false;

  //<--- to enable the real one for android. ios is already real enabled

  // Defaults to "use real access" — NOT forced-premium. Devs must
  // explicitly opt into the fake state via debugSetFakePremium().
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
  final RxBool isPremiumUser =
      false.obs; // <- the single reactive source UI binds to

  Worker? _readyWorker;
  Worker? _entitlementWorker;
  Worker? _fakeWorker;

  @override
  void onInit() {
    super.onInit();

    if (_purchaseService.customerInfo.value != null) isReady.value = true;
    _recompute();

    _readyWorker = ever(_purchaseService.customerInfo, (info) {
      if (info != null) isReady.value = true;
      _recompute();
    });

    _entitlementWorker = ever(_purchaseService.isActive, (_) => _recompute());
    _fakeWorker = ever(_fakePremiumOverride, (_) => _recompute());
  }

  void _recompute() {
    // iOS: real entitlement only, always — never fake, never backend.
    // Android: real entitlement by default, fake toggle can override it
    // for QA purposes.
    isPremiumUser.value = GetPlatform.isIOS
        ? _purchaseService.isActive.value
        : (isFakePremiumActive || _purchaseService.isActive.value);
  }

  @override
  void onClose() {
    _readyWorker?.dispose();
    _entitlementWorker?.dispose();
    _fakeWorker?.dispose();
    super.onClose();
  }

  bool get isPremiumUserNow => isPremiumUser.value;

  Future<bool> refreshPremiumStatus() async {
    await _purchaseService.refreshCustomerInfo();
    _recompute();
    return isPremiumUserNow;
  }
}
