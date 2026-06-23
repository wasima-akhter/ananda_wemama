import 'package:google_sign_in/google_sign_in.dart';
import 'package:mama_app/app/controller_export.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../app/service_export.dart';
import '../../../features/auth/signin/model/signin_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../deep_link/app_link_service.dart';
import '../socket/socket_service.dart';

// ─────────────────────────────────────────────
// Result type
// ─────────────────────────────────────────────

enum SocialLoginResultType { success, profileIncomplete, failed, cancelled }

class SocialLoginResult {
  final SocialLoginResultType type;
  final String? message;
  const SocialLoginResult({required this.type, this.message});
}

// ─────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────

class SocialLoginService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // ── Google ──────────────────────────────────

  /// Returns the Google ID token, or null if the user cancelled / error.
  Future<String?> getGoogleIdToken() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      // Force account picker every time so users can switch accounts.
      await googleSignIn.signOut();

      final account = await googleSignIn.signIn();
      if (account == null) return null; // user cancelled

      final auth = await account.authentication;
      return auth.idToken;
    } catch (e) {
      log('Google Sign-In error: $e');
      return null;
    }
  }

  // ── Apple ───────────────────────────────────

  /// Returns the Apple identity token, or null if the user cancelled / error.
  Future<String?> getAppleIdToken() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      return credential.identityToken;
    } catch (e) {
      log('Apple Sign-In error: $e');
      return null;
    }
  }

  // ── Backend call ─────────────────────────────

  Future<SocialLoginResult> socialLogin({
    required String authToken,
    required String provider, // 'google' | 'apple'
  }) async {
    log('Social login → provider: $provider');

    final response = await _apiHelper.request<SigninModelData>(
      apiCall: () => ApiClient().post(
        Endpoints.socialLogin.getUrl,
        data: {"provider": provider, "authToken": authToken},
        isLogin_: true,
        reqName: 'social login'.capEachWord(),
      ),
      reqName: 'social login'.capEachWord(),
      parser: (data) => SigninModelData.fromJson(data),
    );

    if (response == null) {
      return const SocialLoginResult(type: SocialLoginResultType.failed);
    }

    final data = response.data;
    if (data == null) {
      return const SocialLoginResult(type: SocialLoginResultType.failed);
    }

    final statusCode = data.statusCode;

    // 302 → profile not yet completed
    if (statusCode == 302) {
      "Please complete your profile to continue.".showToast();
      storage.setToken(data.accessToken ?? '');
      return SocialLoginResult(
        type: SocialLoginResultType.profileIncomplete,
        message: data.msg,
      );
    }

    final accessToken = data.accessToken ?? '';
    if (accessToken.isEmpty) {
      return const SocialLoginResult(type: SocialLoginResultType.failed);
    }

    // ✅ Success — persist user data
    _saveUserData(response: response);

    // Reconnect socket with fresh credentials
    try {
      final socket = Get.find<SocketService>();
      socket.disconnectSocket();
      await socket.connectSocket();
    } catch (e) {
      log('Socket error after social login: $e');
    }

    if (Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().fetchMyProfile();
    }

    _handleDeepLink();
    return const SocialLoginResult(type: SocialLoginResultType.success);
  }

  void _saveUserData({required BaseResponse<SigninModelData> response}) {
    if (response.data == null) return;
    final user = response.data!.user;
    storage.setUserInfo(email: user?.email ?? '');
    storage.setToken(response.data?.accessToken ?? '');
    log('Social login — saved token for: ${user?.email}');
  }

  void _handleDeepLink() {
    final deepLinkService = Get.find<DeepLinkService>();

    // final pendingLiveId = deepLinkService.consumePendingLive();

    // if (pendingLiveId != null) {
    //   Get.offAllNamed(RoutePaths.mainNav);
    //   return;
    // }
  }
}

