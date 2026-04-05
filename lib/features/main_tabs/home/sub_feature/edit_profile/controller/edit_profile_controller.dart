import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../../app/controller_export.dart';
import '../../../../../../core/helpers/bottom_sheet_helper.dart';
import '../../../../../../core/helpers/date_helper.dart';
import '../../../../../../core/helpers/string_helper.dart';
import '../../../../../../core/helpers/widgets_helper.dart';
import '../../../../../../core/services/account_overview/update_profile/update_profile_service.dart';
import '../../../../../../core/utils/extension/string_extension.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/model/profile_model.dart';
import '../model/child_model.dart';

class EditProfileController extends GetxController {
  // ─────────────────────────────────────────────
  // Text Controllers & Focus Nodes
  // ─────────────────────────────────────────────

  final nameCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final nameFocus = FocusNode();
  final bioFocus = FocusNode();

  @override
  void onClose() {
    nameCtrl.dispose();
    bioCtrl.dispose();
    nameFocus.dispose();
    bioFocus.dispose();
    super.onClose();
  }

  void unfocusAll() {
    nameFocus.unfocus();
    bioFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ─────────────────────────────────────────────
  // Reactive State
  // ─────────────────────────────────────────────

  final selectedDob = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;
  final keepDobPrivate = false.obs;

  final fileImage = Rxn<XFile>();
  final desImageFiles = Rxn<List<XFile>>([]);

  final children = <ChildModel>[].obs;

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final updatedProfileData = Rxn<ProfileDataModel>();
  final errorMessage = RxnString();

  final existingImageUrls = <String>[].obs; // server images

  // ─────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initializeFields();
  }

  void _initializeFields() {
    // ✅ pull from ProfileController if available
    final profileData = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>().userProfileData.value
        : null;

    if (profileData != null) {
      nameCtrl.text = profileData.name ?? storage.getUsername;
      bioCtrl.text = profileData.bio ?? '';

      // dob — convert DateTime back to display format
      if (profileData.dob != null) {
        selectedDob.value = formatDate(profileData.dob!); // your dd/MM/yyyy formatter
      }

      selectedState.value = profileData.state ?? '';
      selectedCity.value = profileData.city ?? '';

      // description images — existing server URLs as display
      // (these are strings, not XFile — handle separately in UI if needed)

      // children

      children.assignAll(
        profileData.children.map((e) {
          final child = ChildModel();

          debugPrint(' child.gender.value  : ${e.gender}');
          debugPrint(' child.dob.value  : ${e.dob}');
          child.gender.value = (e.gender?.toString() ?? '').toLowerCase();
          // parse timestamp back to display format
          final dobRaw = e.dob?.toString() ?? '';
          if (dobRaw.isNotEmpty) {
            final dt = DateTime.tryParse(dobRaw);
            if (dt != null) {
              child.dob.value = DateFormat("dd-MM-yyyy").format(dt);
            }
          }

          return child;
        }).toList(),
      );

      if (profileData != null) {
        existingImageUrls.assignAll(profileData.images.where((e) => e.trim().isNotEmpty).toList());
      }
    } else {
      // fallback to storage
      nameCtrl.text = storage.getUsername;
    }

    fileImage.value = null;
    desImageFiles.value = [];
  }

  // ─────────────────────────────────────────────
  // Bottom Sheets
  // ─────────────────────────────────────────────

  void toggleKeepDobPrivate() => keepDobPrivate.toggle();

  void openStateBottomSheet() => showSelectionBottomSheet(
    title: Strings.chooseYourState,
    items: StateAndCityData.states,
    selectedValue: selectedState,
  );

  void openCityBottomSheet() => showSelectionBottomSheet(
    title: Strings.chooseYourCity,
    items: StateAndCityData.getCities(selectedState.value),
    selectedValue: selectedCity,
  );

  void openChildrenBottomSheet() => showChildrenBottomSheet();

  // ─────────────────────────────────────────────
  // Children
  // ─────────────────────────────────────────────

  void addChild() => children.add(ChildModel());
  void removeChild(int index) => children.removeAt(index);
  void updateChildDob(int index, String value) => children[index].dob.value = value;
  void updateChildGender(int index, String value) => children[index].gender.value = value;

  // ─────────────────────────────────────────────
  // Image Picking
  // ─────────────────────────────────────────────

