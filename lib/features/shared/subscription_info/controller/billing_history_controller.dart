// billing_history_controller.dart
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/controller_export.dart';
import '../../subscription_upgrade/service/purchase_service.dart';

class BillingHistoryController extends GetxController {
  final PurchaseService _purchaseService = PurchaseService.to;

  Future<void> openStorePurchaseHistory() async {
    // Google Play's own purchase history — always accurate, no backend needed
    const url = 'https://play.google.com/store/account/subscriptions';
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  // TODO once backend adds an endpoint: replace the screen's static content
  // with a fetched list, e.g. GET /api/subscriptions/history returning
  // [{ productId, purchaseDate, amount, status }, ...]
}
