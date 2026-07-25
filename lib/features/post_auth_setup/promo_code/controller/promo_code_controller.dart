import 'package:mama_app/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
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
    debugPrint("🟢 Validating code=$code");

    switch (code.toLowerCase()) {
      case "ref":
        debugPrint("🟢 CODE TYPE=Referral");

        return const OfferValidationResult(
          success: true,
          type: OfferType.referral,
        );

      case "promo":
        debugPrint("🟢 CODE TYPE=Promo");

        return const OfferValidationResult(
          success: true,
          type: OfferType.promo,
        );

      case "mum":
        debugPrint("🟢 CODE TYPE=Funding Mum");

        return const OfferValidationResult(
          success: true,
          type: OfferType.fundingMum,
        );

      default:
        debugPrint("🔴 Invalid code");

        return const OfferValidationResult(
          success: false,
          type: OfferType.none,
          message: "Invalid code",
        );
    }
  }

  Future<bool> applyReferralCode(String code) async {
    debugPrint("🟢 Applying referral code API");

    return await ReferralService().applyReferralCode(referralCode: code);
  }

  Future<void> onTapContinue() async {
    final code = referralCodeCtrl.text.trim();

    if (code.isEmpty) {
      currentOffer.value = OfferType.none;

      Get.offAllNamed(RoutePaths.subChoosePlan);

      return;
    }

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
          debugPrint("🟢 Referral API validation");

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
          debugPrint("🟢 Promo validation placeholder");

          /*
             TODO:

             Future:
             await PromoService.validate(code)

          */

          break;

        case OfferType.fundingMum:
          debugPrint("🟢 Funding Mum validation placeholder");

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

      debugPrint("🟢 OFFER SAVED=${currentOffer.value.name}");

      Get.offAllNamed(RoutePaths.subChoosePlan);
    } catch (e, stack) {
      debugPrint("❌ Apply code error=$e");

      debugPrintStack(stackTrace: stack);
    } finally {
      isLoading_.value = false;

      unfocusAll();
    }
  }

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
