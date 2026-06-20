import 'package:mama_app/core/helpers/date_helper.dart';
import 'package:mama_app/features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import 'package:mama_app/features/post_auth_setup/lifestyle_and_interests/controller/lifestyle_and_interests_controller.dart';
import 'package:mama_app/features/post_auth_setup/photo_and_bio/controller/photo_and_bio_controller.dart';
import 'package:mama_app/features/post_auth_setup/setup_profile/controller/setup_profile_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/services/post_signup_set_profile/post_signup_set_profile_service.dart';

class MumsStageController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// 🔹 Selected stage
  final RxString selectedStage = ''.obs;

  /// 🔹 Dynamic stage list
  List<MumStageUIDataModel> get stageList => [
    MumStageUIDataModel(
      info: '',
      leftIcon: IconsPath.ttcMagnet,
      title: Strings.ttc,
    ),
    MumStageUIDataModel(
      info: '',
      leftIcon: IconsPath.pregnant,
      title: Strings.pregnant,
    ),
    MumStageUIDataModel(
      info: Strings.newMumAge,
      leftIcon: IconsPath.newMum,
      title: Strings.newMum,
    ),
    MumStageUIDataModel(
      info: Strings.toddlerMumAge,
      leftIcon: IconsPath.toddler,
      title: Strings.toddlerMum,
    ),
    MumStageUIDataModel(
      info: Strings.kindergartenMumAge,
      leftIcon: IconsPath.older,
      title: Strings.kindergartenMum,
    ),
  ];

  /// 🔹 Select stage
  void selectStage(String stage) {
    selectedStage.value = stage;
  }

  /// 🔹 Validate
  bool validStage() {
    return selectedStage.value.isNotEmpty;
  }

  /// 🔹 Unfocus
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
 

 
 
}

class MumStageUIDataModel {
  final String leftIcon;
  final String title;
  final String info;

  MumStageUIDataModel({
    required this.leftIcon,
    required this.title,
    required this.info,
  });
}
