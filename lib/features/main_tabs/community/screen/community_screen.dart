import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_search_bar.dart';
import '../controller/community_controller.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<CommunityController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async {
        print("communities refreshed");
      },
      appBar: CommonAppBarContent(
        title: Strings.community,
        hasBackNavArrow: false,

        suffix: CusGestureDetector(
          onTap: () {
            communityGuidlineDialog(
              isLoading: false,
              onTapAction: () async => Get.toNamed(RoutePaths.createCommunity),
            );
          },
          child: SvgIcon(iconPath: IconsPath.addPlus, height: 30),
        ),
      ),
      child: Column(children: [CusSearchBar(controller: mc.searchController)]).getcm,
    );
  }
}
