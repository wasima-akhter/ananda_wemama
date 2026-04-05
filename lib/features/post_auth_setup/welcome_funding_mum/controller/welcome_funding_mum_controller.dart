import 'package:mama_app/app/helper_widgets_export.dart';

import '../../../../core/models/ui/common_data_models.dart';

class WelcomeFundingMumController extends GetxController {
  // ─────────────────────────────
  // 🔹 State
  // ─────────────────────────────

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final currentPageIndex = 0.obs;
  final isReady = false.obs;

  final PageController pageController = PageController();

  bool _hasTriggeredFinal = false;

  // ─────────────────────────────
  // 🔹 Step Configuration (SCALABLE CORE)
  // ─────────────────────────────

  late final List<_WelcomeStep> steps = [
    _WelcomeStep(type: WelcomePageType.intro, buttonText: Strings.continueTxt),
    _WelcomeStep(type: WelcomePageType.meaning, buttonText: Strings.continueTxt),
    _WelcomeStep(type: WelcomePageType.usage, buttonText: Strings.iUnderstand),
    _WelcomeStep(
      type: WelcomePageType.confirmation,
      buttonText: Strings.enterWeMama,
      validator: () => isReady.value,
    ),
    _WelcomeStep(type: WelcomePageType.finalImage, showButton: false, onEnter: _handleFinalStep),
  ];

  int get totalPages => steps.length - 1;

  _WelcomeStep get currentStep => steps[currentPageIndex.value];

  WelcomePageType get currentPage => currentStep.type;

  bool get shouldShowButton => currentStep.showButton;

  String get getbtnText => currentStep.buttonText ?? '';

  bool get isIntroPage => currentPage == WelcomePageType.intro;

  bool get isConfirmationPage => currentPage == WelcomePageType.confirmation;

  // ─────────────────────────────
  // 🔹 Checkbox Logic
  // ─────────────────────────────

  void setReady(bool? value) {
    if (value == null) return;
    isReady.value = value;
  }

  void toggleReady() => isReady.toggle();

  // ─────────────────────────────
  // 🔹 Navigation
  // ─────────────────────────────

  void nextPage() {
    if (currentPageIndex.value < totalPages) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void onTapButton() {
    final validator = currentStep.validator;

    if (validator != null && !validator()) {
      return;
    }

    nextPage();
  }

  void onPageChanged(int page) {
    currentPageIndex.value = page;

    currentStep.onEnter?.call();
  }

  // ─────────────────────────────
  // 🔹 Final Step Handler
  // ─────────────────────────────
  void _handleFinalStep() {
    if (_hasTriggeredFinal) return;
    _hasTriggeredFinal = true;

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

  // ─────────────────────────────
  // 🔹 Page Data (unchanged)
  // ─────────────────────────────

  List<String> get page1TxtList => [
    Strings.thankYouEarly,
    Strings.calmSpaceForMums,
    Strings.honestlyNoPressure,
    Strings.presenceSetsTone,
  ];

  List<CommonTitleIconpathModel> get page2ItemList => [
    CommonTitleIconpathModel(title: Strings.firstCircle, iconPath: IconsPath.leaf),
    CommonTitleIconpathModel(title: Strings.shapeCommunityTone, iconPath: IconsPath.heartHand),
    CommonTitleIconpathModel(title: Strings.noObligation, iconPath: IconsPath.twoLeaf),
    CommonTitleIconpathModel(title: Strings.showUpGently, iconPath: IconsPath.leafInHand),
  ];

  List<CommonTitleIconpathModel> get page3ItemList => [
    CommonTitleIconpathModel(
      title: Strings.checkIn,
      subtitle: Strings.tapHowFeeling,
      iconPath: IconsPath.emojiWithHeart,
    ),
    CommonTitleIconpathModel(
      title: Strings.listen,
      subtitle: Strings.readOrReply,
      iconPath: IconsPath.listen,
    ),
    CommonTitleIconpathModel(
      title: Strings.rest,
      subtitle: Strings.stepAway,
      iconPath: IconsPath.restSit,
    ),
  ];

  List<String> get page4TxtList => [Strings.spaceBuiltOnKindness, Strings.neverPressured];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

// ─────────────────────────────
// 🔹 Internal Step Model
// ─────────────────────────────

class _WelcomeStep {
  final WelcomePageType type;
  final String? buttonText;
  final bool showButton;
  final bool Function()? validator;
  final VoidCallback? onEnter;

  _WelcomeStep({
    required this.type,
    this.buttonText,
    this.showButton = true,
    this.validator,
    this.onEnter,
  });
}
