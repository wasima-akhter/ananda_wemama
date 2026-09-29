import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/services/auth/verification_gate.dart';

class FinishSettingProfileController extends GetxController {
  static FinishSettingProfileController get to =>
      Get.find<FinishSettingProfileController>();
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// 🔹 Dynamic stage list
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

  /// 🔹 Unfocus
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
  // Get.toNamed(RoutePaths.welcomeFundingMum);

  Future<void> onTapContinue() async {
    // Get.toNamed(RoutePaths.welcomeFundingMum);
    // Get.offAllNamed(RoutePaths.mainNav);
    await VerificationGate.routeAfterAuth();
  }
}

class FinishSetupUIDataModel {
  final String leftIcon;
  final String title;

  FinishSetupUIDataModel({required this.leftIcon, required this.title});
}
