import 'package:mama_app/features/post_auth_setup/lifestyle_and_interests/controller/lifestyle_and_interests_controller.dart';
import 'package:mama_app/features/post_auth_setup/mums_stage/controller/mums_stage_controller.dart';
import 'package:mama_app/features/post_auth_setup/photo_and_bio/controller/photo_and_bio_controller.dart';
import 'package:mama_app/features/post_auth_setup/setup_profile/controller/setup_profile_controller.dart';
import 'package:mama_app/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/services/post_signup_set_profile/post_signup_set_profile_service.dart';
import '../../../main_tabs/home/sub_feature/profile/controller/profile_controller.dart';

class FinishSettingProfileController extends GetxController {
  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// 🔹 Dynamic stage list
  List<FinishSetupUIDataModel> get featureList => [
    FinishSetupUIDataModel(
      leftIcon: Assets.icons.joinConversation,
      title: "Join conversation",
    ),
    FinishSetupUIDataModel(
      leftIcon: Assets.icons.exploreComm,
      title: "Explore Communities",
    ),
    FinishSetupUIDataModel(
      leftIcon: Assets.icons.liveSession,
      title: "Attend experts sessions",
    ),
    FinishSetupUIDataModel(
      leftIcon: Assets.icons.connectWMums,
      title: "Connect with mums nearby",
    ),
  ];

  /// 🔹 Unfocus
  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // find all controller of the stages
  final setUpCtrler = findCont<SetupProfileController>();
  final photoAndBioCtrler = findCont<PhotoAndBioController>();
  final lifestyleCtrler = findCont<LifestyleAndInterestsController>();
  final mumStageCtrler = findCont<MumsStageController>();

  /// 🔹 Continue
  void onTapContinue(GlobalKey<FormState> formKey) async {
    if (isLoading_.value) {
      // Snack.showWarning(Strings.mustSelectOne);
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    // TODO: Save all to backend
    // Call API here
    final success = await PostSignupSetProfileService().uploadCompleteProfile(
      name: setUpCtrler.nameCtrl.text.trim(),
      dob: convertDobToTimestamp(setUpCtrler.selectedDob.value),
      state: setUpCtrler.selectedState.value,
      city: setUpCtrler.selectedCity.value,

      bioDes: photoAndBioCtrler.bioDesCtrl.text.trim(),
      profileImage: photoAndBioCtrler.fileImage.value,
      interestedFields: lifestyleCtrler.selectedItems.value.toList(),
      mumStage: mumStageCtrler.selectedStage.value,
    );

    if (success) {
      Get.toNamed(RoutePaths.welcomeFundingMum);

      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchMyProfile();
      }
    }

    isLoading_.value = false;
  }

  void onTapFinish() {
    Get.offAllNamed(RoutePaths.subChoosePlan);
  }
}

class FinishSetupUIDataModel {
  final String leftIcon;
  final String title;

  FinishSetupUIDataModel({required this.leftIcon, required this.title});
}
