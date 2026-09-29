import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../shared/subscription/subscription_access/premium_access_service.dart';
import '../../../shared/subscription/subscription_upgrade/type/offer_type.dart';
import '../service/referral_service.dart';

class PromoCodeController extends GetxController {
  static PromoCodeController get to => Get.find<PromoCodeController>();

  final isLoading_ = false.obs;

  bool get isLoading => isLoading_.value;

  final referralCodeCtrl = TextEditingController();

  final referralCodeFocusNode = FocusNode();

  final Rx<OfferType> currentOffer = OfferType.none.obs;

  final RxString appliedCode = ''.obs;

  List<FinishSetupUIDataModel> get featureList => [
    FinishSetupUIDataModel(
      leftIcon: Assets.icons.joinConversation,
      title: "Join conversation",
    ),

    FinishSetupUIDataModel(
      leftIcon: Assets.icons.exploreComm,
      title: "Explore Communities",
    ),

    FinishSetupUIDataModel(
      leftIcon: Assets.icons.liveSession,
      title: "Attend experts sessions",
    ),

    FinishSetupUIDataModel(
      leftIcon: Assets.icons.connectWMums,
      title: "Connect with mums nearby",
    ),
  ];

  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<OfferValidationResult> validateCode(String code) async {
    print("🟢 Validating code=$code");

    switch (code.toLowerCase()) {
      case "ref":
        print("🟢 CODE TYPE=Referral");

        return const OfferValidationResult(
          success: true,
          type: OfferType.referral,
        );

      case "promo":
        print("🟢 CODE TYPE=Promo");

        return const OfferValidationResult(
          success: true,
          type: OfferType.promo,
        );

      case "mum":
        print("🟢 CODE TYPE=Funding Mum");

        return const OfferValidationResult(
          success: true,
          type: OfferType.foundingMum,
        );

      default:
        print("🔴 Invalid code");

        return const OfferValidationResult(
          success: false,
          type: OfferType.none,
          message: "Invalid code",
        );
    }
  }

  Future<bool> applyReferralCode(String code) async {
    print("🟢 Applying referral code API");

    return await ReferralService().applyReferralCode(referralCode: code);
  }

  Future<void> onTapContinueFoundingMumScreen() async {
    final code = referralCodeCtrl.text.trim();

    if (code.isEmpty) {
      currentOffer.value = OfferType.none;

      Get.toNamed(RoutePaths.promoCodeScreen);

      return;
    }

    _continueToSubPlanScreen(code);
  }

  Future<void> onTapContinuePromoScreen() async {
    final code = referralCodeCtrl.text.trim();

    // User did not enter/apply any code or offer.
    // Show the normal subscription choose-plan page.
    if (code.isEmpty) {
      currentOffer.value = OfferType.none;
      appliedCode.value = '';

      if (PremiumAccessService.to.isPremiumUserNow) {
        await showAlreadyPremiumDialog();
        return;
      }

      Get.toNamed(RoutePaths.subChoosePlan);

      return;
    }

    _continueToSubPlanScreen(code);
  }

  /*
  Future<void> _continueToSubPlanScreen(String code) async {
    if (isLoading_.value) return;

    isLoading_.value = true;

    try {
      final result = await validateCode(code);

      if (!result.success) {
        Get.snackbar(
          "Invalid Code",
          result.message ?? "Please enter a valid code",
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      switch (result.type) {
        case OfferType.referral:
          print("🟢 Referral API validation");

          final success = await applyReferralCode(code);

          if (!success) {
            Get.snackbar(
              "Error",
              "Referral code could not be applied",
              snackPosition: SnackPosition.BOTTOM,
            );

            return;
          }

          break;

        case OfferType.promo:
          print("🟢 Promo validation placeholder");

          /*
             TODO:

             Future:
             await PromoService.validate(code)

          */

          break;

        case OfferType.foundingMum:
          print("🟢 Funding Mum validation placeholder");

          /*
             TODO:

             Future:
             await FundingMumService.validate(code)

          */

          break;

        case OfferType.none:
          break;
      }

      currentOffer.value = result.type;

      appliedCode.value = code;

      print("🟢 OFFER SAVED=${currentOffer.value.name}");

      Get.toNamed(RoutePaths.subChoosePlan);
    } catch (e, stack) {
      print("❌ Apply code error=$e");

      debugPrintStack(stackTrace: stack);
    } finally {
      isLoading_.value = false;

      unfocusAll();
    }
  }
