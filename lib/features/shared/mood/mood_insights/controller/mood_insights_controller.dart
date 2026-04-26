import '../../../../../app/controller_export.dart';
import '../../../../../core/enums/ui_enums.dart';
import '../../mood_library/controller/mood_library_controller.dart';

class MoodInsightsController extends GetxController {
  final MoodType passedMoodType;
  final String itemId;

  MoodInsightsController(this.passedMoodType, this.itemId);

  /// ── STATE ─────────────────────────────────────
  final Rxn<MoodReadingItem> item = Rxn<MoodReadingItem>();
  final RxBool isLoading = false.obs;

  /// ── LIFECYCLE ─────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadItemDetails();
  }

  /// ── LOAD DATA ─────────────────────────────────
  Future<void> loadItemDetails() async {
    if (isLoading.value) return; // prevent duplicate calls

    isLoading.value = true;

    try {
      final result = await _fetchItem(itemId);
      item.value = result;
    } catch (e) {
      debugPrint("Error loading mood insight: $e");
      item.value = null; // safe fallback
    } finally {
      isLoading.value = false;
    }
  }

  /// ── MOCK / API LAYER ──────────────────────────
  Future<MoodReadingItem?> _fetchItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Replace with API later
    return MoodReadingItem(
      id: id,
      title: "Mood Insight Title",
      bullets: const ["First insight detail", "Second insight detail", "Third insight detail"],
    );
  }
}
