import 'package:get/get.dart';
import 'package:mama_app/features/main_tabs/community/controller/manage_community_controller.dart';
import 'package:mama_app/features/main_tabs/community/controller/post_details_controller.dart';
import 'package:mama_app/features/main_tabs/community/controller/post_in_community_controller.dart';
import 'package:mama_app/features/more/about/controller/about_controller.dart';
import 'package:mama_app/features/more/blocked_user/controller/blocked_user_controller.dart';
import 'package:mama_app/features/shared/subscription_upgrade/controller/subscription_upgrade_controller.dart';
import 'package:mama_app/features/shared/wave_request/controller/wave_request_controller.dart';

import '../../features/account_overview/account_settings/controller/account_settings_controller.dart';
import '../../features/account_overview/change_password/controller/change_password_controller.dart';
import '../../features/auth/forgot_password/controller/forgot_password_controller.dart';
import '../../features/auth/otp/controller/verify_otp_controller.dart';
import '../../features/auth/signin/controller/signin_controller.dart';
import '../../features/auth/signup/controller/signup_controller.dart';
import '../../features/entry/onboard/controller/onboard_controller.dart';
import '../../features/entry/splash/controller/splash_controller.dart';
import '../../features/main_nav/controller/main_nav_controller.dart';
import '../../features/main_tabs/chat/controller/chat_controller.dart';
import '../../features/main_tabs/chat/controller/chat_inbox_controller.dart';
import '../../features/main_tabs/community/controller/community_controller.dart';
import '../../features/main_tabs/community/controller/community_detail_controller.dart';
import '../../features/main_tabs/community/controller/create_community_controller.dart';
import '../../features/main_tabs/community/controller/member_management_controller.dart';
import '../../features/main_tabs/experts/controller/experts_controller.dart';
import '../../features/main_tabs/experts/controller/past_sessions_controller.dart';
import '../../features/main_tabs/home/controller/home_controller.dart';
import '../../features/main_tabs/home/sub_feature/edit_profile/controller/edit_profile_controller.dart';
import '../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../features/main_tabs/match/controller/match_controller.dart';
import '../../features/more/legal/privacy_policy/controller/privacy_policy_controller.dart';
import '../../features/more/legal/terms_and_conditions/controller/terms_and_conditions_controller.dart';
import '../../features/more/notification/controller/notification_controller.dart';
import '../../features/more/support/contact_support/controller/contact_support_controller.dart';
import '../../features/payment/controller/payment_controller.dart';
import '../../features/post_auth_setup/lifestyle_and_interests/controller/lifestyle_and_interests_controller.dart';
import '../../features/post_auth_setup/mums_stage/controller/mums_stage_controller.dart';
import '../../features/post_auth_setup/photo_and_bio/controller/photo_and_bio_controller.dart';
import '../../features/post_auth_setup/setup_profile/controller/setup_profile_controller.dart';
import '../../features/post_auth_setup/subscription_choose_plan/controller/subscription_choose_plan_controller.dart';
import '../../features/post_auth_setup/welcome_funding_mum/controller/welcome_funding_mum_controller.dart';
import '../../features/shared/bookmark/controller/bookmark_controller.dart';
import '../../features/shared/mood/mood_insights/controller/mood_insights_controller.dart';
import '../../features/shared/mood/mood_library/controller/mood_library_controller.dart';
import '../../features/shared/report_sheet/controller/report_controller.dart';
import '../../features/shared/subscription_info/controller/subscription_info_controller.dart';
import '../../features/station_location/controller/station_location_controller.dart';
import '../../features/video_meeting/controller/meeting_comment_controller.dart';
import '../../features/video_meeting/controller/meeting_controller.dart';
import '../components/mood_check_in/mood_check_in_controller.dart';
import '../enums/app_enums.dart';
import '../enums/ui_enums.dart';
import '../network/helpers/network_helpers.dart';
import '../state_screens/success/controller/success_controller.dart';
import '../utils/extension/binding_extensions.dart';

// ─────────────────────────────
// 🔹 Splash & Onboarding Flow
// ─────────────────────────────
class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPutFenix(() => SplashController());
    Get.lazyPutFenix(() => OnboardController());
  }
}

// ─────────────────────────────
// 🔹 Auth Flow (Login/Signup/Forgot Password/Otp)
// ─────────────────────────────
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

class ForgotPasswordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
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
      ),
    );
  }
}

