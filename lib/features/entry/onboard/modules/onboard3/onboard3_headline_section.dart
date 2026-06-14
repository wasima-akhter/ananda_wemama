import '../../../../../app/helper_widgets_export.dart';

class Onboard3HeadlineSection extends StatelessWidget {
  const Onboard3HeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 2.h,
      children: [
        Container(
          // color: Colors.grey,
          child: Text(
            Strings.findMumsNearYou,
            textAlign: TextAlign.center,
            style: TxtStyle.dmSerifDisplayRegular(),
          ),
        ),
      ],
    );
  }
}
