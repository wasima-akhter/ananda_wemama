import 'package:flutter/foundation.dart';

import '../../../../app/service_export.dart';
import '../subscription_upgrade/service/purchase_service.dart';

class PremiumAccessService extends GetxService {
  static PremiumAccessService get to => Get.find();

  final PurchaseService _purchaseService = PurchaseService.to;

  static final bool _kFakePremiumEnabled = kDebugMode || GetPlatform.isAndroid;
  final RxBool _fakePremiumOverride = true.obs;

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
    isPremiumUser.value =
        isFakePremiumActive || _purchaseService.isActive.value;
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
