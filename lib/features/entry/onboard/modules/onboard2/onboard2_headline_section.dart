import '../../../../../app/helper_widgets_export.dart';

class Onboard2HeadlineSection extends StatelessWidget {
  const Onboard2HeadlineSection({super.key});

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
            Strings.builtForWomen,
            textAlign: TextAlign.center,
            style: TxtStyle.dmSerifDisplayRegular(),
          ),
        ),
      ],
    );
  }
}
