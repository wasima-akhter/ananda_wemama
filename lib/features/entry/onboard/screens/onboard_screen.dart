import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/layout/bg_image_container.dart';
import '../controller/onboard_controller.dart';
import '../sections/onboard/onboard_bottom_section.dart';
import '../sections/onboard/onboard_image_section.dart';
import '../sections/onboard/onboard_top_section.dart';
import '../widgets/onboard/onboard_layout_config.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    findCont<OnboardController>();

    int getImageFlex() {
      if (ScreenSize.isTallHeight) {
        if (ScreenSize.isSmallWidth) return 12;
        if (ScreenSize.isMediumWidth || ScreenSize.isLargeWidth) return 9;
      }
      return 13;
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: c.scaffoldBackground,
        extendBodyBehindAppBar: true,
        body: BgImageContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cfg = OnboardLayoutConfig(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              );

              return Column(
                children: [
                  Expanded(
                    flex: ScreenSize.isTallHeight ? 15 : 16,
                    child: OnboardTopSection(cfg: cfg),
                  ),

                  Expanded(
                    flex: getImageFlex(),
                    child: Container(
                      // color: Colors.amber,
                      child: OnboardImageSection(),
                    ),
                  ),

                  Expanded(
                    flex: 6,
                    child: Container(
                      // color: Colors.green,
                      child: OnboardBottomSection(cfg: cfg),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
