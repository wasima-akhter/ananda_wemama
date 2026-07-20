import 'package:mama_app/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../service/referral_service.dart';

class PromoCodeController extends GetxController {
  static PromoCodeController get to => Get.find<PromoCodeController>();

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

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

  final referralCodeCtrl = TextEditingController();
  final referralCodeFocusNode = FocusNode();

  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> onTapContinue() async {
    final code = referralCodeCtrl.text.trim();

    // Skip API if referral code is empty
    if (code.isEmpty) {
      Get.offAllNamed(RoutePaths.subChoosePlan);
      return;
    }

    if (isLoading_.value) return;
    isLoading_.value = true;

    try {
      final success = await ReferralService().applyReferralCode(
        referralCode: code,
      );

      if (success) {
        Get.offAllNamed(RoutePaths.subChoosePlan);
      }
    } catch (e) {
      log("Apply referral code error: $e");
    } finally {
      isLoading_.value = false;
      unfocusAll();
    }
  }
}

class FinishSetupUIDataModel {
  final String leftIcon;
  final String title;

  FinishSetupUIDataModel({required this.leftIcon, required this.title});
}
