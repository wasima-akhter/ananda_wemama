import 'package:get/get.dart';

import '../../local/app_storage.dart';
import '../socket/socket_service.dart';

class SignoutService extends GetxService {
  void signOut() {
    // ── 1. Clear local storage ──
    AppStorage.to.logout();

    // ── 2. Disconnect socket cleanly ──
    if (Get.isRegistered<SocketService>()) {
      final socket = Get.find<SocketService>();
      socket.disconnectSocket(); // ← clean public method
      Get.delete<SocketService>(
        force: true,
      ); // ← destroys instance, triggers onClose()
    }

    // ── 3. Navigate to login ──
    // Get.offAllNamed(RoutePaths.login);
  }
}
