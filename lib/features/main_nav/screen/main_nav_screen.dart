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
      onPopInvokedWithResult: (didPop, result) =>
          didPop ? null : mnc.handleWillPop(),
      child: SafeArea(
        top: false,

        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: bgClr,
          body: Obx(() {
            final currentIndex = mnc.currentIndex.value;
            log("📄 Displaying page at index: $currentIndex");
            return mnc.pages[currentIndex];
          }),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: c.inputBackground,
                  boxShadow: boxShadowTopOnly,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(35.r),
                  //   topRight: Radius.circular(35.r),
                  // ),
                ),
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  top: 15.h,
                  bottom: S.bottomInset + 12.h,
                ),
                child: CustomBottomNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
