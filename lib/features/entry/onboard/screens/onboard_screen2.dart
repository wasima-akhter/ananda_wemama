import 'package:we_mama/features/entry/onboard/sections/pageview_contents/pageview2.dart';
import 'package:we_mama/features/entry/onboard/sections/pageview_contents/pageview3.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../controller/onboard_controller.dart';
import '../modules/core/onboard_logo_header_row.dart';
import '../sections/onboard2/onboard2_bottom_section.dart';
import '../sections/pageview_contents/pageview1.dart';

class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardController.to;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClrNew,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: true,
        appBar: getOnboardAppBar(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: S.bottomInset + 20),
              child: Onboard2BottomSection().getcm,
            ),
          ],
        ),
        body: Column(
          children: [
            LogoPartHeader(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  // Page 1
                  Pageview1(),

                  // Page 2
                  Pageview2(),

                  // Page 3
                  Pageview3(),
                ],
              ),
            ),
          ],
        ).getcm,
      ),
    );
  }
}
