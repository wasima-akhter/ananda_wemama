import '../../../../app/controller_export.dart';

class LifestyleAndInterestsController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // Reactive selected interests
  final RxList<String> selectedInterests = <String>[].obs;

  // Warning message
  final RxString warningText = ''.obs;

  List<String> get interestsList => [
    "Self-care",
    "Mindfulness",
    "Gentle fitness",
    "Healthy living",
    "Cooking",
    "Sleep routines",
    "Budgeting",
    "Baby care",
    "Stay-At-Home",
    "Respectful parenting",
    "Minimalist lifestyle",
    "Educational play",
    "Arts & crafts",
    "Reading",
    "Sleeping",
    "Writing",
    "Music & podcasts",
    "Outdoor walks",
    "Traveling with kids",
    "Confidence",
    "Photography",
    "Social meetups",
    "Dancing",
    "Small business",
    "Learning",
    "Working mom life",
    "Child development",
  ];

  /// 🔹 Toggle interest selection
  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }

    // Update warning
    // if (selectedInterests.length < 3) {
    //   warningText.value = 'Select at least 3 interests';

    //   Snack.showWarning('Select at least 3 interests');
    // } else if (selectedInterests.length > 10) {
    //   warningText.value = 'You can select up to 10 interests only';
    //   Snack.showWarning('You can select up to 10 interests only');
    // } else {
    //   warningText.value = '';
    // }
  }

  /// 🔹 Clear all selections
  void clearSelections() {
    selectedInterests.clear();
    warningText.value = '';
  }

  /// 🔹 Validate selection
  bool validateSelection() {
    return selectedInterests.length >= 3 && selectedInterests.length <= 10;
  }

  /// 🔹 Unfocus all fields
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Clear all inputs
  void clearAll() {
    unfocusAll();
    clearSelections();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapContinue() {
    // Update warning
    if (selectedInterests.length < 3) {
      Snack.showWarning('Select at least 3 interests');
    } else if (selectedInterests.length > 10) {
      Snack.showWarning('You can select up to 10 interests only');
    } else {
      // go to next page
      Get.toNamed(RoutePaths.mumsStage);
    }
  }
}
