import 'package:we_mama/features/entry/onboard/controller/onboard_controller.dart';

import '../../../../../app/helper_widgets_export.dart';

class Onboard2BottomSection extends StatelessWidget {
  const Onboard2BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardController.to;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomBtnWTxtNew(
          btnTxt: 'Continue',

          btnColor: c.strokePrimary,
          txtClr: c.backgroundPrimary,
          isLoading: false,
          onTap: () {
            // Next page
            controller.nextPage();
          },
        ),
      ],
    );
  }
}
