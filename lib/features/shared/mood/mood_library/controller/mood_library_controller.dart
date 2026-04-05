import '../../../../../../app/controller_export.dart';
import '../../../../../../core/local/app_storage.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../mood_check_in/mood_check_in_controller.dart';
import '../model/get_all_mood_model.dart';
import '../service/mood_library_service.dart';

class MoodReadingItem {
  final String id; // ← add
  final String title;
  final List<String> bullets;

  MoodReadingItem({
    required this.id, // ← add
    required this.title,
    required this.bullets,
  });
}

class MoodLibraryController extends GetxController {
  final moodCheckInC = findCont<MoodCheckInController>();

  late final Rx<MoodType> selectedMood;

  @override
  void onInit() async {
    super.onInit();

    selectedMood = (moodCheckInC.selectedMood.value ?? MoodType.calm).obs;

    // keep listening if mood changes later
    ever(moodCheckInC.selectedMood, (MoodType? mood) {
      selectedMood.value = mood ?? MoodType.calm;
    });

    await getAllMoodsImages();

    await getAllMoodContent();
  }

  final Map<MoodType, List<MoodReadingItem>> moodReadingItems = {
    MoodType.calm: [
      MoodReadingItem(
        id: "calm_0",
        title: "Deep Breathing",
        bullets: ["Take a few deep breaths and relax your shoulders."],
      ),
      MoodReadingItem(
        id: "calm_1",
        title: "Calm Visualization",
        bullets: ["Focus on a calming visualization."],
      ),
    ],
    MoodType.tired: [
      MoodReadingItem(
        id: "tired_0",
        title: "Rest & Recovery",
        bullets: ["Pause and allow yourself to rest."],
      ),
      MoodReadingItem(
        id: "tired_1",
        title: "Hydration Reset",
        bullets: ["Hydrate and stretch lightly."],
      ),
      MoodReadingItem(
        id: "tired_2",
        title: "Body Restore",
        bullets: ["Pause and allow yourself to rest."],
      ),
      MoodReadingItem(
        id: "tired_3",
        title: "Light Movement",
        bullets: ["Hydrate and stretch lightly."],
      ),
    ],
    MoodType.anxious: [
      MoodReadingItem(
        id: "anxious_0",
        title: "Mindful Awareness",
        bullets: ["Pause and notice your thoughts without judgment."],
      ),
      MoodReadingItem(
        id: "anxious_1",
        title: "Grounding Exercise",
        bullets: ["Take a brief walk or grounding exercise."],
      ),
    ],
    MoodType.stressed: [
      MoodReadingItem(
        id: "stressed_0",
        title: "Take Control",
        bullets: ["Identify one thing you can control now."],
      ),
      MoodReadingItem(
        id: "stressed_1",
        title: "Mindfulness Break",
        bullets: ["Try a short mindfulness exercise."],
      ),
    ],
  };

  final service = MoodLibraryService();

  ///
  ///
  var isLoading = false.obs;
  bool get loading => isLoading.value;

  void setMood(MoodType mood) {
    selectedMood.value = mood;
  }

  String getSelMoodId() {
    final selMoodId = allMoodImageData
        .firstWhere(
          (m) => (m.title ?? '').toLowerCase() == selectedMood.value.name.toLowerCase(),
          orElse: () => GetAllMoodItemModel(id: 'default'),
        )
        .id;

    return selMoodId ?? '';
  }

  UserInfoModel get userInfo => storage.getUserInfo;

  final realMoodReadingItems = null;

  /// Fetch mood library data safely
  Future<void> getAllMoodContent() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      // TODO: API Call
      final data = await MoodLibraryService().fetchAllMoodContents(moodId: getSelMoodId());
      // parse and update moodImages & moodReadingItems here
    } catch (e) {
      print("Error fetching mood library: $e");
    } finally {
      isLoading.value = false;
    }
  }

  var isMoodsImagesLoading_ = false.obs;
  bool get isMoodsImagesloading => isMoodsImagesLoading_.value;

  final allMoodImageData = <GetAllMoodItemModel>[].obs;

  /// Fetch mood library data safely
  Future<void> getAllMoodsImages({double? latitude, double? longitude}) async {
    if (isMoodsImagesLoading_.value) return;
    isMoodsImagesLoading_.value = true;

    try {
      // TODO: API Call
      final data = await MoodLibraryService().fetchMoodImageData();

      if (data.isNotEmpty) {
        allMoodImageData.value = data;

        debugPrint(' allMoodImageData : ${allMoodImageData.value.length}');
      } else {}
      // parse and update moodImages & moodReadingItems here
    } catch (e) {
      print("Error fetching mood library: $e");
    } finally {
      isMoodsImagesLoading_.value = false;
    }
  }
}
