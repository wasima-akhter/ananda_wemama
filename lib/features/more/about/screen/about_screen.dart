import 'package:we_mama/features/more/about/controller/about_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../main_tabs/home/modules/profile_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final epc = Get.find<AboutController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.about.cap),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileTile(
            title: Strings.contactSupport,
            tileClr: c.inputBackground,
            iconPath: IconsPath.quesContact,
            onTap: () => Get.toNamed(RoutePaths.contactSupport),
          ),
          Gap(itemGap),
          ProfileTile(
            title: Strings.termsAndConditions,
            tileClr: c.inputBackground,
            iconPath: IconsPath.termsConditions,
            onTap: () => Get.toNamed(RoutePaths.termsAndConditions),
          ),
        ],
      ).getcm,
    );
  }
}
