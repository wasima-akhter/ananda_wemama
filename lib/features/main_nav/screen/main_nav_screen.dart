import '../../../app/helper_widgets_export.dart';
import '../controller/main_nav_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainNavController mnc = Get.find<MainNavController>();

    log("🏗️ MainNavigationPage build called");
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => didPop ? null : mnc.handleWillPop(),
      child: SafeArea(
        top: false,

        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: bgClr,
          body: Obx(() {
            final currentIndex = mnc.currentIndex.value;
            log("📄 Displaying page at index: ${currentIndex}");
            return mnc.pages[currentIndex];
          }),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(boxShadow: boxShadowTopOnly, color: c.inputBackground),
            height: 60.h,

            // ((S.h * 0.06) + S.bottomInset).h,
            padding: EdgeInsets.only(
              left: 15.w,
              right: 15.w,
              //  bottom:  S.bottomInset> 25 ? S.bottomInset : 10
            ),

            child: CustomBottomNavBar(length: mnc.pages.length, roleId: roleId, mnc: mnc),
          ),
        ),
      ),
    );
  }
}
