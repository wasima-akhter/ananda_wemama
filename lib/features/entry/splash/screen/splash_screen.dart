import '../../../../app/helper_widgets_export.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sc = SplashController.to;

    // Run after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sc.splashScreenFunctions();
    });

    return SafeArea(
      top: false,
      bottom: false,

      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(bottom: S.viewPaddingBottom),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagesPath.splashImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Image.asset(ImagesPath.weMamaLogo, height: S.w * 0.5),
          ),
        ),
      ),
    );
  }
}
