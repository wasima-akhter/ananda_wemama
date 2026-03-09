import '../../../../../../app/controller_export.dart';
import '../../../../../../core/local/app_storage.dart';
import '../../../../../core/components/mood_check_in/mood_check_in_controller.dart';
import '../../../../../core/enums/ui_enums.dart';

class MoodReadingItem {
  final String title;
  final List<String> bullets;
  MoodReadingItem({required this.title, required this.bullets});
}

class MoodLibraryController extends GetxController {
  final moodCheckInC = findCont<MoodCheckInController>();

  late final Rx<MoodType> selectedMood;

  @override
  void onInit() {
    super.onInit();

    selectedMood = (moodCheckInC.selectedMood.value ?? MoodType.calm).obs;

    // keep listening if mood changes later
    ever(moodCheckInC.selectedMood, (MoodType? mood) {
      selectedMood.value = mood ?? MoodType.calm;
    });
  }

  final Map<MoodType, List<MoodReadingItem>> moodReadingItems = {
    MoodType.calm: [
      MoodReadingItem(
        title: "Deep Breathing",
        bullets: ["Take a few deep breaths and relax your shoulders."],
      ),
      MoodReadingItem(title: "Calm Visualization", bullets: ["Focus on a calming visualization."]),
    ],
    MoodType.tired: [
      MoodReadingItem(title: "Rest & Recovery", bullets: ["Pause and allow yourself to rest."]),
      MoodReadingItem(title: "Hydration Reset", bullets: ["Hydrate and stretch lightly."]),
      MoodReadingItem(title: "Body Restore", bullets: ["Pause and allow yourself to rest."]),
      MoodReadingItem(title: "Light Movement", bullets: ["Hydrate and stretch lightly."]),
    ],
    MoodType.anxious: [
      MoodReadingItem(
        title: "Mindful Awareness",
        bullets: ["Pause and notice your thoughts without judgment."],
      ),
      MoodReadingItem(
        title: "Grounding Exercise",
        bullets: ["Take a brief walk or grounding exercise."],
      ),
    ],
    MoodType.stressed: [
      MoodReadingItem(title: "Take Control", bullets: ["Identify one thing you can control now."]),
      MoodReadingItem(title: "Mindfulness Break", bullets: ["Try a short mindfulness exercise."]),
    ],
  };
  var isLoading = false.obs;
  bool get loading => isLoading.value;

  void setMood(MoodType mood) {
    selectedMood.value = mood;
  }

  UserInfoModel get userInfo => storage.getUserInfo;

  /// Fetch mood library data safely
  Future<void> fetchMoodLibraries({double? latitude, double? longitude}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      // TODO: API Call
      // final data = await MoodLibraryService().fetchMoodLibraries(lat: latitude, long: longitude);
      // parse and update moodImages & moodReadingItems here
    } catch (e) {
      print("Error fetching mood library: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