  Future<void> pickSingleImage(ImageSource source) async {
    final picker = ImagePicker();
    final selected = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    GNav.pop();
    if (selected != null) fileImage.value = selected;
  }

  Future<void> pickMultipleImage() async {
    final picker = ImagePicker();
    final current = desImageFiles.value ?? [];
    final remaining = 4 - current.length;

    if (remaining <= 0) {
      "You can't add more than 4 images".showToast();
      return;
    }

    final List<XFile> selected = remaining == 1
        ? [if (await picker.pickImage(source: ImageSource.gallery) case final img?) img]
        : await picker.pickMultiImage(limit: remaining);

    if (selected.isEmpty) return;

    desImageFiles.value = [...current, ...selected].take(4).toList();
  }

  void removeImage(int index) {
    final current = List<XFile>.from(desImageFiles.value ?? []);
    current.removeAt(index);
    desImageFiles.value = current;
  }

  // ─────────────────────────────────────────────
  // Form Actions
  // ─────────────────────────────────────────────

  void clearForm() {
    nameCtrl.clear();
    bioCtrl.clear();
    fileImage.value = null;
    desImageFiles.value = [];
    selectedDob.value = '';
    selectedState.value = '';
    selectedCity.value = '';
    children.clear();
    unfocusAll();
  }

  Future<void> updateProfileDetails({required GlobalKey<FormState> formkey}) async {
    if (isLoading_.value) return;

    if (!_validateInputs(formkey)) return;

    errorMessage.value = null;
    isLoading_.value = true;

    unfocusAll();

    final data = await _service.updateProfileWithChildren(
      name: nameCtrl.text.trim(),
      descriptionImages: desImageFiles.value ?? [],
      dob: convertDobToTimestamp(selectedDob.value),
      state: selectedState.value,
      city: selectedCity.value,
      bio: bioCtrl.text.trim(),
      profileImage: fileImage.value,
      children: children.isEmpty
          ? null
          : children
                .map(
                  (e) => {
                    "gender": e.gender.value.cap,
                    "dob": convertChildDobToTimestamp(e.dob.value),
                  },
                )
                .toList(),
    );

    if (data != null) {
      storage.setUserImageUrl(data.profileImage ?? '');
      storage.setUsername(data.name ?? '');
      storage.setUserPhone(data.phone ?? '');

      updatedProfileData.value = data;
      // clearForm();
      nameCtrl.text = data.name ?? '';
      fileImage.value = null;

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().fetchMyProfile();
      }

      "Profile updated successfully".showToast();
    } else {
      errorMessage.value = "Failed to update data. Pull to refresh.";
    }

    isLoading_.value = false;
  }

  // ─────────────────────────────────────────────
  // Validations before uploading
  // ─────────────────────────────────────────────

  bool _validateInputs(GlobalKey<FormState> formkey) {
    /// Form field validation
    if (!validateForm(formkey)) return false;

    /// Name
    if (nameCtrl.text.trim().isEmpty) {
      "Name is required".showToast();
      return false;
    }

    /// Bio
    if (bioCtrl.text.trim().isEmpty) {
      "Bio is required".showToast();
      return false;
    }

    /// DOB
    if (selectedDob.value.trim().isEmpty) {
      "Date of birth is required".showToast();
      return false;
    }

    /// State
    if (selectedState.value.trim().isEmpty) {
      "State is required".showToast();
      return false;
    }

    /// City
    if (selectedCity.value.trim().isEmpty) {
      "City is required".showToast();
      return false;
    }

    /// Children validation (optional but recommended)
    for (int i = 0; i < children.length; i++) {
      final child = children[i];

      if (child.gender.value.trim().isEmpty) {
        "Child ${i + 1}: Gender is required".showToast();
        return false;
      }

      if (child.dob.value.trim().isEmpty) {
        "Child ${i + 1}: DOB is required".showToast();
        return false;
      }
    }

    /// Images validation (optional)
    // if ((desImageFiles.value ?? []).isEmpty && existingImageUrls.isEmpty) {
    //   "Please add at least one image".showToast();
    //   return false;
    // }

    return true;
  }
  // ─────────────────────────────────────────────
  // Private
  // ─────────────────────────────────────────────

  final _service = UpdateProfileService();
}
