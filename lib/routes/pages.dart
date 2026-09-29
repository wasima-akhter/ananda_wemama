import 'package:get/get.dart';
import 'package:we_mama/features/main_tabs/experts/screen/ongoing/ongoing_sessions_screen.dart';
import 'package:we_mama/features/main_tabs/experts/screen/past_sessions_screen%20.dart';
import 'package:we_mama/features/main_tabs/experts/screen/upcoming/upcoming_sessions_screen.dart';
import 'package:we_mama/features/more/about/screen/about_screen.dart';
import 'package:we_mama/features/more/blocked_user/screen/blocked_user_screen.dart';
import 'package:we_mama/features/more/legal/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:we_mama/features/more/legal/terms_and_conditions/screen/terms_and_conditions_screen.dart';
import 'package:we_mama/features/more/support/contact_support/screen/contact_support_screen.dart';
import 'package:we_mama/features/post_auth_setup/finish_setting_profile/screen/finish_setting_profile_screen.dart';
import 'package:we_mama/features/post_auth_setup/promo_code/screen/promo_code_screen.dart';
import 'package:we_mama/features/shared/subscription/subscription_info/screen/billing_history_screen.dart';
import 'package:we_mama/features/shared/subscription/subscription_upgrade/screen/subscription_pending.dart';
import 'package:we_mama/features/shared/subscription/subscription_upgrade/screen/subscription_upgrade_screen.dart';

import '../core/bind/all_bindings.dart';
import '../core/state_screens/not_found/not_found_page.dart';
import '../core/state_screens/offline/offline_screen.dart';
import '../features/account_overview/change_password/screen/change_password_screen.dart';
import '../features/auth/forgot_password/screen/forgot_password_screen.dart';
import '../features/auth/otp/screen/verify_otp_screen.dart';
import '../features/auth/signin/screen/signin_screen.dart';
import '../features/auth/signup/screen/signup_screen.dart';
import '../features/entry/onboard/screens/onboard_screen.dart';
import '../features/entry/onboard/screens/onboard_screen2.dart';
import '../features/entry/onboard/screens/onboard_screen3.dart';
import '../features/entry/splash/screen/splash_screen.dart';
import '../features/main_nav/screen/main_nav_screen.dart';
import '../features/main_tabs/chat/screen/chat_inbox_screen.dart';
import '../features/main_tabs/chat/screen/chat_screen.dart';
import '../features/main_tabs/community/create/screen/create_community_screen.dart';
import '../features/main_tabs/community/detail/screen/community_details_screen.dart';
import '../features/main_tabs/community/feed/screens/community_screen.dart';
import '../features/main_tabs/community/manage/screen/manage_community_screen.dart';
import '../features/main_tabs/community/members/screen/member_management_screen.dart';
import '../features/main_tabs/community/post/screen/post_details_screen.dart';
import '../features/main_tabs/community/post/screen/post_in_community_screen.dart';
import '../features/main_tabs/community/search/screen/community_search_screen.dart';
import '../features/main_tabs/experts/screen/experts_screen.dart';
import '../features/main_tabs/home/screen/home_screen.dart';
import '../features/main_tabs/home/sub_feature/edit_profile/screen/edit_profile_screen.dart';
import '../features/main_tabs/home/sub_feature/profile/screen/profile_screen.dart';
import '../features/main_tabs/match/screen/match_screen.dart';
import '../features/more/notification/screen/notification_screen.dart';
import '../features/post_auth_setup/add_children/screen/add_children_screen.dart';
import '../features/post_auth_setup/lifestyle_and_interests/screen/lifestyle_and_interests_screen.dart';
import '../features/post_auth_setup/mums_stage/screen/mums_stage_screen.dart';
import '../features/post_auth_setup/photo_and_bio/screen/add_bio_screen.dart';
import '../features/post_auth_setup/photo_and_bio/screen/add_photo_screen.dart';
import '../features/post_auth_setup/promo_code/screen/founding_mum_code_screen.dart';
import '../features/post_auth_setup/setup_profile/screen/setup_profile_screen.dart';
import '../features/post_auth_setup/welcome_funding_mum/screen/welcome_funding_mum_screen.dart';
import '../features/shared/bookmark/screen/bookmark_screen.dart';
import '../features/shared/mood/mood_insights/screen/mood_insights_screen.dart';
import '../features/shared/mood/mood_library/screen/mood_library_screen.dart';
import '../features/shared/subscription/subscription_choose_plan/screen/subscription_choose_plan_screen.dart';
import '../features/shared/subscription/subscription_info/screen/subscription_info_screen.dart';
import '../features/shared/subscription/subscription_upgrade/controller/subscription_confirm_controller.dart';
import '../features/shared/subscription/subscription_upgrade/model/subscription_price_model.dart';
import '../features/shared/subscription/subscription_upgrade/screen/subscription_confirm_screen.dart';
import '../features/shared/subscription/subscription_upgrade/screen/subscription_success.dart';
import '../features/shared/wave_request/screen/wave_request_screen.dart';
import '../features/verification/controller/verification_controller.dart';
import '../features/verification/view/verification_screen.dart';
import '../features/video_meeting/screen/meeting_screen.dart';
import 'route_paths.dart';

