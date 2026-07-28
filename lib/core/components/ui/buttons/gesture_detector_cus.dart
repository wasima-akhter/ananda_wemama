import 'package:we_mama/app/helper_widgets_export.dart';

class CusGestureDetector extends StatelessWidget {
  final void Function()? onTap;
  final HitTestBehavior? behavior;
  final Widget child;

  const CusGestureDetector({super.key, this.onTap, this.behavior, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: child);
  }
}

class CusCircleIconButton extends StatelessWidget {
  final void Function()? onTap;
  final HitTestBehavior? behavior;
  final Widget child;
  final double? radius;
  final Color? backgroundColor;

  const CusCircleIconButton({
    super.key,
    this.onTap,
    this.behavior,
    required this.child,
    this.radius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CircleAvatar(
        radius: (radius ?? 25).r,
        backgroundColor: backgroundColor ?? ctransp,
        child: child,
      ),
    );
  }
}
