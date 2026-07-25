import 'package:purchases_flutter/purchases_flutter.dart' hide PurchaseResult;

import '../../../../../app/controller_export.dart';
import '../../subscription_upgrade/service/purchase_service.dart';

// subscription_info_controller.dart
class SubscriptionInfoController extends GetxController {
  final PurchaseService _purchaseService = PurchaseService.to;

  final RxBool isLoading = true.obs;
  final RxBool isRestoring = false.obs;

  final Rx<SubscriptionDisplayInfo?> subInfo = Rx<SubscriptionDisplayInfo?>(
    null,
  );

  final Rxn<StoreProduct> activeProduct = Rxn<StoreProduct>();

  final RxBool pushNotification = true.obs;
  final RxBool communityUpdates = true.obs;
  final RxBool invisibleMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    _loadSubscriptionInfo();

    // keep screen live-updated if status changes while viewing
    ever(_purchaseService.customerInfo, (_) => _loadSubscriptionInfo());
  }

  Future<void> _loadSubscriptionInfo() async {
    try {
      isLoading.value = true;

      await _purchaseService.refreshCustomerInfo();

      final info = await _purchaseService.getDisplayInfo();

      subInfo.value = info;

      if (info != null) {
        await _loadProductInfo(info.productIdentifier);
      } else {
        activeProduct.value = null;
      }
    } catch (e, s) {
      debugPrint('Load subscription info error: $e');
      debugPrintStack(stackTrace: s);

      Snack.showError('Failed to load subscription information.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProductInfo(String productIdentifier) async {
    try {
      final offerings = await _purchaseService.getOfferings();
      // Purchases.getOfferings();

      final product = offerings?.current?.availablePackages
          .firstWhereOrNull(
            (package) => package.storeProduct.identifier == productIdentifier,
          )
          ?.storeProduct;

      activeProduct.value = product;
    } catch (e, s) {
      debugPrint('Load RevenueCat product error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> onManageBilling() async {
    try {
      await _purchaseService.openManageSubscription();
    } catch (e, s) {
      debugPrint('Open manage billing error: $e');
      debugPrintStack(stackTrace: s);

      Snack.showError('Unable to open subscription settings.');
    }
  }

  /// Same destination as manage — Apple/Google don't allow programmatic cancel.
  Future<void> onCancelSubscription() async {
    final store = _purchaseService.activeStore;

    if (store != Store.appStore && store != Store.playStore) {
      Snack.showError(
        "This subscription isn't managed through the app store. "
        "Contact support to cancel.",
      );
      return;
    }

    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Subscription'),
          content: const Text(
            'To cancel, you\'ll be taken to your device\'s subscription settings. '
            'Your plan stays active until the current billing period ends.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Not now'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _purchaseService.openManageSubscription();
      }
    } catch (e, s) {
      debugPrint('Cancel subscription error: $e');
      debugPrintStack(stackTrace: s);

      Snack.showError(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Unable to open subscription settings. Please try again.',
      );
    }
  }

  Future<void> onRestorePurchases() async {
    try {
      isRestoring.value = true;

      final outcome = await _purchaseService.restorePurchases();

      if (outcome.result == PurchaseResult.success) {
        Snack.showSuccess('Subscription restored successfully');
        await _loadSubscriptionInfo();
      } else {
        Snack.showError(outcome.errorMessage ?? 'No active purchases found');
      }
    } catch (e, s) {
      debugPrint('Restore purchases error: $e');
      debugPrintStack(stackTrace: s);

      Snack.showError('Something went wrong while restoring purchases');
    } finally {
      isRestoring.value = false;
    }
  }

  Future<void> onViewReceipt() async {
    // RevenueCat doesn't expose raw store receipts to the client for privacy/security reasons.
    // Two practical options:
    // 1) Deep link to native purchase history (App Store / Play Store)
    // 2) Show your own backend-tracked transaction/billing history screen
    Get.toNamed(
      RoutePaths.billingHistory,
    ); // if you maintain purchase records server-side
  }

  void togglePushNotification(bool value) {
    pushNotification.value = value;
    // TODO: persist to backend
  }

  void toggleCommunityUpdates(bool value) {
    communityUpdates.value = value;
    // TODO: persist to backend
  }

  void toggleInvisibleMode(bool value) {
    invisibleMode.value = value;
    // TODO: persist to backend
  }
}
