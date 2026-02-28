import 'package:get/get.dart';

import '../../local/app_storage.dart';

class SignoutService extends GetxService {
  void signOut() {
    // 🔥 Clear all locally saved user data
    AppStorage.to.logout();

    // (Optional) Navigate to login screen
    // GNav.pushNamedAndRemoveUntil(RoutePaths.login);
  }
}
