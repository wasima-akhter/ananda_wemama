import '../../../app/service_export.dart';

class FirebaseTokenService extends GetxService {
  static FirebaseTokenService get to => Get.find();

  final RxBool isLoading = false.obs;

  Future<bool> updateToken({required String firebaseToken}) async {
    print('🔧 [FirebaseTokenService] uploading token: $firebaseToken');

    isLoading.value = true;

    try {
      final response = await ApiExecutor().execute(
        apiCall: () => ApiClient().post(
          Endpoints.uploadFcmToken.getUrl,
          headers: HeaderHelpers.getAuthHeader(),
          data: {"fcmToken": firebaseToken},
        ),
        parser: (data) => data,
      );

      final success = response.isSuccess ?? false;

      print(
        success
            ? '✅ [FirebaseTokenService] token uploaded successfully'
            : '⚠️ [FirebaseTokenService] token upload failed',
      );

      return success;
    } catch (e, st) {
      print('❌ [FirebaseTokenService] token upload FAILED: $e');
      print('$st');

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

/*
Cold start
  └─ PushNotificationService.init()          ← phase 1, no auth
       ├─ local plugin ✅
       ├─ Android channel ✅
       ├─ FCM listeners ✅
       ├─ topic subscription ✅
       └─ terminated launch check ✅

User logs in
  └─ _onLoginSuccess()
       └─ uploadTokenAfterLogin()             ← phase 2, Bearer token ready
            ├─ getToken() from FCM
            ├─ POST /fcmToken with Bearer ✅
            └─ onTokenRefresh listener started

App resumes (already logged in)
  └─ AppLifecycleListener.onResume
       └─ retryFailedSteps()                 ← no-op if already uploaded

Network restored
  └─ NetworkManager stream
       └─ retryFailedSteps()                 ← retries if previous upload failed

FCM rotates token
  └─ onTokenRefresh
       └─ _tokenUploaded = false → re-upload ✅

*/
