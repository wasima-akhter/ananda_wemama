import '../../../../app/helper_widgets_export.dart';
import '../controller/match_controller.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MatchController>();
    final matchRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(child: Center(child: Text("chat")));
  }
}
