import 'package:we_mama/app/helper_widgets_export.dart';

import '../../../../gen/assets.gen.dart';

class WelcomeFundingMumController extends GetxController {
  // ─────────────────────────────
  // 🔹 State
  // ─────────────────────────────

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // ─────────────────────────────
  // 🔹 Step Configuration (SCALABLE CORE)
  // ─────────────────────────────

  late final List<_FundingMumInfoModel> infoModels = [
    _FundingMumInfoModel(
      text: "You are one of\nour first mums",
      iconPath: Assets.icons.starNew,
    ),
    _FundingMumInfoModel(
      text: "Your profile\nhas the\nFounding Mum\nbadge.",
      iconPath: Assets.icons.shieldSupportNew,
    ),
    _FundingMumInfoModel(
      text: "Your help\nshape the\nvillage we are\nbuilding",
      iconPath: Assets.icons.usersAllNew,
    ),
  ];

  // ─────────────────────────────
  // 🔹 Final Step Handler
  // ─────────────────────────────
  void _handleFinalStep() {
    const snackDuration = Duration(seconds: 4); // ← control duration here

    Future.delayed(const Duration(milliseconds: 800), () {
      Snack.showFoundingMumBadge(
        Strings.foundingBadgeAdded,
        title: Strings.earlyMemberHelpingShape.capEachWord(),
        duration: snackDuration, // ← pass duration as param
      );
    });

    // 800 delay + 4000 snack + 300 close animation
    Future.delayed(const Duration(milliseconds: 5100), () {
      Get.offAllNamed(RoutePaths.mainNav);
    });
  }
}

// ─────────────────────────────
// 🔹 Internal Step Model
// ─────────────────────────────

class _FundingMumInfoModel {
  final String text;
  final String iconPath;

  _FundingMumInfoModel({required this.text, required this.iconPath});
}
