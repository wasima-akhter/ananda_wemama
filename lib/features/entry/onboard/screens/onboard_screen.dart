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
                  OnboardTopSection(cfg: cfg),

                  Expanded(child: OnboardImageSection()),

                  OnboardBottomSection(cfg: cfg),
                  Gap(S.viewPaddingBottom),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
