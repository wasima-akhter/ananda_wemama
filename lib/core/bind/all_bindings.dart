import 'package:get/get.dart';
import 'package:we_mama/core/models/ui/common_data_models.dart';
import 'package:we_mama/features/more/about/controller/about_controller.dart';
import 'package:we_mama/features/more/blocked_user/controller/blocked_user_controller.dart';
import 'package:we_mama/features/post_auth_setup/add_children/controller/add_children_controller.dart';
import 'package:we_mama/features/shared/subscription/subscription_upgrade/controller/subscription_upgrade_controller.dart';
import 'package:we_mama/features/shared/wave_request/controller/wave_request_controller.dart';
import 'package:we_mama/features/video_meeting/controller/live_chat_controller.dart';

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
import '../../features/main_tabs/community/core/controllers_shared/community_action_controller.dart';
import '../../features/main_tabs/community/create/controller/create_community_controller.dart';
import '../../features/main_tabs/community/detail/controller/community_detail_controller.dart';
import '../../features/main_tabs/community/feed/controller/community_controller.dart';
import '../../features/main_tabs/community/manage/controller/manage_community_controller.dart';
import '../../features/main_tabs/community/members/controller/member_management_controller.dart';
import '../../features/main_tabs/community/post/controller/create_post_controller.dart';
import '../../features/main_tabs/community/post/controller/post_action_controller.dart';
import '../../features/main_tabs/community/post/controller/post_details_controller.dart';
import '../../features/main_tabs/community/search/controller/community_search_controller.dart';
import '../../features/main_tabs/experts/controller/experts_controller.dart';
import '../../features/main_tabs/experts/controller/past_sessions_controller.dart';
import '../../features/main_tabs/experts/controller/session_action_controller.dart';
import '../../features/main_tabs/experts/controller/session_controller.dart';
import '../../features/main_tabs/home/controller/home_controller.dart';
import '../../features/main_tabs/home/sub_feature/edit_profile/controller/edit_profile_controller.dart';
import '../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../features/main_tabs/match/controller/match_controller.dart';
import '../../features/more/legal/privacy_policy/controller/privacy_policy_controller.dart';
import '../../features/more/legal/terms_and_conditions/controller/terms_and_conditions_controller.dart';
import '../../features/more/notification/controller/notification_controller.dart';
import '../../features/more/support/contact_support/controller/contact_support_controller.dart';
import '../../features/payment/controller/payment_controller.dart';
import '../../features/post_auth_setup/finish_setting_profile/controller/finish_setting_profile_controller.dart';
import '../../features/post_auth_setup/lifestyle_and_interests/controller/lifestyle_and_interests_controller.dart';
import '../../features/post_auth_setup/mums_stage/controller/mums_stage_controller.dart';
import '../../features/post_auth_setup/photo_and_bio/controller/photo_and_bio_controller.dart';
import '../../features/post_auth_setup/promo_code/controller/promo_code_controller.dart';
import '../../features/post_auth_setup/setup_profile/controller/setup_profile_controller.dart';
import '../../features/post_auth_setup/welcome_funding_mum/controller/welcome_funding_mum_controller.dart';
import '../../features/shared/bookmark/controller/bookmark_controller.dart';
import '../../features/shared/mood/mood_check_in/mood_check_in_controller.dart';
import '../../features/shared/mood/mood_insights/controller/mood_insights_controller.dart';
import '../../features/shared/mood/mood_library/controller/mood_library_controller.dart';
import '../../features/shared/subscription/subscription_choose_plan/controller/subscription_choose_plan_controller.dart';
import '../../features/shared/subscription/subscription_info/controller/subscription_info_controller.dart';
import '../../features/station_location/controller/station_location_controller.dart';
import '../../features/video_meeting/controller/arg_model/meeting_ctrl_ag_model.dart';
import '../../features/video_meeting/controller/meeting_comment_controller.dart';
import '../../features/video_meeting/controller/meeting_controller.dart';
import '../../routes/route_paths.dart';
import '../enums/app_enums.dart';
import '../enums/ui_enums.dart';
import '../network/helpers/location/location_manager_global/app_location_manager.dart';
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
    Get.lazyPut<SigninController>(() => SigninController(), fenix: true);
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
    Get.lazyPut<LifestyleAndInterestsController>(
      () => LifestyleAndInterestsController(),
    );
    Get.lazyPut<MumsStageController>(() => MumsStageController());
    Get.lazyPut<AddChildrenController>(() => AddChildrenController());
    Get.lazyPut<SubscriptionChoosePlanController>(
      () => SubscriptionChoosePlanController(),
      fenix: true,
    );
    Get.lazyPut<FinishSettingProfileController>(
      () => FinishSettingProfileController(),
    );
    Get.lazyPut<PromoCodeController>(() => PromoCodeController(), fenix: true);
    Get.lazyPut<WelcomeFundingMumController>(
      () => WelcomeFundingMumController(),
    );
  }
}

