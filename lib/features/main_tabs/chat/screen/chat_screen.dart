import '../../../../app/helper_widgets_export.dart';
import '../controller/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(child: Center(child: Text("chat")));
  }
}
