import 'package:image_picker/image_picker.dart';
import 'package:we_mama/features/post_auth_setup/add_children/controller/add_children_controller.dart';
import 'package:we_mama/features/post_auth_setup/lifestyle_and_interests/controller/lifestyle_and_interests_controller.dart';
import 'package:we_mama/features/post_auth_setup/mums_stage/controller/mums_stage_controller.dart';
import 'package:we_mama/features/post_auth_setup/setup_profile/controller/setup_profile_controller.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/services/post_signup_set_profile/post_signup_set_profile_service.dart';
import '../../../main_tabs/home/sub_feature/profile/controller/profile_controller.dart';

class PhotoAndBioController extends GetxController {
  // 🔹 Text Controller (only for name input field)
  final bioDesCtrl = TextEditingController();

  var fileImage = Rxn<XFile>();

  // Focus Node (only needed for actual text field)
  final bioDesFocus = FocusNode();

  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  //
  final bioText = ''.obs;
  late Worker _bioWorker;
  final bioError = ''.obs;

  @override
  void onInit() {
    super.onInit();

    bioDesCtrl.addListener(() {
      bioError.value = validateBioDescription(bioDesCtrl.text.trim()) ?? '';
    });
  }

  /// 🔹 Unfocus all fields
  void unfocusAll() {
    bioDesFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Clear all inputs
  void clearAll() {
    bioDesCtrl.clear();

    fileImage.value = null;

    unfocusAll();
  }

  Future<void> pickSingleImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? selectedImage = await picker.pickImage(
      imageQuality: 60,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    GNav.pop();

    if (selectedImage != null) {
      fileImage.value = selectedImage;

      print("file.name: ${selectedImage.name}");
      print("file.path: ${selectedImage.path}");
    }
  }
  /////

  Future<void> onTapContinuePhoto(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;

    /// 🔴 Image validation
    if (fileImage.value == null) {
      Snack.showWarning(title: "Required", "Please select a photo");
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    Get.toNamed(RoutePaths.addBio);

    isLoading_.value = false;
  }

  bool validateSelections() {
    final validation = validateBioDescription(bioDesCtrl.text.trim());

    bioError.value = validation ?? '';

    return validation == null;
  }

  Future<void> onTapContinueBio(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;

    if (!validateSelections()) {
      return;
    }

    unfocusAll();

    await onTapFinishCompleteProfile(formKey);
  }

  //

  // find all controller of the stages
  final setUpCtrler = findCont<SetupProfileController>();
  final lifestyleCtrler = findCont<LifestyleAndInterestsController>();
  final mumStageCtrler = findCont<MumsStageController>();
  final childrenCtrler = findCont<AddChildrenController>();

  /// 🔹 Continue
  Future<void> onTapFinishCompleteProfile(GlobalKey<FormState> formKey) async {
    if (isLoading_.value) {
      // Snack.showWarning(Strings.mustSelectOne);
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    final List<Map<String, String>> childrenPayload = childrenCtrler
        .children
        .value
        .map((child) {
          return {
            'gender': mapGender(child.gender.name.toString()),
            'dob': child.dateOfBirth.toString(),
          };
        })
        .toList();

    // TODO: Save all to backend
    // Call API here
    final success = await PostSignupSetProfileService().uploadCompleteProfile(
      name: setUpCtrler.nameCtrl.text.trim(),
      dob: convertDobToTimestamp(setUpCtrler.selectedDob.value),
      state: setUpCtrler.selectedState.value,
      city: setUpCtrler.selectedCity.value,
      bioDes: bioDesCtrl.text.trim(),
      profileImage: fileImage.value,
      interestedFields: lifestyleCtrler.selectedItems.value.toList(),
      mumStages: mumStageCtrler.selectedStageTitles,
      isDobPrivate: setUpCtrler.keepDobPrivate.value,
      children: childrenPayload,
    );

    if (success) {
      Get.toNamed(RoutePaths.foundingMumCodeScreen);

      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchMyProfile();
      }
    }

    isLoading_.value = false;
  }

  String mapGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'boy':
        return 'Male';
      case 'girl':
        return 'Female';
      default:
        return gender;
    }
  }

  @override
  void onClose() {
    _bioWorker.dispose();

    bioDesCtrl.dispose();
    bioDesFocus.dispose();

    unfocusAll();

    super.onClose();
  }
}
