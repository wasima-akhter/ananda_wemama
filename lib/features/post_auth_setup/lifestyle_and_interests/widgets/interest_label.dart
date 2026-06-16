import '../../../../app/helper_widgets_export.dart';

class InterestLabel extends StatelessWidget {
  final String label;

  const InterestLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TxtStyle.poppinsSemiB(fs: 11, w: 600, h: 1.4, ls: 0.05),
    );
  }
}
