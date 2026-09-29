import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../mood_library/controller/mood_library_controller.dart';

class MoodInsightsController extends GetxController {
  final MoodType passedMoodType;
  final String itemId;
  final bool fromHome; // ✅ new

  MoodInsightsController(
    this.passedMoodType,
    this.itemId, {
    this.fromHome = false,
  });

  static MoodInsightsController get to => Get.find<MoodInsightsController>();
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
      final mlc = Get.find<MoodLibraryController>();
      final items = mlc.moodReadingItems[passedMoodType] ?? [];
      item.value = items.firstWhereOrNull((e) => e.id == itemId);
    } catch (e) {
      print("Error loading mood insight: $e");
      item.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Called by back button on MoodInsightsScreen
  void handleBack() {
    if (fromHome) {
      // Go to moodLibrary with the correct mood already set
      Get.toNamed(RoutePaths.moodLibrary);
    } else {
      Get.back();
    }
  }

  @override
  Future<void> refresh() async {
    final mlc = Get.find<MoodLibraryController>();
    mlc.selectedMood.value = passedMoodType;
    await mlc.refresh();
    await loadItemDetails();
  }
}
