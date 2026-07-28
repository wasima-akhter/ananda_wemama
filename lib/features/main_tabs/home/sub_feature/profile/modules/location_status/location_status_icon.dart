import 'package:we_mama/app/helper_widgets_export.dart';

class LocationStatusIcon extends StatelessWidget {
  final bool isActive;

  const LocationStatusIcon({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 9,

      backgroundColor: isActive
          ? c.primary.withOpacity(0.12)
          : c.bottomSheetBackground.withOpacity(0.5),

      child: SvgIconColored(
        iconPath: IconsPath.curvedInfo,

        height: 11,

        iconColor: isActive ? c.primary : c.primary.withOpacity(0.5),
      ),
    );
  }
}
