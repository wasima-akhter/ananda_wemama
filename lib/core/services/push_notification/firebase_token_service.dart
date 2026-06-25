import 'package:mama_app/core/config/app_info.dart';

import '../../../app/service_export.dart';

class FirebaseTokenService extends GetxService {
  static FirebaseTokenService get to => Get.find();

  final RxBool isLoading = false.obs;
  final ApiServiceHelper _apiHelper = ApiServiceHelper();
  Future<bool?> updateToken({required String firebaseToken}) async {
    final response = await _apiHelper.request<bool?>(
      apiCall: () => ApiClient().post(
        '$baseUrl/api/mobile/firebase-token-update'
        '?firebase_token=$firebaseToken&device_id=&device_name=',
        reqName: 'firebase-token-update',
      ),
      parser: (data) => data['hash'] != null,
    );

    return response?.data;
  }
}
