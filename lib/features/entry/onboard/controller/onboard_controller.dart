import '../../../../app/controller_export.dart';

class OnboardController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final isLastPage = false.obs;

  static OnboardController get to => findCont<OnboardController>();
  static const int totalPages = 3;

  @override
  void onInit() {
    super.onInit();
    ever(currentPage, (page) {
      isLastPage.value = page == totalPages - 1;
    });
  }

  void nextPage() {
    if (isLastPage.value) {
      finishOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void finishOnboarding() {
    storage.seenOnboarding(true);
    Get.offAllNamed(RoutePaths.signin);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// 👉 Next button logic (safe)

  /// 👉 Called when swiping pages

  /// 👉 Final navigation (safe & smooth)
  // void finishOnboarding() {
  //   storage.setSeenOnboarding(true); // make true later
  //   print("Seen onboarding saved: ${storage.getSeenOnboarding}");

  //   // Unfocus anything just in case
  //   FocusManager.instance.primaryFocus?.unfocus();

  //   // Small frame delay to prevent gesture/navigation crash
  //   Future.delayed(const Duration(milliseconds: 150), () {
  //     if (Get.isOverlaysOpen) Get.back(); // close dialogs if any
  //     Get.toNamedReplace(RoutePaths.signin);
  //   });
  // }

  // @override
  // void onClose() {
  //   pageController.dispose(); // 🔥 VERY IMPORTANT
  //   super.onClose();
  // }
}

class OnBoardDataModel {
  final String title;
  final String description;
  final String image;

  OnBoardDataModel({
    required this.title,
    required this.description,
    required this.image,
  });
}
