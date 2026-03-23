import 'package:get/get.dart';
import 'package:mama_app/core/config/app_info.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../network/helpers/network_helpers.dart';

class SocketService extends GetxService {
  late IO.Socket socket;

  Future<SocketService> init() async {
    connectSocket();
    return this;
  }

  void connectSocket() {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().setExtraHeaders({
        "authorization": "$getToken",
      }).build(), // ✅ MUST ADD THIS
    );
    socket.connect();

    socket.onConnect((_) {
      print("✅ Socket Connected: ${socket.id}");
    });

    socket.onDisconnect((_) {
      print("❌ Socket Disconnected");
    });

    socket.onConnectError((err) {
      print("⚠️ Socket Error: $err");
    });

    socket.onReconnect((_) {
      print("🔄 Reconnected");
    });
  }

  /// Emit event
  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  /// Listen event
  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  /// Remove listener
  void off(String event) {
    socket.off(event);
  }
}
