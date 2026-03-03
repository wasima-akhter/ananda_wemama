import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/helpers/date_helper.dart';
import 'package:mama_app/core/helpers/string_helper.dart';

import '../../../../app/controller_export.dart';

class PhotoAndBioController extends GetxController {
  // 🔹 Text Controller (only for name input field)
  final nameCtrl = TextEditingController();

  var fileImage = Rxn<XFile>();

  // 🔹 Reactive values (for popup selections)
  final selectedDob = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  // Focus Node (only needed for actual text field)
  final nameFocus = FocusNode();

  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// 🔹 Unfocus all fields
  void unfocusAll() {
    nameFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Clear all inputs
  void clearAll() {
    nameCtrl.clear();
    selectedDob.value = '';
    selectedState.value = '';
    selectedCity.value = '';

    fileImage.value = null;

    unfocusAll();
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
  /////

  Future<void> onTapSignup(GlobalKey<FormState> signUpFormKey) async {
    final isValid = validateForm(signUpFormKey);

    if (!isValid || isLoading_.value) return;

    unfocusAll();
    isLoading_.value = true;

    print("DOB: ${selectedDob.value}");
    print("State: ${selectedState.value}");
    print("City: ${selectedCity.value}");

    isLoading_.value = false;
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    nameFocus.dispose();
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
}