class RoutePageList {
  static final List<GetPage> appPages = [
    // ─────────────────────────────
    // 🔹 Splash & Onboarding
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashScreenBinding(),
      // transition RouteTransitions.byName(RoutePaths.splashScreen),
    ),
    GetPage(
      name: RoutePaths.offlineScreen,
      page: () => const OfflineScreen(),
      // transition RouteTransitions.byName(RoutePaths.offlineScreen),
    ),
    GetPage(
      name: RoutePaths.notFound,
      page: () => const RouteNotFoundPage(),
      // transition RouteTransitions.byName(RoutePaths.notFound),
    ),
    GetPage(
      name: RoutePaths.onboardScreen,
      page: () => const OnboardScreen(),
      binding: SplashScreenBinding(),
      // transition RouteTransitions.byName(RoutePaths.onboardScreen),
    ),
    GetPage(
      name: RoutePaths.onboardScreen2,
      page: () => const OnboardScreen2(),
      binding: SplashScreenBinding(),
      // transition RouteTransitions.byName(RoutePaths.onboardScreen2),
    ),
    GetPage(
      name: RoutePaths.onboardScreen3,
      page: () => const OnboardScreen3(),
      binding: SplashScreenBinding(),
      // transition RouteTransitions.byName(RoutePaths.onboardScreen3),
    ),

