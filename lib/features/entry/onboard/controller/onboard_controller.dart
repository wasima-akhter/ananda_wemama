import '../../../../app/controller_export.dart';
import '../../../../core/components/mood_check_in/mood_row_model.dart';
import '../../../../core/enums/ui_enums.dart';

class OnboardController extends GetxController {
  var moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 8),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 8),
  ];
  var currPage = 0.obs;
  var isLastPage__ = false.obs;

  final PageController pageController = PageController();

  static OnboardController get to => findCont<OnboardController>();

  /// 👉 Next button logic (safe)

  /// 👉 Called when swiping pages

  /// 👉 Final navigation (safe & smooth)
  void finishOnboarding() {
    storage.setSeenOnboarding(false); // make true later
    debugPrint("Seen onboarding saved: ${storage.getSeenOnboarding}");

    // Unfocus anything just in case
    FocusManager.instance.primaryFocus?.unfocus();

    // Small frame delay to prevent gesture/navigation crash
    Future.delayed(const Duration(milliseconds: 150), () {
      if (Get.isOverlaysOpen) Get.back(); // close dialogs if any
      GNav.pushNamedReplace(RoutePaths.signin);
    });
  }

  @override
  void onClose() {
    pageController.dispose(); // 🔥 VERY IMPORTANT
    super.onClose();
  }
}

class OnBoardDataModel {
  final String title;
  final String description;
  final String image;

  OnBoardDataModel({required this.title, required this.description, required this.image});
}
