import 'package:mama_app/core/helpers/string_helper.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/helpers/bottom_sheet_helper.dart';

class SetupProfileController extends GetxController {
  // 🔹 Text Controller (only for name input field)
  final nameCtrl = TextEditingController();

  // 🔹 Reactive values (for popup selections)
  final selectedDob = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  final keepDobPrivate = false.obs;
  void toggleKeepDobPrivate() => keepDobPrivate.toggle();

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

    unfocusAll();
  }

  Future<void> onTapContinueSetUp(GlobalKey<FormState> formKey) async {
    final isValid = validateForm(formKey);

    if (!isValid || isLoading_.value) return;

    if (selectedDob.value.trim().isEmpty ||
        selectedState.value.trim().isEmpty ||
        selectedCity.value.trim().isEmpty) {
      Snack.showWarning("All Fields must be filled");
      return;
    }

    unfocusAll();
    isLoading_.value = true;

    log("DOB: ${selectedDob.value}");
    log("State: ${selectedState.value}");
    log("City: ${selectedCity.value}");

    Get.toNamed(RoutePaths.photoAndBio);

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
