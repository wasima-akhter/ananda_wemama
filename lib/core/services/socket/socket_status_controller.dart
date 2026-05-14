// lib/core/services/socket/socket_status_controller.dart

import 'package:get/get.dart';

enum SocketStatus { connected, reconnecting, failed }

class SocketStatusController extends GetxController {
  static SocketStatusController get to => Get.find();

  final status = SocketStatus.connected.obs;
  final retryCount = 0.obs;

  bool get isConnected => status.value == SocketStatus.connected;
  bool get isReconnecting => status.value == SocketStatus.reconnecting;
  bool get isFailed => status.value == SocketStatus.failed;

  void setConnected() {
    retryCount.value = 0;
    status.value = SocketStatus.connected;
  }

  void setReconnecting(int attempt) {
    retryCount.value = attempt;
    status.value = SocketStatus.reconnecting;
  }

  void setFailed() {
    status.value = SocketStatus.failed;
  }
}
