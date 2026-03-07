import '../../../../app/controller_export.dart';
import '../../../../core/common_widgets/compare_component.dart';
import '../../../../core/components/mood_check_in/mood_row_model.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/local/app_storage.dart';
import '../model/nearby_suppliers_with_price_stats_model.dart';

class ExpertsController extends GetxController {
  var moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 8),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 8),
  ];
}
