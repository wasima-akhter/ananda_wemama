import '../../../../app/helper_widgets_export.dart';

class InterestIcon extends StatelessWidget {
  final String iconPath;

  const InterestIcon({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return SvgIcon(iconPath: iconPath, height: 30, width: 30);
  }
}
