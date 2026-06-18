import '../../../../../app/helper_widgets_export.dart';

class Onboard4TopSection extends StatelessWidget {
  const Onboard4TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      spacing: ScreenSize.isSmallWidth ? 3.h : 6.h,
      children: [
        Text(
          "Expert Guidance",
          textAlign: TextAlign.center,
          style: TxtStyle.dmSerifDisplay26Regular(),
        ),

        Text(
          "Join live sessions with trusted experts.",
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center(),
        ),
      ],
    );
  }
}
