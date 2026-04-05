import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../shared/mood/mood_check_in/mood_row_model.dart';

class ExpertsController extends GetxController {
  var moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 8),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 8),
  ];

  var pastSessionList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
  ];

  final writeQuesCtrl = TextEditingController();

  final writeQuesFocusNode = FocusNode();

  final searchCtrl = TextEditingController();

  final searchFocusNode = FocusNode();

  @override
  void onClose() {
    writeQuesCtrl.dispose();
    writeQuesFocusNode.dispose();
    super.onClose();
  }

  void onTapQues() {
    Get.back();
  }
}