// ─────────────────────────────
// 🔹 Main Navigation / Home Flow
// ─────────────────────────────
/*
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
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
    Get.putPermanent(ChatController());
    Get.lazyPutFenix(() => MatchController());
    Get.lazyPutFenix(() => CommunityController());
    Get.lazyPutFenix(() => ExpertsController());

    //
    Get.lazyPutFenix(() => SessionController());
    Get.lazyPutFenix(() => SessionActionController());

    // Page controllers
    Get.lazyPutFenix(() => EditProfileController());
    Get.lazyPutFenix(() => SuccessController());
    Get.lazyPutFenix(() => PrivacyPolicyController());
    Get.lazyPutFenix(() => PaymentController());
  }
}
*/

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    // =======================
    // GLOBAL SINGLETONS
    // =======================
    Get.putPermanent(StationLocationController());
    Get.put(AppLocationManager(), permanent: true);
    Get.lazyPutFenix(() => ProfileController());

    Get.putPermanent(MainNavController());
    Get.putPermanent(BookmarkController());

    Get.put(CommunityActionController(), permanent: true);
    Get.put(CommunityController(), permanent: true);
    Get.put(CommunitySearchController(), permanent: true);

    // =======================
    // FEATURE SHARED CONTROLLERS
    // (used by Home + Experts + others)
    // =======================
    // MoodCheckInController MUST be registered before MoodLibraryController
    Get.putPermanent(MoodCheckInController());
    Get.putPermanent(MoodLibraryController());
    // Get.lazyPutFenix(() => MoodLibraryController());
    Get.lazyPutFenix(() => SessionController());
    Get.lazyPutFenix(() => SessionActionController());
    Get.lazyPutFenix(() => HomeController());
    Get.lazyPutFenix(() => ExpertsController());

    // =======================
    // PAGE CONTROLLERS
    // =======================
    Get.lazyPut(() => EditProfileController());
    Get.lazyPut(() => SuccessController());

    Get.lazyPut(() => PaymentController());

    Get.lazyPut(() => MatchController());

    // Chat (careful with lifecycle)
    Get.lazyPut(() => ChatController());
  }
}

// ─────────────────────────────
// 🔹 Main Tab's extended pages
// ─────────────────────────────
class ChatInboxBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;

    if (args == null || args is! ChatInboxArgPassModel) {
      throw Exception("ChatInboxController requires ChatInboxArgPassModel!");
    }

    if (Get.isRegistered<ChatInboxController>()) {
      Get.delete<ChatInboxController>();
    }
    Get.put(ChatInboxController(args));
  }
}

class CreateCommunityBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    final args = Get.arguments as CreateCommunityArgModel?;

    if (Get.isRegistered<CreateCommunityController>()) {
      Get.delete<CreateCommunityController>(force: true);
    }

    Get.put(CreateCommunityController());
  }
}

class ManageCommunityBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    final args = Get.arguments as CreateCommunityArgModel?;

    if (Get.isRegistered<ManageCommunityController>()) {
      Get.delete<ManageCommunityController>(force: true);
    }

    Get.put(ManageCommunityController());
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

// CommunityDetailBinding:
// class CommunityDetailBinding extends Bindings {
//   @override
//   void dependencies() {
//     final args = Get.arguments as Map<String, dynamic>?;

//     final btnState = args?['btnState'] as MyCommunityBtnState;
//     final communityItemId = args?['communityItemId'] as String;

//     if (Get.isRegistered<CommunityDetailController>()) {
//       Get.delete<CommunityDetailController>(force: true);
//     }

