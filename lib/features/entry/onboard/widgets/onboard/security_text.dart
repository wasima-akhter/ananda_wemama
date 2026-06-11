import '../../../../../app/helper_widgets_export.dart';

class SecurityText extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color? bgClr;
  final Color? txtClr;
  final double? rad;
  final double? fs;
  final double? iconH;

  const SecurityText({
    super.key,
    required this.iconPath,
    required this.text,
    this.bgClr,
    this.rad,
    this.fs,
    this.iconH,
    this.txtClr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: (rad ?? 30).brdrRad,
        color: bgClr ?? c.primary.withOpacity(0.05),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          SvgIcon(iconPath: iconPath, height: iconH ?? 25),

          Text(
            text,
            style: TxtStyle.inter(fs: fs ?? 11, color: txtClr ?? c.secondary),
          ),
        ],
      ),
    );
  }
}
