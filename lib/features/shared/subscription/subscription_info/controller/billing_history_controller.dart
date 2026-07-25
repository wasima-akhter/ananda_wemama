// billing_history_controller.dart
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/controller_export.dart';
import '../../subscription_upgrade/service/purchase_service.dart';

class BillingHistoryController extends GetxController {
  final PurchaseService _purchaseService = PurchaseService.to;
  final Rx<Store?> store = Rx<Store?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadStore();
  }

  Future<void> _loadStore() async {
    print('BillingHistory: Loading store...');

    if (_purchaseService.customerInfo.value == null) {
      print('BillingHistory: Customer info is null, refreshing...');
      await _purchaseService.refreshCustomerInfo();
    }

    final customerInfo = _purchaseService.customerInfo.value;

    print('BillingHistory: CustomerInfo = $customerInfo');

    if (customerInfo != null) {
      print(
        'BillingHistory: Active subscriptions = ${customerInfo.activeSubscriptions}',
      );

      print(
        'BillingHistory: All purchased products = ${customerInfo.allPurchasedProductIdentifiers}',
      );

      print(
        'BillingHistory: Entitlements = ${customerInfo.entitlements.all.keys}',
      );
    }

    store.value = _purchaseService.activeStore;

    print('BillingHistory: Active Store = ${store.value}');
  }

  bool get isAppStore => store.value == Store.appStore;

  Future<void> openStorePurchaseHistory() async {
    print('BillingHistory: Opening purchase history...');

    final customerInfo = _purchaseService.customerInfo.value;

    print('BillingHistory: Current customer info = $customerInfo');

    if (customerInfo != null) {
      print(
        'BillingHistory: Current active subscriptions = ${customerInfo.activeSubscriptions}',
      );

      print(
        'BillingHistory: Current entitlements = ${customerInfo.entitlements.all}',
      );
    }

    final hasSubscription =
        customerInfo?.activeSubscriptions.isNotEmpty ?? false;

    if (!hasSubscription) {
      Snack.showError("No active subscription found");
      return;
    }
    print('BillingHistory: Store before opening URL = ${store.value}');

    print(
      'Entitlement environment isSandbox: ${customerInfo?.entitlements.all.values.first.isSandbox}',
    );

    final url = switch (store.value) {
      Store.appStore => 'https://apps.apple.com/account/subscriptions',
      Store.playStore => 'https://play.google.com/store/account/subscriptions',
      _ => null,
    };

    if (url == null) {
      print('BillingHistory: No store found');
      Snack.showError(
        'This subscription isn\'t managed through the app store.',
      );
      return;
    }

    print('BillingHistory: Opening URL = $url');

    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
