import 'dart:developer';

import 'package:get/get.dart';

import '../../../../features/auth/signin/model/signin_model.dart';
import '../../../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../network/helpers/network_helpers.dart';
import '../../socket/socket_service.dart';

class AuthSessionManager {
  static Future<void> startSession() async {
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
}

class AuthSessionService {
  Future<void> initialize(SigninModelData model) async {
    storage.setToken(model.accessToken ?? "");

    storage.setUserInfo(email: model.user?.email ?? "");

    try {
      final socket = Get.find<SocketService>();

      socket.disconnectSocket();

      await socket.connectSocket();
    } catch (e) {
      log("Socket: $e");
    }

    if (Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().fetchMyProfile();
    }
  }
}
