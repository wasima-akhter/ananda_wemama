import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../mood_library/controller/mood_library_controller.dart';

class MoodInsightsController extends GetxController {
  final MoodType passedMoodType;
  final String itemId;

  MoodInsightsController(this.passedMoodType, this.itemId);

  final Rxn<MoodReadingItem> item = Rxn<MoodReadingItem>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadItemDetails();
  }

  Future<void> loadItemDetails() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      // ✅ Read from already-loaded MoodLibraryController — no extra API call
      final mlc = Get.find<MoodLibraryController>();
      final items = mlc.moodReadingItems[passedMoodType] ?? [];

      item.value = items.firstWhereOrNull((e) => e.id == itemId);
      // ✅ null → EmptyWidget shown in screen, no fallback
    } catch (e) {
      debugPrint("Error loading mood insight: $e");
      item.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Refresh: reload library content then re-resolve item
  Future<void> refresh() async {
    final mlc = Get.find<MoodLibraryController>();
    mlc.selectedMood.value = passedMoodType; // ensure correct mood is active
    await mlc.refresh();
    await loadItemDetails();
  }
}