//     Get.put(CommunityDetailController(btnState, communityItemId));
//   }
// }

class CommunityDetailBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;

    final btnState =
        args?['btnState'] as MyCommunityBtnState? ??
        MyCommunityBtnState.join; // pick a sane fallback
    final communityItemId = args?['communityItemId'] as String?;

    if (communityItemId == null || communityItemId.isEmpty) {
      print("❌ [CommunityDetailBinding] Missing communityItemId — args: $args");
      // Either redirect to a fallback screen or show an error state
      Get.offAllNamed(RoutePaths.mainNav);
      return;
    }

    if (Get.isRegistered<CommunityDetailController>()) {
      Get.delete<CommunityDetailController>(force: true);
    }

    Get.put(CommunityDetailController(btnState, communityItemId));
    Get.put(PostActionController());
  }
}

class PostInCommunityBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context
    final args = Get.arguments as String;

    final communityItemId = args;

    if (Get.isRegistered<CreatePostController>()) {
      Get.delete<CreatePostController>(force: true);
    }

    Get.put(CreatePostController(communityItemId));
  }
}

class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;

    if (args is PostDetailArgModel) {
      final communityId = args.communityId;
      final postId = args.postId;

      print(
        '[PostDetailsBinding] communityId: $communityId, '
        'postId: $postId',
      );

      if (communityId.isNotEmpty) {
        if (!Get.isRegistered<CommunityDetailController>()) {
          print(
            '[PostDetailsBinding] Creating CommunityDetailController '
            'for $communityId',
          );

          Get.put(
            CommunityDetailController(MyCommunityBtnState.join, communityId),
          );
        } else {
          final existing = Get.find<CommunityDetailController>();

          if (existing.communityItemId != communityId) {
            print(
              '[PostDetailsBinding] Replacing stale CommunityDetailController '
              'for ${existing.communityItemId} with $communityId',
            );

            Get.delete<CommunityDetailController>(force: true);

            Get.put(
              CommunityDetailController(MyCommunityBtnState.join, communityId),
            );
          }
        }
      } else {
        print('⚠️ [PostDetailsBinding] Missing communityId');
      }

      if (postId.isEmpty) {
        print('⚠️ [PostDetailsBinding] Missing postId');
      }
    } else {
      print('⚠️ [PostDetailsBinding] Invalid or missing PostDetailArgModel');
    }

    if (!Get.isRegistered<PostActionController>()) {
      Get.put(PostActionController());
    }

    if (Get.isRegistered<PostDetailsController>()) {
      Get.delete<PostDetailsController>(force: true);
    }

    Get.put(PostDetailsController());
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
    Get.lazyPut<TermsAndConditionsController>(
      () => TermsAndConditionsController(),
    );
  }
}

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPolicyController());
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

// ─────────────────────────────
// 🔹 Individual but Shared
// ─────────────────────────────
// class MoodLibraryBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<MoodLibraryController>(
//       () => MoodLibraryController(),
//       fenix: true,
//     );
//   }
// }

class MoodInsightBinding extends Bindings {
  @override
  void dependencies() {
    // In your binding or wherever MoodInsightsController is created:
    final args = Get.arguments as MoodInsightArgs;

    Get.put(
      MoodInsightsController(
        args.moodType,
        args.itemId,
        fromHome: args.fromHome, // ✅
      ),
    );
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
    ///////////
    final args = Get.arguments;
    print("--> args: $args");

    if (args == null || args is! MeetingCtrlAgModel) {
      throw Exception(
        "MeetingController requires a MeetingCtrlAgModel argument!",
      );
    }

    // ✅ Get.put instead of Get.lazyPut — instantiates immediately
    // while arguments are still available in binding context

    // ✅ fenix:false ensures a fresh controller every time
    // ✅ 1. MeetingController FIRST — LiveChatController depends on it
    Get.put(
      MeetingController(Get.arguments as MeetingCtrlAgModel),
      permanent: false,
    );

    // ✅ 2. LiveChatController SECOND — so Get.find<MeetingController>() succeeds
    Get.put(LiveChatController(), permanent: false);

    Get.lazyPut<MeetingCommentController>(
      () => MeetingCommentController(),
      fenix: true,
    );
  }
}
