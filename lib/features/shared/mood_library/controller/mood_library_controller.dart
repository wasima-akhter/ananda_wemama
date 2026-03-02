import '../../../../../app/controller_export.dart';
import '../../../../../core/local/app_storage.dart';
import '../../../../core/enums/ui_enums.dart';

class MoodLibraryController extends GetxController {
  final selectedMood = MoodType.calm.obs;

  final Map<MoodType, String> moodImages = {
    MoodType.calm: Strings.fakeImageUrl,
    MoodType.tired: Strings.fakeImageUrl,
    MoodType.anxious: Strings.fakeImageUrl,
    MoodType.stressed: Strings.fakeImageUrl,
  };

  final Map<MoodType, List<List<String>>> moodReadingItems = {
    MoodType.calm: [
      ["Take a few deep breaths and relax your shoulders."],
      ["Focus on a calming visualization."],
    ],
    MoodType.tired: [
      ["Pause and allow yourself to rest."],
      ["Hydrate and stretch lightly."],
      ["Pause and allow yourself to rest."],
      ["Hydrate and stretch lightly."],
    ],
    MoodType.anxious: [
      ["Pause and notice your thoughts without judgment."],
      ["Take a brief walk or grounding exercise."],
    ],
    MoodType.stressed: [
      ["Identify one thing you can control now."],
      ["Try a short mindfulness exercise."],
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
