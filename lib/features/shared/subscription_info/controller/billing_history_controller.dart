// billing_history_controller.dart
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/controller_export.dart';
import '../../subscription_upgrade/service/purchase_service.dart';

class BillingHistoryController extends GetxController {
  final PurchaseService _purchaseService = PurchaseService.to;

  Future<void> openStorePurchaseHistory() async {
    if (_purchaseService.customerInfo.value == null) {
      await _purchaseService.refreshCustomerInfo();
    }
    final store = _purchaseService.activeStore;
    final url = switch (store) {
      Store.appStore => 'https://apps.apple.com/account/subscriptions',
      Store.playStore => 'https://play.google.com/store/account/subscriptions',
      _ => null, // promotional/stripe/etc — no store deep link
    };
    if (url == null) {
      Snack.showError(
        'This subscription isn\'t managed through the app store.',
      );
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  // TODO once backend adds an endpoint: replace the screen's static content
  // with a fetched list, e.g. GET /api/subscriptions/history returning
  // [{ productId, purchaseDate, amount, status }, ...]
}
