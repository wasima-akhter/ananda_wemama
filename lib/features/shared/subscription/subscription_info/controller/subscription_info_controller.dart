import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:purchases_flutter/purchases_flutter.dart' hide PurchaseResult;
import 'package:we_mama/features/shared/subscription/subscription_upgrade/mixin/subscription_plan_mixin.dart';

import '../../../../../app/controller_export.dart';
import '../../../../../core/components/app_ui/popup_widgets/disable_notifications_dialog.dart';
import '../../../../../core/components/app_ui/popup_widgets/enable_notifications_popup.dart';
import '../../../../../core/services/push_notification/push_notification_service.dart';
import '../../../../post_auth_setup/promo_code/controller/promo_code_controller.dart';
import '../../subscription_upgrade/service/purchase_service.dart';
import '../../subscription_upgrade/type/offer_type.dart';

// subscription_info_controller.dart
class SubscriptionInfoController extends GetxController
    with SubscriptionPlanFlowMixin, WidgetsBindingObserver {
  static SubscriptionInfoController get to => Get.find();

  final promoCodeTextController = TextEditingController();

  final PurchaseService _purchaseService = PurchaseService.to;

  final RxBool isLoading = true.obs;
  final RxBool isRestoring = false.obs;

  final Rx<SubscriptionDisplayInfo?> subInfo = Rx<SubscriptionDisplayInfo?>(
    null,
  );

  final Rxn<StoreProduct> activeProduct = Rxn<StoreProduct>();

  final RxBool communityUpdates = true.obs;
  final RxBool invisibleMode = false.obs;

  /// Single source of truth
  Rx<AuthorizationStatus> get notificationStatus =>
      PushNotificationService.to.notificationStatus;
  AuthorizationStatus? _lastNotificationStatus;

  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    await PushNotificationService.to.refreshNotificationPermissionStatus();

    _lastNotificationStatus =
        PushNotificationService.to.notificationStatus.value;

    _loadSubscriptionInfo();

    ever(_purchaseService.customerInfo, (_) => _loadSubscriptionInfo());
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;

    await PushNotificationService.to.refreshNotificationPermissionStatus();

    final current = PushNotificationService.to.notificationStatus.value;

    if (_lastNotificationStatus != current) {
      print(
        '🔔 Notification permission changed: '
        '$_lastNotificationStatus -> $current',
      );

      if (PushNotificationService.to.isNotificationEnabled) {
        await PushNotificationService.to.onNotificationPermissionEnabled();
      }

      _lastNotificationStatus = current;
    }
  }

  Future<void> _refreshNotificationToggle() async {
    await PushNotificationService.to.refreshNotificationPermissionStatus();
  }

  Future<void> togglePushNotification(bool value) async {
    if (!value) {
      final confirmed = await Get.dialog<bool>(
        const DisableNotificationsPopup(),
        barrierDismissible: true,
        transitionCurve: Curves.easeOutBack,
        transitionDuration: const Duration(milliseconds: 280),
      );

      if (confirmed == true) {
        final opened = await AppSettings.openAppSettings();

        if (!opened) {
          Snack.showError("Unable to open app settings.");
        }
      }
      return;
    }

    final status = await PushNotificationService.to.getNotificationStatus();

    switch (status) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        // Already enabled.
        return;

      case AuthorizationStatus.notDetermined:
        // First time → show the OS prompt.
        await PushNotificationService.to.enableNotifications();
        await _refreshNotificationToggle();
        return;

      case AuthorizationStatus.denied:
        // Can't show the OS prompt anymore.
        await Get.dialog(const EnableNotificationsPopup());

        await _refreshNotificationToggle();
        return;
    }
  }

  void toggleCommunityUpdates(bool value) {
    communityUpdates.value = value;
    // TODO: persist
  }

  void toggleInvisibleMode(bool value) {
    invisibleMode.value = value;
    // TODO: persist
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
      print('Load subscription info error: $e');
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
      print('Load RevenueCat product error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> onManageBilling() async {
    try {
      await _purchaseService.openManageSubscription();
    } catch (e, s) {
      print('Open manage billing error: $e');
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
      print('Cancel subscription error: $e');
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
      print('Restore purchases error: $e');
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

  //
  final RxBool isApplyPromoLoading = false.obs;
  @override
  RxBool get flowLoading => isApplyPromoLoading;

  Future<void> applyPromoCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final code = promoCodeTextController.text.trim();

    if (code.isEmpty) {
      Snack.showError("Please enter a promo code.");
      return;
    }

    // TODO:
    // Replace this with your backend API.
    //
    // Example:
    //
    // final result = await SubscriptionService().checkPromoCode(code);
    // final offer = result.offerType;

    final offer = OfferType.promo; // Fake response for now.

    if (offer != OfferType.promo) {
      Snack.showWarning(title: "Invalid", "Promo code is not valid.");
      return;
    }

    if (!Get.isRegistered<PromoCodeController>()) {
      Get.lazyPut<PromoCodeController>(
        () => PromoCodeController(),
        fenix: true,
      );
    }

    PromoCodeController.to.currentOffer.value = offer;
    PromoCodeController.to.appliedCode.value = code;

    await proceedToPaidPlan();
  }

  //
}