// ─────────────────────────────
// 🔹 Post-Signup Setup / Onboarding Steps
// ─────────────────────────────
class PostSignupScreensBinding extends Bindings {
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

// ─────────────────────────────
// 🔹 Main Navigation / Home Flow
// ─────────────────────────────
class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent
    Get.putPermanent(StationLocationController());
    Get.putPermanent(ProfileController());
    Get.putPermanent(MoodCheckInController());
    Get.putPermanent(HomeController());
    Get.putPermanent(MainNavController());

    Get.putPermanent(BookmarkController());

    // Lazy (auto recreate if disposed)
    Get.lazyPutFenix(() => ChatController());
    Get.lazyPutFenix(() => MatchController());
    Get.lazyPutFenix(() => CommunityController());
    Get.lazyPutFenix(() => ExpertsController());

    // Page controllers
    Get.lazyPutFenix(() => EditProfileController());
    Get.lazyPutFenix(() => SuccessController());
    Get.lazyPutFenix(() => PrivacyPolicyController());
    Get.lazyPutFenix(() => PaymentController());
  }
}

// ─────────────────────────────
// 🔹 Main Tab's extended pages
// ─────────────────────────────
class ChatInboxBinding extends Bindings {
  @override
  void dependencies() {
    ///////////
    final args = Get.arguments;
    print("--> args: $args");

    if (args == null || args is! String) {
      throw Exception("ChatInboxController requires a String argument!");
    }

    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => ChatInboxController(args));
  }
}

class CreateCommunityBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => CreateCommunityController());
  }
}

class ManageCommunityBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => ManageCommunityController());
  }
}

class MemberManagementBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => MemberManagementController());
  }
}

class ReportControllerBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context
    // Use Get.put for global, immediate instantiation
    Get.put(ReportController(), permanent: true);
  }
}

// CommunityDetailBinding:
class CommunityDetailBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    final btnState = args['btnState'] as MyCommunityBtnState;
    final isAlreadyMember = args['isAlreadyMember'] as bool;

    // ← delete old instance first, then create fresh
    if (Get.isRegistered<CommunityDetailController>()) {
      Get.delete<CommunityDetailController>(force: true);
    }

    Get.put(CommunityDetailController(btnState, isAlreadyMember)); // ← put, not lazyPut
  }
}

class PostInCommunityBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => PostInCommunityController());
  }
}

class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => PostDetailsController());
  }
}

class PastSessionsBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => PastSessionsController());
  }
}

class SubscriptionUpgradeBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => SubscriptionUpgradeController());
  }
}

class SubscriptionInfoBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    Get.lazyPutFenix(() => SubscriptionInfoController());
  }
}

// ─────────────────────────────
// 🔹 Account & Profile Settings
// ─────────────────────────────
class AccountSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSettingsController>(() => AccountSettingsController());
  }
}

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}

class BlockedUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockedUserController>(() => BlockedUserController());
  }
}

class AboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(() => AboutController());
  }
}

class BankDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<BankDetailsController>(() => BankDetailsController());
  }
}

// ─────────────────────────────
// 🔹 Support / Policies
// ─────────────────────────────
class ContactSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactSupportController>(() => ContactSupportController());
  }
}

class TermsAndConditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndConditionsController>(() => TermsAndConditionsController());
  }
}

// ─────────────────────────────
// 🔹 Notifications
// ─────────────────────────────
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}

// ─────────────────────────────
// 🔹 Individual but Shared
// ─────────────────────────────
class MoodLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodLibraryController>(() => MoodLibraryController());
  }
}

class MoodInsightBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    final mood = args['mood'] as MoodType;
    final item = args['item'] as MoodReadingItem;

    Get.put<MoodInsightsController>(MoodInsightsController(mood, item));
    Get.lazyPutFenix(() => BookmarkController());
  }
}

class WaveRequestBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context
    Get.lazyPut<WaveRequestController>(() => WaveRequestController());
  }
}

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;

    // Example for conditional controller injection
    // if (args is CustomerOrderDetailsArg_Model) {
    //   Get.lazyPut<CustomerOrderDetailsController>(() => CustomerOrderDetailsController(args));
    // } else if (args is SupplierOrderDetailsArg_Model) {
    //   Get.lazyPut<SupplierOrderDetailsController>(() => SupplierOrderDetailsController(args));
    // }
  }
}

// ─────────────────────────────
// 🔹 Maps & Location
// ─────────────────────────────
class GoogleMapBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<GoogleMapController>(() => GoogleMapController());
  }
}

// ─────────────────────────────
// 🔹 Misc / Meeting
// ─────────────────────────────
class MeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetingController>(() => MeetingController(), fenix: true);
    Get.lazyPut<MeetingCommentController>(() => MeetingCommentController(), fenix: true);
  }
}
