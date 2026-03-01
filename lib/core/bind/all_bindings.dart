import 'package:get/get.dart';
import 'package:mama_app/views/post_auth_setup/mums_stage/controller/mums_stage_controller.dart';
import 'package:mama_app/views/post_auth_setup/photo_and_bio/controller/photo_and_bio_controller.dart';
import 'package:mama_app/views/post_auth_setup/subscription_choose_plan/controller/subscription_choose_plan_controller.dart';
import 'package:mama_app/views/post_auth_setup/welcome_funding_mum/controller/welcome_funding_mum_controller.dart';

import '../../views/account_overview/account_settings/controller/account_settings_controller.dart';
import '../../views/account_overview/change_password/controller/change_password_controller.dart';
import '../../views/account_overview/edit_profile/controller/edit_profile_controller.dart';
import '../../views/auth/forgot_password/controller/forgot_password_controller.dart';
import '../../views/auth/otp/controller/verify_otp_controller.dart';
import '../../views/auth/signin/controller/signin_controller.dart';
import '../../views/auth/signup/controller/signup_controller.dart';
import '../../views/contact_support/controller/contact_support_controller.dart';
import '../../views/home/controller/home_controller.dart';
import '../../views/main_nav/controller/main_nav_controller.dart';
import '../../views/notification/controller/notification_controller.dart';
import '../../views/onboard/controller/onboard_controller.dart';
import '../../views/payment/controller/payment_controller.dart';
import '../../views/post_auth_setup/lifestyle_and_interests/controller/lifestyle_and_interests_controller.dart';
import '../../views/post_auth_setup/setup_profile/controller/setup_profile_controller.dart';
import '../../views/profile/controller/profile_controller.dart';
import '../../views/review_and_rating/controller/review_and_rating_controller.dart';
import '../../views/splash/controller/splash_controller.dart';
import '../../views/static_pages/privacy_policy/controller/privacy_policy_controller.dart';
import '../../views/static_pages/terms_and_conditions/controller/terms_and_conditions_controller.dart';
import '../../views/station_location/controller/station_location_controller.dart';
import '../../views/video_meeting/controller/meeting_controller.dart';
import '../enums/app_enums.dart';
import '../network/helpers/network_helpers.dart';
import '../state_screens/success/controller/success_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<OnboardController>(() => OnboardController(), fenix: true);

    // Get.lazyPut<SetLocationController>(() => SetLocationController());
  }
}

class MeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetingController>(() => MeetingController(), fenix: true);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<MeetingController>(() => MeetingController(), fenix: true);
  }
}

class ForgotPasswordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}

class SigninScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SigninController>(() => SigninController());
  }
}

class SignupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}

class PostSigupScreensAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetupProfileController>(() => SetupProfileController());
    Get.lazyPut<PhotoAndBioController>(() => PhotoAndBioController());
    Get.lazyPut<LifestyleAndInterestsController>(() => LifestyleAndInterestsController());
    Get.lazyPut<MumsStageController>(() => MumsStageController());
    Get.lazyPut<SubscriptionChoosePlanController>(() => SubscriptionChoosePlanController());
    Get.lazyPut<WelcomeFundingMumController>(() => WelcomeFundingMumController());
  }
}

class OtpScreenBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;

    Get.lazyPut<VerifyOtpController>(
      () => VerifyOtpController(
        flowType: args?['flow'] ?? OtpFlowType.signup,
        email: args?['email'] ?? storage.getUserEmail,
      ), // fallback for signup
    );
  }
}

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StationLocationController(), permanent: true);
    // 🔥 CREATE PROFILE FIRST
    Get.put(ProfileController(), permanent: true);

    Get.put(HomeController(), permanent: true);

    // THEN MainNav can safely find it
    Get.put(MainNavController(), permanent: true);

    Get.lazyPut<EditProfileController>(() => EditProfileController());
    Get.lazyPut<SuccessController>(() => SuccessController());
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());

    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}

class AccountSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSettingsController>(() => AccountSettingsController());
  }
}

class BankDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<BankDetailsController>(() => BankDetailsController());
  }
}

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}

class ContactSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactSupportController>(() => ContactSupportController());
  }
}

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;

    // if (args is CustomerOrderDetailsArg_Model) {
    //   Get.lazyPut<CustomerOrderDetailsController>(() => CustomerOrderDetailsController(args));
    // } else if (args is SupplierOrderDetailsArg_Model) {
    //   Get.lazyPut<SupplierOrderDetailsController>(() => SupplierOrderDetailsController(args));
    // }
  }
}

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

class GoogleMapBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<GoogleMapController>(() => GoogleMapController());
  }
}

class TermsAndConditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndConditionsController>(() => TermsAndConditionsController());
  }
}

class ReviewAndRatingBinding extends Bindings {
  @override
  void dependencies() {
    final supplierId = Get.arguments as String;
    Get.lazyPut<ReviewAndRatingController>(() => ReviewAndRatingController(supplierId));
  }
}
