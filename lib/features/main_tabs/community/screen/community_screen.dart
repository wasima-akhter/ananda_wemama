import '../../../../app/helper_widgets_export.dart';
import '../controller/community_controller.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<CommunityController>();
    final matchRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(child: Center(child: Text("CommunityScreen")));
  }
}
