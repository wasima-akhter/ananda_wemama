import '../../../../app/controller_export.dart';
import '../../../../gen/assets.gen.dart';

class InterestItem {
  final String label;
  final String iconPath;

  InterestItem({required this.label, required this.iconPath});
}

class LifestyleAndInterestsController extends GetxController {
  static LifestyleAndInterestsController get to =>
      Get.find<LifestyleAndInterestsController>();

  final List<InterestItem> lifestyleInterests = [
    InterestItem(
      label: "Emotional \nSupport",
      iconPath: Assets.icons.emotionalSupport,
    ),
    InterestItem(
      label: "Sleep &\nRefreshness",
      iconPath: Assets.icons.sleepRefresh,
    ),
    InterestItem(label: "Breastfeeding", iconPath: Assets.icons.breastfeeding),
    InterestItem(label: "Selfcare", iconPath: Assets.icons.selfcare),
    InterestItem(label: "Cooking", iconPath: Assets.icons.cooking),
    InterestItem(
      label: "Working\nMum Life",
      iconPath: Assets.icons.workingMumLife,
    ),
    InterestItem(label: "Fitness", iconPath: Assets.icons.fitness),
    InterestItem(label: "Friendship", iconPath: Assets.icons.friendship),
    InterestItem(label: "Pregnancy\nAdvice", iconPath: Assets.icons.pregnancy),
    InterestItem(
      label: "Mental\nWellness",
      iconPath: Assets.icons.mentalWellness,
    ),
    InterestItem(label: "Budgeting", iconPath: Assets.icons.budgeting),
    InterestItem(
      label: "Networking\nEvents",
      iconPath: Assets.icons.networkingEvents,
    ),
    InterestItem(
      label: "Traveling with\nkids",
      iconPath: Assets.icons.travelingWithKids,
    ),
    InterestItem(label: "Learning", iconPath: Assets.icons.learning),
    InterestItem(label: "Arts & crafts", iconPath: Assets.icons.artsCrafts),
    InterestItem(label: "Confidence", iconPath: Assets.icons.confidence),
    InterestItem(label: "Music & podcasts", iconPath: Assets.icons.music),
    InterestItem(label: "Baby care", iconPath: Assets.icons.babyCare),
    InterestItem(label: "Photography", iconPath: Assets.icons.photography),
    InterestItem(label: "Stay-at-home", iconPath: Assets.icons.stayAtHome),
    InterestItem(
      label: "Educational\nplay",
      iconPath: Assets.icons.educationalPlay,
    ),
    InterestItem(label: "Outdoor walks", iconPath: Assets.icons.outdoorWalks),
    InterestItem(label: "Healthy living", iconPath: Assets.icons.healthyLiving),
    InterestItem(label: "Reading", iconPath: Assets.icons.reading),
    InterestItem(
      label: "Minimalist\nlifestyle",
      iconPath: Assets.icons.minimalistLifestyle,
    ),
    InterestItem(label: "Dancing", iconPath: Assets.icons.dancing),
    InterestItem(label: "Mindfulness", iconPath: Assets.icons.mindfulness),
    InterestItem(label: "Writing", iconPath: Assets.icons.writing),
    InterestItem(
      label: "Respectful\nParenting",
      iconPath: Assets.icons.respectfulParenting,
    ),
    InterestItem(
      label: "Social\nmeetups",
      iconPath: Assets.icons.socialMeetups,
    ),
    InterestItem(label: "Small business", iconPath: Assets.icons.smallBusiness),
    InterestItem(
      label: "Child\ndevelopment",
      iconPath: Assets.icons.childDevelopment,
    ),
    InterestItem(label: "Workshops", iconPath: Assets.icons.workshops),
    InterestItem(label: "Other", iconPath: Assets.icons.other),
  ];

  // Show more state
  final RxBool showAllInterests = false.obs;

  void toggleShowAll() {
    showAllInterests.value = true;
  }
  /////

  // Loading state
  final isLoading = false.obs;

  // SINGLE source of truth (IMPORTANT)
  final RxSet<String> selectedItems = <String>{}.obs;

  // Warning text
  final RxString warningText = ''.obs;

  // Selection check
  bool isSelected(String label) => selectedItems.contains(label);

  // Toggle with limit
  void toggle(String label) {
    if (selectedItems.contains(label)) {
      selectedItems.remove(label);
      warningText.value = '';
    } else {
      if (selectedItems.length >= 10) {
        warningText.value = 'You can select up to 10 interests only';
        Snack.showWarning(warningText.value);
        return;
      }
      selectedItems.add(label);
    }
  }

  // Validate
  bool validateSelection() {
    return selectedItems.length >= 3 && selectedItems.length <= 10;
  }

  // Clear
  void clearSelections() {
    selectedItems.clear();
    warningText.value = '';
  }

  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void clearAll() {
    unfocusAll();
    clearSelections();
  }

  void onTapContinue() {
    print("Selected count: ${selectedItems.length}");

    if (selectedItems.length < 3) {
      print("Showing warning");
      Snack.showWarning('Select at least 3 interests');
      return;
    }

    Get.toNamed(RoutePaths.addPhoto);
  }
}
