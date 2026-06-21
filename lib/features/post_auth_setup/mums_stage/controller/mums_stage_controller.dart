import '../../../../app/helper_widgets_export.dart';

class MumsStageController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// 🔹 Selected stage IDs (multi-select)
  final RxList<String> selectedStageIds = <String>[].obs;

  /// 🔁 Toggle selection
  void toggleStage(String id) {
    if (selectedStageIds.contains(id)) {
      selectedStageIds.remove(id);
    } else {
      selectedStageIds.add(id);
    }
  }

  /// ✅ Check selection
  bool isSelected(String id) {
    return selectedStageIds.contains(id);
  }

  bool validStage() {
    return selectedStageIds.isNotEmpty;
  }

  /// 🔹 Unfocus
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  List<String> get selectedStageTitles {
    return stageList
        .where((stage) => selectedStageIds.contains(stage.id))
        .map((stage) => stage.title)
        .toList();
  }

  void continueToNext() {
    if (selectedStageIds.isEmpty) {
      Snack.showWarning(title: "Required", "Please select at least one stage");
      return;
    }

    Get.toNamed(RoutePaths.addChildren);
  }

  /// 🔹 Dynamic stage list
  List<MumStageUIDataModel> get stageList => [
    MumStageUIDataModel(
      id: 'ttc',
      info: '',
      leftIcon: IconsPath.ttcMagnet,
      title: Strings.ttc,
    ),
    MumStageUIDataModel(
      id: 'pregnant',
      info: '',
      leftIcon: IconsPath.pregnant,
      title: Strings.pregnant,
    ),
    MumStageUIDataModel(
      id: 'new_mum',
      info: Strings.newMumAge,
      leftIcon: IconsPath.newMum,
      title: Strings.newMum,
    ),
    MumStageUIDataModel(
      id: 'toddler_mum',
      info: Strings.toddlerMumAge,
      leftIcon: IconsPath.toddler,
      title: Strings.toddlerMum,
    ),
    MumStageUIDataModel(
      id: 'kindergarten_mum',
      info: Strings.kindergartenMumAge,
      leftIcon: IconsPath.older,
      title: Strings.kindergartenMum,
    ),
  ];
}

class MumStageUIDataModel {
  final String id;
  final String leftIcon;
  final String title;
  final String info;

  MumStageUIDataModel({
    required this.id,
    required this.leftIcon,
    required this.title,
    required this.info,
  });
}
