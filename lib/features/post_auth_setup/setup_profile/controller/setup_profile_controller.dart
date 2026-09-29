import 'package:we_mama/core/helpers/string_helper.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/helpers/bottom_sheet_helper.dart';

class SetupProfileController extends GetxController {
  static SetupProfileController get to => Get.find<SetupProfileController>();
  // 🔹 Text Controller (only for name input field)
  final nameCtrl = TextEditingController();

  // 🔹 Reactive values (for popup selections)
  final nameError = ''.obs;
  final selectedDob = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  final keepDobPrivate = false.obs;
  void toggleKeepDobPrivate() => keepDobPrivate.toggle();

  // Focus Node (only needed for actual text field)
  final nameFocus = FocusNode();

  // Errors
  final dobError = ''.obs;
  final stateError = ''.obs;
  final cityError = ''.obs;

  late Worker _dobWorker;
  late Worker _stateWorker;
  late Worker _cityWorker;

  @override
  void onInit() {
    super.onInit();

    _dobWorker = bindValidation(value: selectedDob, error: dobError);

    _stateWorker = bindValidation(value: selectedState, error: stateError);

    _cityWorker = bindValidation(value: selectedCity, error: cityError);

    nameCtrl.addListener(() {
      if (nameCtrl.text.trim().isNotEmpty && nameError.value.isNotEmpty) {
        nameError.value = '';
      }
    });
  }

  @override
  void onClose() {
    _dobWorker.dispose();
    _stateWorker.dispose();
    _cityWorker.dispose();

    nameCtrl.dispose();
    nameFocus.dispose();

    super.onClose();
  }

  bool validateSelections() {
    bool isValid = true;

    nameError.value = '';
    dobError.value = '';
    stateError.value = '';
    cityError.value = '';

    final nameValidation = validateName(nameCtrl.text.trim());

    if (nameValidation != null) {
      nameError.value = nameValidation;
      isValid = false;
    }

    if (selectedDob.value.trim().isEmpty) {
      dobError.value = 'Date of birth is required';
      isValid = false;
    }

    if (selectedState.value.trim().isEmpty) {
      stateError.value = 'State is required';
      isValid = false;
    }

    if (selectedCity.value.trim().isEmpty) {
      cityError.value = 'City is required';
      isValid = false;
    }

    return isValid;
  }

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

    unfocusAll();
  }

  Future<void> onTapContinueSetUp(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;
    if (!validateSelections()) {
      return;
    }
    unfocusAll();
    isLoading_.value = true;

    print("DOB: ${selectedDob.value}");
    print("State: ${selectedState.value}");
    print("City: ${selectedCity.value}");

    Get.toNamed(RoutePaths.mumsStage);

    isLoading_.value = false;
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
