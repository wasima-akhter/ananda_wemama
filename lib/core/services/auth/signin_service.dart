import 'package:flutter/material.dart';

import '../../../../app/service_export.dart';
import '../../../features/auth/signin/model/signin_model.dart';
import '../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../socket/socket_service.dart';

class SigninService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<bool> signIn({required String email, required String password}) async {
    log("Login started..");

    final response = await _apiHelper.request<SigninModelData>(
      apiCall: () => ApiClient().post(
        Endpoints.login.getUrl,
        data: {"email": email, "password": password},
      ),
      parser: (data) => SigninModelData.fromJson(data),
    );

    log("RESPONSE sign in: $response");
    if (response == null) return false;

    if (response.success) {
      _saveUserDataAfterLogin(response: response);

      try {
        final socket = Get.find<SocketService>();
        // ✅ CRITICAL: Always disconnect old socket before reconnecting with new user's token
        // This ensures the old user's authenticated connection is cleared
        socket.disconnectSocket();
        log("🔴 Old socket disconnected before new login");

        // Now connect with the NEW token (saved in _saveUserDataAfterLogin)
        await socket.connectSocket();
        log("✅ New socket connected with new user's token");
      } catch (e) {
        log("Socket connect failed: $e");
      }

      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchMyProfile();
      }
    }

    return response.success;
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
    storage.setUserInfo(email: user.email);
    storage.setToken(response.data!.accessToken);

    log("Logged in as: ${user.email}");
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
