import 'package:image_picker/image_picker.dart';

import '../../../../../../app/controller_export.dart';
import '../../../../../../core/helpers/widgets_helper.dart';
import '../../../../../../core/utils/extension/string_extension.dart';
import '../../../../../../app/controller_export.dart';
import '../../../../../../core/helpers/date_helper.dart';
import '../../../../../../core/helpers/string_helper.dart';
import '../../../../../../core/services/account_overview/update_profile/update_profile_service.dart';
import '../../../../../../core/utils/extension/string_extension.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/model/profile_model.dart'; 
 

class EditProfileController extends GetxController {
  // 🔹 Text Controller (only for name input field)
  final nameCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  // 🔹 Reactive values (for popup selections)
  final selectedDob = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  // Focus Node (only needed for actual text field)
  final nameFocus = FocusNode();
  final bioFocus = FocusNode();

  /// 🔹 Unfocus all fields
  void unfocusAll() {
    nameFocus.unfocus();
    bioFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    nameFocus.dispose();
    bioCtrl.dispose();
    bioFocus.dispose();
    super.onClose();
  }

  void openStateBottomSheet() {
    showSelectionBottomSheet(
      title: Strings.chooseYourState,
      items: StateAndCityData.states,
      selectedValue: selectedState,
    );
  }

  void openCityBottomSheet() {
    showSelectionBottomSheet(
      title: Strings.chooseYourCity,
      items: StateAndCityData.getCities(selectedState.value),
      selectedValue: selectedCity,
    );
  }
  void openChildrenBottomSheet() {
    showChildrenBottomSheet();
  }

    RxList<RxString> childrenDob = <RxString>[].obs;

  void addChild() {
    childrenDob.add("".obs);
  }

  void removeChild(int index) {
    childrenDob.removeAt(index);
  }

  void updateDob(int index, String value) {
    childrenDob[index].value = value;
  }

  @override
  void onInit() {
    super.onInit();

    // Pre-fill fields with stored user data
    _initializeFieldsFromStorage();
  }

  @override
  void _initializeFieldsFromStorage() {
    nameCtrl.text = storage.getUsername;
    fileImage.value = null; // Reset selected image
    fileImages.value = null;
  }

  @override
  void onReady() {
    super.onReady();
    _initializeFieldsFromStorage(); // ensures fields are filled
  }

  void clearForm() {
    nameCtrl.clear();
    bioCtrl.clear();

    fileImage.value = null;
    fileImages.value = null;

    selectedDob.value = '';
    selectedState.value = '';
    selectedCity.value = '';

    unfocusAll();
  }

  var fileImage = Rxn<XFile>();
  Future<void> pickSingleImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? selectedImage = await picker.pickImage(
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

  //////////////////////
  ///
  var fileImages = Rxn<List<XFile>>([]);

  Future<void> pickMultipleImage() async {
    final picker = ImagePicker();

    final current = fileImages.value ?? [];
    final remaining = 4 - current.length;

    if (remaining <= 0) {
      "You can't add more than 4 images"
          .showToast(); // ← replace with your toast util
      return;
    }

    final List<XFile> selectedImages = await picker.pickMultiImage(
      limit: remaining,
    );

    if (selectedImages.isEmpty) return;

    // Merge old + new, cap at 4
    final merged = [...current, ...selectedImages];
    final capped = merged.take(4).toList();

    if (merged.length > 4) {
      "Max 4 images allowed. Only ${remaining} image(s) were added."
          .showToast();
    }

    fileImages.value = capped;

    print("Total images: ${capped.length}");
    print("files.first.name: ${capped.first.name}");
    print("files.first.path: ${capped.first.path}");
  }

  ///

  void removeImage(int index) {
    final current = List<XFile>.from(fileImages.value ?? []);
    current.removeAt(index);
    fileImages.value = current;
  }
  ////////////////////

  final _service = UpdateProfileService();

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;
  final termsData = Rxn<ProfileDataModel>();
  final errorMessage = RxnString();

  Future<void> updateProfileDetails({
    required String name,
 
    XFile? profileImage,
    required GlobalKey<FormState> formkey,
  }) async {
    final isValid = validateForm(formkey);
    if (!isValid || isLoading_.value) return; // <-- removed termsData check

    errorMessage.value = null;
    isLoading_.value = true;

    final data = await _service.updateProfile(
      name: name,
      
      profileImage: profileImage,
    );

    if (data != null) {
      // Save updated data to storage
      // storage.setUserImageUrl(data.image ?? '');
      // storage.setUsername(data.name ?? '');
      // storage.setUserPhone(data.phone ?? '');
      // storage.setUserAvgRating((data.averageRating ?? 0.0).toString());
      // storage.setUserTotalRating((data.totalRating ?? 0).toString());

      // Update controllers immediately
      nameCtrl.text = data.name ?? ''; 
      fileImage.value = null;

      // Update reactive data
      termsData.value = data;

      // also fetch getProfile to update any other details
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.fetchMyProfile(); // fetch latest profile data
      }
    } else {
      errorMessage.value = "Failed to load terms. Pull to refresh.";
    }

    isLoading_.value = false;
  }

   
}
