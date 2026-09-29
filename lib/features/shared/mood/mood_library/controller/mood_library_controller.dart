import '../../../../../../app/controller_export.dart';
import '../../../../../../core/local/app_storage.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../mood_check_in/mood_check_in_controller.dart';
import '../model/get_all_mood_model.dart';
import '../service/mood_library_service.dart';

class MoodReadingItem {
  final String id;
  final String title;
  final String description;

  MoodReadingItem({
    required this.id,
    required this.title,
    required this.description,
  });
}

class MoodLibraryController extends GetxController {
  static MoodLibraryController get to => Get.find<MoodLibraryController>();
  final moodCheckInC = findCont<MoodCheckInController>();

  late final Rx<MoodType> selectedMood;

  final isMoodsImagesLoading_ = false.obs;
  bool get isMoodsImagesLoading => isMoodsImagesLoading_.value;

  final isContentLoading_ = false.obs;
  bool get isContentLoading => isContentLoading_.value;

  final allMoodImageData = <GetAllMoodItemModel>[].obs;
  final moodReadingItems = <MoodType, List<MoodReadingItem>>{}.obs;

  final service = MoodLibraryService();

  final bool _isEnsuring = false;

  @override
  void onInit() {
    super.onInit();

    selectedMood = (moodCheckInC.selectedMood.value ?? MoodType.calm).obs;

    // Sync selectedMood when MoodCheckIn changes — no fetch triggered here
    ever(moodCheckInC.selectedMood, (MoodType? mood) {
      final resolved = mood ?? MoodType.calm;
      if (selectedMood.value != resolved) {
        selectedMood.value = resolved;
      }
    });
  }

  // Called from home before navigating — always re-fetches
  Future<void>? _ensureFuture;

  Future<void> ensureLoaded(MoodType mood) {
    return _ensureFuture ??= _loadMoodData(mood);
  }

  Future<void> _loadMoodData(MoodType mood) async {
    try {
      selectedMood.value = mood;

      if (allMoodImageData.isEmpty) {
        await getAllMoodsImages();
      }

      await getAllMoodContent();
    } finally {
      _ensureFuture = null;
    }
  }

  // Called from in-library tab switching — respects cache
  Future<void> loadForCurrentMood() async {
    if (moodReadingItems.containsKey(selectedMood.value)) return;
    await getAllMoodContent();
  }

  // Only syncs back when user changes mood inside library UI
  void setMood(MoodType mood, {bool syncBack = false}) {
    if (selectedMood.value == mood) return;

    selectedMood.value = mood;

    if (syncBack) {
      moodCheckInC.selectMood(mood, fromHome: false);
    }

    loadForCurrentMood();
  }

  String getSelMoodId() {
    return allMoodImageData
            .firstWhere(
              (m) =>
                  (m.title ?? '').toLowerCase() ==
                  selectedMood.value.name.toLowerCase(),
              orElse: () => GetAllMoodItemModel(id: ''),
            )
            .id ??
        '';
  }

  String getMoodImage(MoodType mood) {
    return allMoodImageData
            .firstWhere(
              (m) => (m.title ?? '').toLowerCase() == mood.name.toLowerCase(),
              orElse: () => GetAllMoodItemModel(),
            )
            .image ??
        '';
  }

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

  Future<void> getAllMoodContent() async {
    if (isContentLoading_.value) return;
    isContentLoading_.value = true;
    try {
      final moodId = getSelMoodId();
      if (moodId.isEmpty) return;

      final data = await service.fetchAllMoodContents(moodId: moodId);

      moodReadingItems[selectedMood.value] = data
          .map(
            (item) => MoodReadingItem(
              id: item.id ?? '',
              title: item.title ?? '',
              description: item.description ?? '',
            ),
          )
          .toList();

      moodReadingItems.refresh();
    } catch (e) {
      print("Error fetching mood content: $e");
    } finally {
      isContentLoading_.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await getAllMoodsImages();
    await getAllMoodContent();
  }

  UserInfoModel get userInfo => storage.getUserInfo;
}