class SigninService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<LoginResult> signIn({
    required String email,
    required String password,
  }) async {
    log("Login started..");

    final response = await _apiHelper.request<SigninModelData>(
      apiCall: () => ApiClient().post(
        Endpoints.login.getUrl,
        data: {"email": email, "password": password},
        isLogin_: true,
        reqName: "login",
      ),
      reqName: "login",
      parser: (data) {
        log("before parse data : $data");
        log("after parse data : ${SigninModelData.fromJson(data)}");
        return SigninModelData.fromJson(data);
      },
    );

    log("RESPONSE sign in: $response");

    if (response == null) {
      return LoginResult(type: LoginResultType.failed);
    }

    final data = response.data;

    if (data == null) {
      return LoginResult(type: LoginResultType.failed);
    }

    // 🔥 IMPORTANT: backend sends status inside data
    final isEmailVerified = data.isEmailVerified;
    final isProfileCompleted = data.isProfileCompleted;
    final accessToken = data.accessToken ?? '';
    final statusCode = data.statusCode;
    log(
      "--> isEmailVerified: $isEmailVerified, isProfileCompleted: $isProfileCompleted, ",
    );

    // // Check profileIncomplete first — backend sends ONLY the relevant flag
    // if (data.isProfileCompleted == false) {
    //   return LoginResult(
    //     type: LoginResultType.profileIncomplete,
    //     message: data.msg,
    //   );
    // }

    // if (data.isEmailVerified == false) {
    //   return LoginResult(
    //     type: LoginResultType.emailNotVerified,
    //     message: data.msg,
    //   );
    // }

    // 403 → email not verified
    if (statusCode == 403) {
      "Your email is not verified yet. Please verify your email.".showToast();
      return LoginResult(
        type: LoginResultType.emailNotVerified,
        message: data.msg,
      );
    }

    // 302 → profile incomplete
    if (statusCode == 302) {
      "Your profile is not completed yet. Please complete your profile."
          .showToast();

      // ✅ Save token so profile completion screen can make authenticated requests
      storage.setToken(response.data?.accessToken ?? '');
      return LoginResult(
        type: LoginResultType.profileIncomplete,
        message: data.msg,
      );
    }

    log("access token when setup-->: ${response.data!.accessToken}");
    if (accessToken.isEmpty) {
      return LoginResult(type: LoginResultType.failed);
    }

    // ✅ SUCCESS FLOW
    _saveUserDataAfterLogin(response: response);

    try {
      final socket = Get.find<SocketService>();
      socket.disconnectSocket();
      await socket.connectSocket();
    } catch (e) {
      log("Socket error: $e");
    }

    if (Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().fetchMyProfile();
    }

    return LoginResult(type: LoginResultType.success);
  }

  /// Connects the socket using the token that was just saved by
  /// _saveUserDataAfterLogin. Called only on successful login.
  void _connectSocketAfterLogin() {
    // SocketService is registered as permanent in InitialBinding —
    // Get.find() is always safe here.
    try {
      Get.find<SocketService>().connectSocket();
    } catch (e) {
      // SocketService not registered yet — should not happen if InitialBinding
      // is set up correctly, but log it rather than crashing.
      log("⚠️ SocketService not found during login: $e");
    }
  }

  void _saveUserDataAfterLogin({
    required BaseResponse<SigninModelData> response,
  }) {
    if (response.data == null) return;

    final user = response.data!.user;
    storage.setUserInfo(email: user?.email ?? '');
    storage.setToken(response.data?.accessToken ?? '');

    log("access token when setup: ${response.data!.accessToken}");

    log("Logged in as: ${user?.email}");
    log("Access token: ${response.data!.accessToken}");
  }
}

// 1. Login API ✅
// 2. Save token ✅
// 3. connectSocket() ❗ (async, not awaited)
// 4. fetchProfile() (heavy API call)
// 5. UI navigation happens

// 1. Login ✅
// 2. Save token ✅
// 3. CONNECT SOCKET ⏳ (WAIT)
// 4. Socket connected ✅ (joined room)
// 5. THEN fetchProfile()
// 6. THEN UI continues
