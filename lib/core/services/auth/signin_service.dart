import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../app/service_export.dart';
import '../../../features/auth/signin/model/signin_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../socket/socket_service.dart';
import 'handler/auth_response_handler.dart';
import 'session_manager/auth_session_manager.dart';

// ─────────────────────────────────────────────
// Result type
// ─────────────────────────────────────────────

enum SocialLoginApiResultType { success, profileIncomplete, failed, cancelled }

class SocialLoginResult {
  final SocialLoginApiResultType type;
  final String? message;
  const SocialLoginResult({required this.type, this.message});
}

// ─────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────

class SocialLoginService {
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
    required String provider,
  }) async {
    final result = await ApiExecutor().execute<SigninModelData>(
      apiCall: () => ApiClient().post(
        Endpoints.socialLogin.getUrl,
        data: {"provider": provider, "authToken": authToken},
      ),
      customHandler: (body) => AuthResponseHandler.parse(body),
    );

    switch (result.type) {
      case ApiResultType.profileIncomplete:
        storage.setToken(result.data?.accessToken ?? "");

        return SocialLoginResult(
          type: SocialLoginApiResultType.profileIncomplete,
          message: result.message,
        );

      case ApiResultType.success:
        await AuthSessionService().initialize(result.data!);

        return const SocialLoginResult(type: SocialLoginApiResultType.success);

      default:
        return SocialLoginResult(
          type: SocialLoginApiResultType.failed,
          message: result.message,
        );
    }
  }

  void _saveUserData(SigninModelData model) {
    final user = model.user;

    storage.setUserInfo(email: user?.email ?? '');

    storage.setToken(model.accessToken ?? '');

    log("Logged in as: ${user?.email}");
  }
}

class SigninService {
  Future<LoginResult> signIn({
    required String email,
    required String password,
  }) async {
    final result = await ApiExecutor().execute<SigninModelData>(
      apiCall: () => ApiClient().post(
        Endpoints.login.getUrl,
        data: {"email": email, "password": password},
      ),
      customHandler: (body) => AuthResponseHandler.parse(body),
      showErrorMessage: true,
      showSuccessMessage: true,
    );

    switch (result.type) {
      case ApiResultType.emailNotVerified:
        return LoginResult(
          type: LoginApiResultType.emailNotVerified,
          message: result.message,
        );

      case ApiResultType.profileIncomplete:
        storage.setToken(result.data?.accessToken ?? "");

        return LoginResult(
          type: LoginApiResultType.profileIncomplete,
          message: result.message,
        );

      case ApiResultType.success:
        await AuthSessionService().initialize(result.data!);

        return LoginResult(type: LoginApiResultType.success);

      case ApiResultType.failed:
        return LoginResult(
          type: LoginApiResultType.failed,
          message: result.message,
        );
    }
  }

  Future<void> _completeLoginSession() async {
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
  }

  void _saveUserDataAfterLogin({required SigninModelData model}) {
    final user = model.user;
    storage.setUserInfo(email: user?.email ?? '');
    storage.setToken(model.accessToken ?? '');

    log("access token when setup: ${model.accessToken}");

    log("Logged in as: ${user?.email}");
    log("Access token: ${model.accessToken}");
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
