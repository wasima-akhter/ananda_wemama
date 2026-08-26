import '../../../app/helper_widgets_export.dart';

class BottomAction extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color? color;
  final double? size;
  final Color? backgroundColor;
  final double opacity; // ← NEW: Add opacity parameter

  const BottomAction({
    super.key,
    required this.iconPath,
    required this.text,
    this.color,
    this.backgroundColor,
    this.size,
    this.opacity = 1.0, // ← NEW: Default to fully opaque
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // ← NEW: Wrap entire widget with Opacity
      opacity: opacity,
      child: Column(
        children: [
          Container(
            decoration: 0.circleBrdr(brdrClr: c.secondary),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: (backgroundColor ?? c.scaffoldBackground),
              child: SvgIconColored(
                iconPath: iconPath,
                height: size ?? 22,
                iconColor: color ?? c.primary,
              ),
            ),
          ),
          Gap(6),
          FittedBox(child: Text(text, style: TxtStyle.inter(fs: 11))),
        ],
      ),
    );
  }
}
