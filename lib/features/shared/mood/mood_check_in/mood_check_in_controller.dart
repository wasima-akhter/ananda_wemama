import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../main_tabs/home/service/home_service.dart';
import 'mood_row_model.dart';

class MoodCheckInController extends GetxController {
  static MoodCheckInController get to => findCont<MoodCheckInController>();

  var moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 8),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 8),
  ];

  final selectedMood = Rxn<MoodType>();

  void selectMood(MoodType type, {required bool fromHome}) {
    if (selectedMood.value == type) {
      selectedMood.value = null;
    } else {
      selectedMood.value = type;

      // 🔥 fire API but DO NOT await UI
      if (fromHome) uploadTheCheckTrigger();
    }
  }

  //---------------------------
  //---------------------------
  final RxBool isLoading = false.obs;

  // ✅ Correct way to declare nullable Rx
  final checkInResponseData = Rxn<CheckInResponse>();

  Future<void> uploadTheCheckTrigger() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final data = await HomeService().postTheCheckTrigger();

      if (data != null) {
        checkInResponseData.value = data;
        print(' checkInResponseData : ${checkInResponseData.value?.message}');

        hasCheckedIn.value = true;

        storage.setHasCheckedIn(true);
      }
    } catch (e) {
      print("Error fetch checkInResponseData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //
  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 16) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  final hasCheckedIn = false.obs;

  @override
  void onInit() {
    super.onInit();

    hasCheckedIn.value = storage.hasCheckedIn;
  }
}
