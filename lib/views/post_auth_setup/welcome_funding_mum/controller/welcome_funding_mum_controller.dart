import 'package:mama_app/app/controller_export.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

import '../../../../core/common_widgets/models/common_data_models.dart';

class WelcomeFundingMumController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // Page controller for swiping
  final pageController = PageController();
  final currentPageIndex = 0.obs;

  // ✅ Checkbox state
  final isReady = false.obs;

  // Used when checkbox passes value
  void setReady(bool? value) {
    if (value == null) return;
    isReady.value = value;
  }

  // Used when tapping the whole row
  void toggleReady() {
    isReady.value = !isReady.value;
  }

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

  String get getbtnText {
    if (currentPage == WelcomePageType.usage) {
      return Strings.iUnderstand;
    }
    if (currentPage == WelcomePageType.confirmation) {
      return Strings.enterWeMama;
    } else {
      return Strings.continueTxt;
    }
  }

  /// 🔹 Navigate to next page
  void nextPage() {
    if (currentPageIndex.value < totalPages) {
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  WelcomePageType get currentPage => WelcomePageType.values[currentPageIndex.value];

  static const totalPages = 4;

  bool get isIntroPage => currentPage == WelcomePageType.intro;

  bool get isConfirmationPage => currentPage == WelcomePageType.confirmation;

  bool get shouldShowButton => currentPage != WelcomePageType.finalImage;

  // A private flag to prevent multiple triggers
  bool _hasShownFinalSnack = false;

  /// 🔹 Track page changes
  void onPageChanged(int page) {
    currentPageIndex.value = page;

    // Automatically trigger Snack + navigate if it's the last page
    if (currentPage == WelcomePageType.finalImage) {
      // Only trigger once
      if (!_hasShownFinalSnack) {
        _hasShownFinalSnack = true;

        Future.delayed(const Duration(milliseconds: 1000), () {});
        Snack.show(Strings.foundingBadgeAdded, title: Strings.earlyMemberHelpingShape);

        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.offAllNamed(RoutePaths.mainNav);
        });
      }
    }
  }

  /// 🔹 Unfocus all fields
  void unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  /// 🔹 Clear all inputs
  void clearAll() => unfocusAll();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onTapButton() async {
    switch (currentPage) {
      case WelcomePageType.intro:
      case WelcomePageType.meaning:
      case WelcomePageType.usage:
        nextPage();
        break;

      case WelcomePageType.confirmation:
        if (isReady.value) {
          nextPage();
        }
        break;

      case WelcomePageType.finalImage:
        break;
    }
  }
}
