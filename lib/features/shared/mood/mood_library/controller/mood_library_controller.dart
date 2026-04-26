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

    ever(moodCheckInC.selectedMood, (MoodType? mood) {
      selectedMood.value = mood ?? MoodType.calm;
    });

    await getAllMoodsImages();
    await getAllMoodContent();
  }

  //────────────────────────────────────────────
  // STATE
  //────────────────────────────────────────────

  final isMoodsImagesLoading_ = false.obs;
  bool get isMoodsImagesloading => isMoodsImagesLoading_.value;

  final isContentLoading_ = false.obs;
  bool get isContentLoading => isContentLoading_.value;

  final allMoodImageData = <GetAllMoodItemModel>[].obs;

  /// API-driven mood reading items
  final moodReadingItems = <MoodType, List<MoodReadingItem>>{}.obs;

  final service = MoodLibraryService();

  //────────────────────────────────────────────
  // SET MOOD
  //────────────────────────────────────────────

  void setMood(MoodType mood) {
    selectedMood.value = mood;
  }

  //────────────────────────────────────────────
  // SAFE MOOD ID
  //────────────────────────────────────────────

  String getSelMoodId() {
    return allMoodImageData
            .firstWhere(
              (m) => (m.title ?? '').toLowerCase() == selectedMood.value.name.toLowerCase(),
              orElse: () => GetAllMoodItemModel(id: ''),
            )
            .id ??
        '';
  }

  String getMoodImage(MoodType mood) {
    final data = allMoodImageData.firstWhere(
      (m) => (m.title ?? '').toLowerCase() == mood.name.toLowerCase(),
      orElse: () => GetAllMoodItemModel(),
    );

    return data.image ?? '';
  }
  //────────────────────────────────────────────
  // STATIC FALLBACK (optional backup)
  //────────────────────────────────────────────

  final Map<MoodType, List<MoodReadingItem>> fallbackMoodReadingItems = {
    MoodType.calm: [
      MoodReadingItem(
        id: "calm_0",
        title: "Deep Breathing",
        bullets: ["Take a few deep breaths and relax your shoulders."],
      ),
    ],
    MoodType.tired: [
      MoodReadingItem(
        id: "tired_0",
        title: "Rest & Recovery",
        bullets: ["Pause and allow yourself to rest."],
      ),
    ],
    MoodType.anxious: [
      MoodReadingItem(
        id: "anxious_0",
        title: "Mindful Awareness",
        bullets: ["Notice thoughts without judgment."],
      ),
    ],
    MoodType.stressed: [
      MoodReadingItem(
        id: "stressed_0",
        title: "Take Control",
        bullets: ["Identify one thing you can control now."],
      ),
    ],
  };

  //────────────────────────────────────────────
  // API: MOOD IMAGES
  //────────────────────────────────────────────

  Future<void> getAllMoodsImages() async {
    if (isMoodsImagesLoading_.value) return;

    isMoodsImagesLoading_.value = true;

    try {
      final data = await service.fetchMoodImageData();

      allMoodImageData.assignAll(data);
    } catch (e) {
      print("Error fetching mood images: $e");
    } finally {
      isMoodsImagesLoading_.value = false;
    }
  }

  //────────────────────────────────────────────
  // API: MOOD CONTENT
  //────────────────────────────────────────────

  Future<void> getAllMoodContent() async {
    if (isContentLoading_.value) return;

    isContentLoading_.value = true;

    try {
      final moodId = getSelMoodId();

      final data = await service.fetchAllMoodContents(moodId: moodId);

      final Map<MoodType, List<MoodReadingItem>> grouped = {};

      for (final item in data) {
        final mood = MoodType.values.firstWhere(
          (e) => e.name.toLowerCase() == (item.title ?? '').toLowerCase(),
          orElse: () => selectedMood.value,
        );

        grouped.putIfAbsent(mood, () => []);

        grouped[mood]!.add(
          MoodReadingItem(
            id: item.id ?? '',
            title: item.title ?? '',
            bullets: _extractBullets(item),
          ),
        );
      }

      moodReadingItems.assignAll(grouped);
    } catch (e) {
      print("Error fetching mood content: $e");
    } finally {
      isContentLoading_.value = false;
    }
  }

  //────────────────────────────────────────────
  // BULLET PARSER
  //────────────────────────────────────────────

  List<String> _extractBullets(GetAllMoodItemModel item) {
    return ["Explore ${item.title ?? ''}"];
  }

  //────────────────────────────────────────────
  // USER
  //────────────────────────────────────────────

  UserInfoModel get userInfo => storage.getUserInfo;
}
