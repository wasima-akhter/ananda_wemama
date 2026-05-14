import '../../../../app/helper_widgets_export.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sc = SplashController.to;

    // Run after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sc.splashScreenFunctions(context);
    });

    return SafeArea(
      top: false,

      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(ImagesPath.splashImage), fit: BoxFit.cover),
          ),
          child: Center(child: Image.asset(ImagesPath.weMamaLogoPng, height: S.w * 0.5)),
        ),
      ),
    );
  }
}