    // ─────────────────────────────
    // 🔹 Meeting
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.meetingScreen,
      page: () => const MeetingScreen(),
      binding: MeetingBinding(),
      // transition RouteTransitions.byName(RoutePaths.meetingScreen),
    ),

    // ─────────────────────────────
    // 🔹 Main Navigation / Tabs Flow
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.mainNav,
      page: () => const MainNavScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.mainNav),
    ),
    GetPage(
      name: RoutePaths.home,
      page: () => const HomeScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.home),
    ),
    GetPage(
      name: RoutePaths.chat,
      page: () => const ChatScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.chat),
    ),

    GetPage(
      name: RoutePaths.match,
      page: () => const MatchScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.match),
    ),
    GetPage(
      name: RoutePaths.communities,
      page: () => const CommunityScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.communities),
    ),
    GetPage(
      name: RoutePaths.experts,
      page: () => const ExpertsScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.experts),
    ),

    // ─────────────────────────────
    // 🔹 Main Tab's extended Pages
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.chatInbox,
      page: () => const ChatInboxScreen(),
      binding: ChatInboxBinding(),
      // transition RouteTransitions.byName(RoutePaths.chatInbox),
    ),

    GetPage(
      name: RoutePaths.communityDetail,
      page: () => const CommunityDetailsScreen(),
      binding: CommunityDetailBinding(),
      // transition RouteTransitions.byName(RoutePaths.communityDetail),
    ),
    GetPage(
      name: RoutePaths.communitySearch,
      page: () => const CommunitySearchScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.communityDetail),
    ),

    GetPage(
      name: RoutePaths.ongoingSessions,
      page: () => const OngoingSessionsScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.experts),
    ),
    GetPage(
      name: RoutePaths.upcomingSessions,
      page: () => const UpcomingSessionsScreen(),
      binding: MainNavBinding(),
      // transition RouteTransitions.byName(RoutePaths.experts),
    ),

    // ─────────────────────────────
    // 🔹 Auth Flow
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.signin,
      page: () => const SigninScreen(),
      binding: SigninScreenBinding(),
    ),
    GetPage(
      name: RoutePaths.signup,
      page: () => const SignupScreen(),
      binding: SignupScreenBinding(),
    ),
    GetPage(
      name: RoutePaths.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordScreenBinding(),
    ),
    GetPage(
      name: RoutePaths.verifyOtp,
      page: () => const VerifyOtpScreen(),
      binding: OtpScreenBinding(),
    ),

    // ─────────────────────────────
    // 🔹 Post-Signup / Profile Setup Flow
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.setupProfile,
      page: () => const SetupProfileScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.addPhoto,
      page: () => const AddPhotoScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.addBio,
      page: () => const AddBioScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.lifeStyleAndInterests,
      page: () => const LifestyleAndInterestsScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.mumsStage,
      page: () => const MumsStageScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.addChildren,
      page: () => const AddChildrenScreen(),
      binding: PostSignupScreensBinding(),
    ),

    GetPage(
      name: RoutePaths.finishSettingProfile,
      page: () => const FinishSettingProfileScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.promoCodeScreen,
      page: () => const PromoCodeScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.foundingMumCodeScreen,
      page: () => const FoundingMumCodeScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.subChoosePlan,
      page: () => const SubscriptionChoosePlanScreen(),
      binding: PostSignupScreensBinding(),
    ),
    GetPage(
      name: RoutePaths.welcomeFundingMum,
      page: () => const WelcomeFundingMumScreen(),
      binding: PostSignupScreensBinding(),
    ),

    // ─────────────────────────────
    // 🔹 More
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.notification,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: RoutePaths.profile,
      page: () => const ProfileScreen(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: RoutePaths.editProfile,
      page: () => const EditProfileScreen(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: RoutePaths.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: RoutePaths.blockedUser,
      page: () => const BlockedUserScreen(),
      binding: BlockedUserBinding(),
    ),
    GetPage(
      name: RoutePaths.about,
      page: () => const AboutScreen(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: RoutePaths.contactSupport,
      page: () => const ContactSupportScreen(),
      binding: ContactSupportBinding(),
    ),
    GetPage(
      name: RoutePaths.termsAndConditions,
      page: () => const TermsAndConditionsScreen(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: RoutePaths.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
    ),

    // ─────────────────────────────
    // 🔹 Individual but Shared
    // ─────────────────────────────
    GetPage(
      name: RoutePaths.moodLibrary,
      page: () => const MoodLibraryScreen(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: RoutePaths.bookmark,
      page: () => const BookmarkScreen(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: RoutePaths.moodInsight,
      page: () => const MoodInsightsScreen(),
      binding: MoodInsightBinding(),
    ),
    GetPage(
      name: RoutePaths.waveRequest,
      page: () => const WaveRequestScreen(),
      binding: WaveRequestBinding(),
    ),

    GetPage(
      name: RoutePaths.createCommunity,
      page: () => const CreateCommunityScreen(),
      binding: CreateCommunityBinding(),
    ),

    GetPage(
      name: RoutePaths.postInCommunity,
      page: () => const PostInCommunityScreen(),
      binding: PostInCommunityBinding(),
    ),
    GetPage(
      name: RoutePaths.postDetails,
      page: () => const PostDetailsScreen(),
      binding: PostDetailsBinding(),
    ),
    GetPage(
      name: RoutePaths.pastSessions,
      page: () => const PastSessionsScreen(),
      binding: PastSessionsBinding(),
    ),
    GetPage(
      name: RoutePaths.manageCommunity,
      page: () => const ManageCommunityScreen(),
      binding: ManageCommunityBinding(),
    ),
    GetPage(
      name: RoutePaths.memberManagement,
      page: () => const MemberManagementScreen(),
      binding: MemberManagementBinding(),
    ),
    GetPage(
      name: RoutePaths.subscriptionUpgrade,
      page: () => const SubscriptionUpgradeScreen(),
      binding: SubscriptionUpgradeBinding(),
    ),
    GetPage(
      name: RoutePaths.subscriptionInfo,
      page: () => const SubscriptionInfoScreen(),
      binding: SubscriptionInfoBinding(),
    ),
    GetPage(
      name: RoutePaths.subscriptionSuccess,
      page: () => const SubscriptionSuccess(),
      // binding: SubscriptionInfoBinding(),
    ),
    GetPage(
      name: RoutePaths.subscriptionPending,
      page: () => const SubscriptionPending(),
      // binding: SubscriptionInfoBinding(),
    ),
    GetPage(
      name: RoutePaths.subscriptionConfirmScreen,
      page: () => const SubscriptionConfirmScreen(),
      // binding: SubscriptionInfoBinding(),
      binding: BindingsBuilder(() {
        final priceModel = Get.arguments as SubscriptionPriceModel;
        Get.lazyPut(
          () => SubscriptionConfirmController(priceModel),
          fenix: true,
        );
      }),
    ),
    GetPage(
      name: RoutePaths.billingHistory,
      page: () => const BillingHistory(),
      // binding: SubscriptionInfoBinding(),
    ),

    // Verifications
    // app_pages.dart (or wherever your GetPages live)
    GetPage(
      name: RoutePaths.verification,
      page: () => const VerificationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VerificationController>(() => VerificationController());
      }),
    ),
  ];
}
