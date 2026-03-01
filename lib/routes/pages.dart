import 'package:get/get.dart';
import 'package:mama_app/views/auth/forgot_password/screen/forgot_password_screen.dart';
import 'package:mama_app/views/auth/otp/screen/verify_otp_screen.dart';
import 'package:mama_app/views/auth/signin/screen/signin_screen.dart';
import 'package:mama_app/views/auth/signup/screen/signup_screen.dart';
import 'package:mama_app/views/onboard/screens/onboard_screen2.dart';
import 'package:mama_app/views/post_auth_setup/lifestyle_and_interests/screen/lifestyle_and_interests_screen.dart';
import 'package:mama_app/views/post_auth_setup/mums_stage/screen/mums_stage_screen.dart';
import 'package:mama_app/views/post_auth_setup/subscription_choose_plan/screen/subscription_choose_plan_screen.dart';
import 'package:mama_app/views/post_auth_setup/welcome_funding_mum/screen/welcome_funding_mum_screen.dart';
import 'package:mama_app/views/video_meeting/screen/home_screen.dart';
import 'package:mama_app/views/video_meeting/screen/meeting_screen.dart';

import '../core/bind/all_bindings.dart';
import '../core/state_screens/not_found/not_found_page.dart';
import '../core/state_screens/offline/offline_screen.dart';
import '../views/onboard/screens/onboard_screen.dart';
import '../views/post_auth_setup/mums_stage/screen/mums_stage_finish_screen.dart';
import '../views/post_auth_setup/photo_and_bio/screen/photo_and_bio_screen.dart';
import '../views/post_auth_setup/setup_profile/screen/setup_profile_screen.dart';
import '../views/splash/screen/splash_screen.dart';
import 'route_paths.dart';
import 'route_transition.dart';

class RoutePageList {
  static final List<GetPage> appPages = [
    GetPage(
      name: RoutePaths.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashScreenBinding(),
      transition: RouteTransitions.byName(RoutePaths.splashScreen),
    ),
    GetPage(
      name: RoutePaths.offlineScreen,
      page: () => const OfflineScreen(),
      transition: RouteTransitions.byName(RoutePaths.offlineScreen),
    ),
    GetPage(
      name: RoutePaths.notfound,
      page: () => const RouteNotFoundPage(),
      transition: RouteTransitions.byName(RoutePaths.notfound),
    ),
    GetPage(
      name: RoutePaths.onboardScreen,
      page: () => const OnboardScreen(),
      binding: SplashScreenBinding(),
      transition: RouteTransitions.byName(RoutePaths.onboardScreen),
    ),
    GetPage(
      name: RoutePaths.onboardScreen2,
      page: () => const OnboardScreen2(),
      binding: SplashScreenBinding(),
      transition: RouteTransitions.byName(RoutePaths.onboardScreen2),
    ),
    GetPage(
      name: RoutePaths.meetingScreen,
      page: () => const MeetingScreen(),
      binding: MeetingBinding(),
      transition: RouteTransitions.byName(RoutePaths.meetingScreen),
    ),
    GetPage(
      name: RoutePaths.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: RouteTransitions.byName(RoutePaths.home),
    ),

    GetPage(
      name: RoutePaths.offlineScreen,
      page: () => const OfflineScreen(),
      transition: RouteTransitions.byName(RoutePaths.offlineScreen),
    ),
    GetPage(
      name: RoutePaths.notfound,
      page: () => const RouteNotFoundPage(),
      transition: RouteTransitions.byName(RoutePaths.notfound),
    ),
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
    GetPage(
      name: RoutePaths.setupProfile,
      page: () => const SetupProfileScreen(),
      binding: PostSigupScreensAllBinding(),
    ),
    GetPage(
      name: RoutePaths.photoAndBio,
      page: () => const PhotoAndBioScreen(),
      binding: PostSigupScreensAllBinding(),
    ),
    GetPage(
      name: RoutePaths.lifeStyleAndInterests,
      page: () => const LifestyleAndInterestsScreen(),
      binding: PostSigupScreensAllBinding(),
    ),
    GetPage(
      name: RoutePaths.mumsStage,
      page: () => const MumsStageScreen(),
      binding: PostSigupScreensAllBinding(),
    ),
    GetPage(name: RoutePaths.mumsStageFinish, page: () => const MumsStageFinishScreen()),
    GetPage(
      name: RoutePaths.subChoosePlan,
      page: () => const SubscriptionChoosePlanScreen(),
      binding: PostSigupScreensAllBinding(),
    ),
    GetPage(
      name: RoutePaths.welcomeFundingMum,
      page: () => const WelcomeFundingMumScreen(),
      binding: PostSigupScreensAllBinding(),
    ),
  ];
}
