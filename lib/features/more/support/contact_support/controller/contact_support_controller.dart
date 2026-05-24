import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/services/more/support/contact_support/contact_support_service.dart';
import '../../../../../core/utils/validator/validators.dart';

class ContactSupportController extends GetxController {
  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  // Focus nodes
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final messageFocus = FocusNode();

  // Loading state
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    messageCtrl.dispose();

    nameFocus.dispose();
    emailFocus.dispose();
    messageFocus.dispose();

    super.onClose();
  }

  void clearForm() {
    nameCtrl.clear();
    emailCtrl.clear();
    messageCtrl.clear();

    nameFocus.unfocus();
    emailFocus.unfocus();
    messageFocus.unfocus();
  }

  Future<void> onTapSubmit({required GlobalKey<FormState> formKey}) async {
    final isValid = validateForm(formKey);

    // STOP if invalid OR already loading
    if (!isValid || isLoading_.value) return;

    isLoading_.value = true;

    final success = await ContactSupportService().sendSupportMsg(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      messageDes: messageCtrl.text.trim(),
    );

    isLoading_.value = false;

    if (success) {
      clearForm();
    }
  }
}
