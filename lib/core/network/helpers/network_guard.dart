import '../../utils/extension/context_extension.dart';
import '../network_manager.dart';

class NetworkGuard {
  static Future<bool> canProceed() async {
    final hasNet = await NetworkManager().checkConnection();

    if (!hasNet) {
      Snack.showError(
        title: "No Internet",
        "Please check your connection and try again.",
      );

      return false;
    }

    return true;
  }
}
