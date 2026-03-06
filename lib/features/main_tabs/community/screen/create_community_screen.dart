import '../../../../app/helper_widgets_export.dart';
import '../controller/create_community_controller.dart';

class CreateCommunityScreen extends StatelessWidget {
  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<CreateCommunityController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async {
        print("communities refreshed");
      },
      appBar: CommonAppBarContent(title: Strings.createCommunity),
      child: Column(children: []).getcm,
    );
  }
}
