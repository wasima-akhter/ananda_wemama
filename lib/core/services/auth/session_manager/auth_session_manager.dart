import 'package:get/get.dart';

import '../../../../features/auth/signin/model/signin_model.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../../features/shared/subscription/subscription_upgrade/service/purchase_service.dart';
import '../../../network/helpers/network_helpers.dart';
import '../../socket/socket_service.dart';

class AuthSessionManager {
  static Future<void> startSession() async {
    try {
      final socket = Get.find<SocketService>();

      socket.disconnectSocket();
      await socket.connectSocket();
    } catch (e) {
      print("Socket error: $e");
    }

    if (Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().fetchMyProfile();
    }
  }
}

class AuthSessionService {
  Future<void> initialize(SigninModelData model) async {
    storage.setToken(model.accessToken ?? "");

    storage.setUserInfo(email: model.user?.email ?? "");

    storage.setUserId(model.user?.profileId ?? ''); // NEW
    print("Logged in as: ${model.user?.email}, id: ${model.user?.profileId}");

    final profileId = model.user?.profileId ?? '';

    // Revenue cat
    // ADD HERE:
    if (profileId.isNotEmpty) {
      await PurchaseService.to.loginRevenueCatUser(profileId);
    } else {
      print("⚠️ No profileId — skipping RevenueCat login");
    }

    try {
      final socket = Get.find<SocketService>();

      socket.disconnectSocket();

      await socket.connectSocket();
    } catch (e) {
      print("Socket: $e");
    }

    if (Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().fetchMyProfile();
    }
  }
}
