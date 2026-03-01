import '../../../../app/controller_export.dart';
import '../../../../core/config/app_info.dart';

class SigninController extends GetxController {
  TextEditingController emailCtrler = TextEditingController();
  TextEditingController passwordCtrler = TextEditingController();

  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  var showPassword = false.obs;
  bool get isPassHidden => showPassword.value;

  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  IconData get passwordIcon => !showPassword.value ? Icons.visibility_off : Icons.visibility;

  void toggleEye() => showPassword.toggle();

  /// 🔹 Remove focus from all fields (prevents keyboard bugs on nav)
  void unfocusAll() {
    emailFocus.unfocus();
    passFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 🔹 Clear inputs + reset UI state
  void clearFields() {
    emailCtrler.clear();
    passwordCtrler.clear();
    showPassword.value = false;
    unfocusAll();
  }

  @override
  void onInit() {
    print("baseUrl: $baseUrl");
    super.onInit();
  }

  Future<void> onTapLogin(GlobalKey<FormState> signInFormKey) async {
    // final isValid = validateForm(signInFormKey);
    // if (!isValid || isLoading_.value) return;

    unfocusAll(); // 👈 important

    print("LOGIN STARTED");

    isLoading_.value = true;

    try {
      // final success = await SigninService().signIn(
      //   email: emailCtrler.text.trim(),
      //   password: passwordCtrler.text.trim(),
      // );

      // print("LOGIN RESPONSE: $success");

      // if (success) {
      //   storage.setLoggedIn(true);
      clearFields();
      unfocusAll();
      Get.offAllNamed(RoutePaths.mainNav);
      // } else {
      //   print("LOGIN FAILED");
      // }
    } catch (e, s) {
      print("LOGIN ERROR: $e");
      print(s);
    } finally {
      isLoading_.value = false;
      print("LOGIN FINISHED");
    }
  }

  @override
  void onClose() {
    emailCtrler.dispose();
    passwordCtrler.dispose();

    emailFocus.dispose(); // 🔥 missing before
    passFocus.dispose(); // 🔥 missing before

    super.onClose();
  }
}
