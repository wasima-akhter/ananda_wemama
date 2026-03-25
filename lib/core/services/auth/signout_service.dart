import 'package:get/get.dart';

import '../../local/app_storage.dart';
import '../socket/socket_service.dart';

class SignoutService extends GetxService {
  void signOut() {
    // 🔥 Clear all locally saved user data
    AppStorage.to.logout();

    Get.find<SocketService>().onClose();

    // (Optional) Navigate to login screen
    // GNav.pushNamedAndRemoveUntil(RoutePaths.login);
  }
}
