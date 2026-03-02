import '../../../../app/helper_widgets_export.dart';
import '../controller/experts_controller.dart';

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<ExpertsController>();
    final matchRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(child: Center(child: Text("chat")));
  }
}