*/

  Future<void> _continueToSubPlanScreen(String code) async {
    if (isLoading_.value) return;

    isLoading_.value = true;

    try {
      final result = await validateCode(code);

      if (!result.success) {
        Get.snackbar(
          "Invalid Code",
          result.message ?? "Please enter a valid code",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      switch (result.type) {
        case OfferType.referral:
          print("🟢 Referral API validation");

          final success = await applyReferralCode(code);

          if (!success) {
            Get.snackbar(
              "Error",
              "Referral code could not be applied",
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          break;

        case OfferType.promo:
          print("🟢 Promo validation placeholder");
          break;

        case OfferType.foundingMum:
          print("🟢 Founding Mum validation placeholder");
          break;

        case OfferType.none:
          break;
      }

      currentOffer.value = result.type;
      appliedCode.value = code;

      print("🟢 OFFER SAVED=${currentOffer.value.name}");

      // ✅ NEW: Refresh premium status after successful code/offer
      await _verifyAndNavigateAfterPurchase();
    } catch (e, stack) {
      print("❌ Apply code error=$e");
      debugPrintStack(stackTrace: stack);
    } finally {
      isLoading_.value = false;
      unfocusAll();
    }
  }

  /// Verifies subscription succeeded, then navigates appropriately
  Future<void> _verifyAndNavigateAfterPurchase() async {
    print('\n╔════════════════════════════════════════╗');
    print('║ [PromoCodeController] VERIFY PURCHASE  ║');
    print('╚════════════════════════════════════════╝');

    final premiumService = PremiumAccessService.to;

    try {
      // ─────────────────────────────────────────────
      // WAIT FOR PREMIUM SERVICE TO BE READY
      // ─────────────────────────────────────────────
      if (!premiumService.isReady.value) {
        print('⏳ Premium service NOT ready, waiting...');

        int attempts = 0;
        while (!premiumService.isReady.value && attempts < 50) {
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
        }

        if (!premiumService.isReady.value) {
          print('🔴 Premium service initialization TIMEOUT');
          Get.snackbar(
            "Error",
            "Could not verify subscription status",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      print('✅ Premium service is READY');

      // ─────────────────────────────────────────────
      // REFRESH PREMIUM STATUS
      // ─────────────────────────────────────────────
      print('🔄 Refreshing premium status from backend...');
      await premiumService.refreshPremiumStatus();

      premiumService.printFullState();

      // ─────────────────────────────────────────────
      // VERIFY SUBSCRIPTION SUCCEEDED
      // ─────────────────────────────────────────────
      print('\n🔐 Verifying subscription status:');
      print('   isPremiumUserNow: ${premiumService.isPremiumUserNow}');

      if (!premiumService.isPremiumUserNow) {
        print('❌ Subscription verification failed — user still not premium');

        // ✅ FALLBACK: Try iOS verification
        if (GetPlatform.isIOS) {
          print('🔍 iOS: Attempting fallback verification...');
          final verified = await premiumService.getPremiumStatusWithFallback();

          if (!verified) {
            print('❌ Fallback verification also failed');
            Get.snackbar(
              "Error",
              "Subscription could not be verified. Please try again.",
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          print('✅ iOS fallback verification succeeded');
        } else {
          Get.snackbar(
            "Error",
            "Subscription could not be verified. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      // ✅ SUBSCRIPTION VERIFIED SUCCESSFUL
      print('✅ Subscription verified successfully!');
      print('🎉 User is now PREMIUM');

      print('╔════════════════════════════════════════╗');
      print('║ [PromoCodeController] PURCHASE OK ✅   ║');
      print('╚════════════════════════════════════════╝\n');

      // ─────────────────────────────────────────────
      // NAVIGATE AWAY FROM SUBSCRIPTION FLOW
      // ─────────────────────────────────────────────
      Get.snackbar(
        "Success",
        "Welcome to premium! 🎉",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Wait a moment for snackbar to show
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate back to home or previous screen
      Get.offAllNamed(RoutePaths.mainNav);
    } catch (e) {
      print('❌ Verification error: $e');
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  //

  Future<void> onPlanSelected(String planId) async {
    print("🟢 Plan selected: $planId");

    isLoading_.value = true;

    try {
      // Call your purchase API
      // final success = await SubscriptionService().purc(planId);

      // if (!success) {
      //   Get.snackbar(
      //     "Error",
      //     "Purchase failed. Please try again.",
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      //   return;
      // }

      // ✅ NEW: Verify purchase succeeded
      await _verifyAndNavigateAfterPurchase();
    } catch (e) {
      print("❌ Purchase error: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  //

  @override
  void onClose() {
    referralCodeCtrl.dispose();

    referralCodeFocusNode.dispose();

    super.onClose();
  }
}

class FinishSetupUIDataModel {
  final String leftIcon;
  final String title;

  FinishSetupUIDataModel({required this.leftIcon, required this.title});
}
