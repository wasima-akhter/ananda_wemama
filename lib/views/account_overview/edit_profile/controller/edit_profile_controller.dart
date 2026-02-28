import 'package:image_picker/image_picker.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/update_profile/update_profile_service.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../../profile/model/profile_model.dart';

class EditProfileController extends GetxController {
  var fileImage = Rxn<XFile>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // Focus nodes
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();

    // Pre-fill fields with stored user data
    _initializeFieldsFromStorage();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    nameFocus.dispose();
    phoneFocus.dispose();
    super.onClose();
  }

  void _initializeFieldsFromStorage() {
    nameCtrl.text = storage.getUsername;
    phoneCtrl.text = storage.getUserPhone;
    fileImage.value = null; // Reset selected image
  }

  @override
  void onReady() {
    super.onReady();
    _initializeFieldsFromStorage(); // ensures fields are filled
  }

  void clearForm() {
    nameCtrl.clear();
    phoneCtrl.clear();

    nameFocus.unfocus();
    phoneFocus.unfocus();
    fileImage.value = null;
  }

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

  final _service = UpdateProfileService();

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;
  final termsData = Rxn<ProfileDataModel>();
  final errorMessage = RxnString();

  Future<void> updateProfileDetails({
    required String name,
    String? phone,
    XFile? profileImage,
    required GlobalKey<FormState> formkey,
  }) async {
    final isValid = validateForm(formkey);
    if (!isValid || isLoading_.value) return; // <-- removed termsData check

    errorMessage.value = null;
    isLoading_.value = true;

    final data = await _service.updateProfile(name: name, phone: phone, profileImage: profileImage);

    if (data != null) {
      // Save updated data to storage
      storage.setUserImageUrl(data.image ?? '');
      storage.setUsername(data.name ?? '');
      storage.setUserPhone(data.phone ?? '');
      storage.setUserAvgRating((data.averageRating ?? 0.0).toString());
      storage.setUserTotalRating((data.totalRating ?? 0).toString());

      // Update controllers immediately
      nameCtrl.text = data.name ?? '';
      phoneCtrl.text = data.phone ?? '';
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
