import '../../../../../app/helper_widgets_export.dart';

class Onboard2BottomSection extends StatelessWidget {
  const Onboard2BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomBtnWTxtNew(
          btnTxt: 'Continue',
          btnColor: c.strokePrimary,
          txtClr: c.backgroundPrimary,
          isLoading: false,
          onTap: () {},
        ),
      ],
    );
  }
}
