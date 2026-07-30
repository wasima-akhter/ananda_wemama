import '../../../../app/controller_export.dart';
import '../../../../core/services/auth/verify_otp_service.dart';

class VerifyOtpController extends GetxController {
  VerifyOtpController({
    this.flowType = OtpFlowType.signup,
    required this.email,
  });

  final OtpFlowType flowType; //  which flow is using this OTP screen
  final String email;

  TextEditingController otpCntrler = TextEditingController();
  final otpFocusNode = FocusNode();

  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  var isResendLoading_ = false.obs;
  bool get isResendLoading => isResendLoading_.value;

  var showTimer_ = false.obs;
  bool get showTimer => showTimer_.value;

  var isOtpResent_ = false.obs;
  bool get isOtpResent => isOtpResent_.value;

  void onTapVerify() async {
    if (isLoading_.value) return;
    if (otpCntrler.text.trim().isEmpty || otpCntrler.text.length < 6) return;

    isLoading_.value = true;

    final success = await VerifyOtpService().verify(
      email: email,
      otp: otpCntrler.text,
    );

    isLoading_.value = false;

    if (success) {
      showTimer_.value = true;

      /// 🔥 FLOW BASED NAVIGATION
      if (flowType == OtpFlowType.signup) {
        // Existing behavior (UNCHANGED)

        // save the access token in storage
        // ✅ Small delay ensures storage write completes before next screen loads
        await Future.delayed(const Duration(milliseconds: 500));
        // mock code for design
        Get.offAllNamed(RoutePaths.setupProfile);
        storage.setLoggedIn(true);
        storage.setSeenOnboarding(true);
      } else if (flowType == OtpFlowType.forgotPassword) {
        // 👈 NEW BEHAVIOR
        Get.back(result: true); // go back and tell previous screen OTP verified
      }
    }
  }

  void onTapResendOtp() async {
    if (isResendLoading_.value) return;

    isResendLoading_.value = true;

    final success = await VerifyOtpService().resendOtp(email: email);

    isResendLoading_.value = false;

    if (success) {
      isOtpResent_.value = true;
      showTimer_.value = true;
    }
  }

  @override
  void onClose() {
    otpCntrler.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}


//  () {


//                     if (roleId == 1) Get.toNamed(RoutePaths.signin);
//                     if (roleId == 2) Get.toNamed(RoutePaths.uploadDocument);
//                   },
