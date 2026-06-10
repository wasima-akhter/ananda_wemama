import 'package:google_fonts/google_fonts.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

enum IconPosition { left, right }

enum TextCaseType { normal, upper, lower, capitalize }

class CustomBtnWIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  final Color bgColor;
  final Color textColor;

  final TextStyle? style;

  final EdgeInsetsGeometry? padding;
  final double radius;

  final String iconPath;
  final IconPosition iconPosition;

  final double iconSize;

  const CustomBtnWIcon({
    super.key,
    required this.onTap,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.iconPath,
    this.iconPosition = IconPosition.right,
    this.style,
    this.padding,
    this.radius = 8,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final isTallDevice = S.h > 700;

    TextStyle style_ = GoogleFonts.poppins(
      fontSize: isTallDevice ? 17.sp : 15.sp,
      fontWeight: FontWeight.w600,
      height: 1.0,
      letterSpacing: 0,
      color: c.backgroundSecondary,
    );
    return CusGestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: isTallDevice ? 12.w : 12.w,
            ),
        decoration: BoxDecoration(color: bgColor, borderRadius: radius.brdrRad),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: style ?? style_,
              ),
            ),

            if (iconPosition == IconPosition.right)
              Align(
                alignment: Alignment.centerRight,
                child: SvgIcon(
                  iconPath: iconPath,
                  width: isTallDevice ? iconSize + 4 : iconSize - 2,
                  height: isTallDevice ? iconSize + 4 : iconSize - 2,
                ),
              ),

            if (iconPosition == IconPosition.left)
              Align(
                alignment: Alignment.centerLeft,
                child: SvgIcon(
                  iconPath: iconPath,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
