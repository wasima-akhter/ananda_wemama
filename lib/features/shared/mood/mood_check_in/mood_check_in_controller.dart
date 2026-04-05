import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import 'mood_row_model.dart';

class MoodCheckInController extends GetxController {
  var moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 8),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 8),
  ];

  final selectedMood = Rxn<MoodType>();

  void selectMood(MoodType type) {
    if (selectedMood.value == type) {
      selectedMood.value = null; // toggle off
    } else {
      selectedMood.value = type;
    }
  }
}
