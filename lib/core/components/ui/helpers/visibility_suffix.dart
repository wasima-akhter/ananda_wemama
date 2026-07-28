import 'package:we_mama/app/helper_widgets_export.dart';

class VisibilitySuffix extends StatelessWidget {
  final void Function()? onTap;
  final String icon;
  const VisibilitySuffix({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: onTap,
      child: SvgIconColored(
        iconPath: icon,
        iconColor: c.primary,
        height: 22,
      ).mOnly(left: 15, right: 15),
    );
  }
}
