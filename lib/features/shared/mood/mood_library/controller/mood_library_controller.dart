import '../../../../../../app/controller_export.dart';
import '../../../../../../core/local/app_storage.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../mood_check_in/mood_check_in_controller.dart';
import '../model/get_all_mood_model.dart';
import '../service/mood_library_service.dart';

class MoodReadingItem {
  final String id;
  final String title;
  final String description; // ✅ raw HTML — no bullets list

  MoodReadingItem({required this.id, required this.title, required this.description});
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

    // ✅ React to tab changes — refetch content whenever mood switches
    ever(selectedMood, (_) => _loadForCurrentMood());

    await getAllMoodsImages();
    await getAllMoodContent();
  }

  // ── State ────────────────────────────────────────────────────────────────

  final isMoodsImagesLoading_ = false.obs;
  bool get isMoodsImagesloading => isMoodsImagesLoading_.value;

  final isContentLoading_ = false.obs;
  bool get isContentLoading => isContentLoading_.value;

  final allMoodImageData = <GetAllMoodItemModel>[].obs;
  final moodReadingItems = <MoodType, List<MoodReadingItem>>{}.obs;

  final service = MoodLibraryService();

  // ── Set Mood ─────────────────────────────────────────────────────────────

  void setMood(MoodType mood) {
    selectedMood.value = mood;
    moodCheckInC.selectMood(mood); // ✅ sync back to home
    // ever() above handles the fetch automatically
  }

  // ── Refresh (images + content for current mood) ──────────────────────────

  Future<void> refresh() async {
    await getAllMoodsImages();
    await getAllMoodContent();
  }

  // ── Internal: load both for current mood ────────────────────────────────

  Future<void> _loadForCurrentMood() async {
    // Only fetch content if not already cached for this mood
    if (moodReadingItems.containsKey(selectedMood.value)) return;
    await getAllMoodContent();
  }

  // ── Mood ID helper ───────────────────────────────────────────────────────

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

  // ── API: Mood Images ─────────────────────────────────────────────────────

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

  // ── API: Mood Content (per mood tab) ─────────────────────────────────────

  Future<void> getAllMoodContent() async {
    if (isContentLoading_.value) return;
    isContentLoading_.value = true;

    try {
      final moodId = getSelMoodId();
      if (moodId.isEmpty) return;

      final data = await service.fetchAllMoodContents(moodId: moodId);

      final items = data
          .map(
            (item) => MoodReadingItem(
              id: item.id ?? '',
              title: item.title ?? '',
              description: item.description ?? '', // ✅ adjust field name to your model
            ),
          )
          .toList();

      moodReadingItems[selectedMood.value] = items;
      moodReadingItems.refresh();
    } catch (e) {
      print("Error fetching mood content: $e");
    } finally {
      isContentLoading_.value = false;
    }
  }

  // ── Bullet Parser ─────────────────────────────────────────────────────────

  List<String> _extractBullets(GetAllMoodItemModel item) {
    return ["Explore ${item.title ?? ''}"];
  }

  // ── User ─────────────────────────────────────────────────────────────────

  UserInfoModel get userInfo => storage.getUserInfo;
}
