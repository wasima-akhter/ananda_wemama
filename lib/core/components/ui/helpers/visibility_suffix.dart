import 'package:mama_app/app/helper_widgets_export.dart';

class VisibilitySuffix extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  const VisibilitySuffix({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: onTap,
      child: Icon(icon, color: c.primary, size: 22.w),
    );
  }
}
