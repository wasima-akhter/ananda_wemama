import 'package:google_fonts/google_fonts.dart';
import 'package:we_mama/app/helper_widgets_export.dart';

enum IconPosition { left, right }

enum TextCaseType { normal, upper, lower, capitalize }

class CustomBtnWIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  final Color bgColor;

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
    required this.iconPath,
    this.iconPosition = IconPosition.right,
    this.style,
    this.padding,
    this.radius = 8,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final isTallDevice = ScreenSize.isTallHeight;

    TextStyle style_ = GoogleFonts.poppins(
      fontSize: ScreenSizeX.isTablet
          ? 13.sp
          : isTallDevice
          ? 17.sp
          : 15.sp,
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
              vertical: isTallDevice ? 12.h : 12.h,
            ),
        decoration: BoxDecoration(color: bgColor, borderRadius: radius.brdrRad),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconPosition == IconPosition.left)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIcon(
                          iconPath: iconPath,
                          width: iconSize,
                          height: iconSize,
                        ),
                        SizedBox(width: 12), // 👈 spacing between icon & text
                      ],
                    ),

                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: style ?? style_,
                  ),
                ],
              ),
              //  Stack(
              //   children: [
              //     Container(
              //       // width: double.infinity,
              //       padding: const EdgeInsets.symmetric(horizontal: 40.0),
              //       // color: Colors.amber,
              //       child: Text(
              //         text,
              //         textAlign: TextAlign.center,
              //         style: style ?? style_,
              //       ),
              //     ),

              //     if (iconPosition == IconPosition.left)
              //       Positioned(
              //         left: 0
              //             .w, // 👈 adjust this value to control how close it is
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             SvgIcon(
              //               iconPath: iconPath,
              //               width: iconSize,
              //               height: iconSize,
              //             ),
              //             SizedBox(width: 6), // 👈 spacing between icon & text
              //           ],
              //         ),
              //       ),
              //   ],
              // ),
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

            // if (iconPosition == IconPosition.left)
            //   Align(
            //     alignment: Alignment.centerLeft,
            //     child: SvgIcon(
            //       iconPath: iconPath,
            //       width: iconSize,
            //       height: iconSize,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
