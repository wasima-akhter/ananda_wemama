import '../../../../app/helper_widgets_export.dart';

class MumsStageController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// 🔹 Selected stage
  final RxString selectedStage = ''.obs;

  /// 🔹 Dynamic stage list
  List<MumStageUIDataModel> get stageList => [
    MumStageUIDataModel(info: '', leftIcon: IconsPath.ttcMagnet, title: Strings.ttc),
    MumStageUIDataModel(info: '', leftIcon: IconsPath.pregnant, title: Strings.pregnant),
    MumStageUIDataModel(info: Strings.newMumAge, leftIcon: IconsPath.newMum, title: Strings.newMum),
    MumStageUIDataModel(
      info: Strings.infantMumAge,
      leftIcon: IconsPath.newMum,
      title: Strings.infantMum,
    ),
    MumStageUIDataModel(
      info: Strings.toddlerMumAge,
      leftIcon: IconsPath.newMum,
      title: Strings.toddlerMum,
    ),
    MumStageUIDataModel(
      info: Strings.kindergartenMumAge,
      leftIcon: IconsPath.newMum,
      title: Strings.kindergartenMum,
    ),
  ];

  /// 🔹 Select stage
  void selectStage(String stage) {
    selectedStage.value = stage;
  }

  /// 🔹 Validate
  bool validateStage() {
    return selectedStage.value.isNotEmpty;
  }

  /// 🔹 Unfocus
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Continue
  void onTapContinue(GlobalKey<FormState> formKey) {
    if (!validateStage() || isLoading_.value) {
      Snack.showWarning(Strings.mustSelectOne);
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    // TODO: Save stage to backend

    Get.toNamed(RoutePaths.mumsStageFinish);

    isLoading_.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapFinish() {
    Get.offAllNamed(RoutePaths.subChoosePlan);
  }
}

class MumStageUIDataModel {
  final String leftIcon;
  final String title;
  final String info;

  MumStageUIDataModel({required this.leftIcon, required this.title, required this.info});
}
