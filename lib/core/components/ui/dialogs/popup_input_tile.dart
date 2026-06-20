import '../../../../app/helper_widgets_export.dart';

class PopupInputTile extends StatelessWidget {
  final String hintText;
  final String? value;
  final VoidCallback? onTap;
  final double? height;
  final double? brdrW;
  final Color? brdrClr;
  final Color? bgClr;
  final double? rad;
  final EdgeInsetsGeometry? padding;

  const PopupInputTile({
    super.key,
    required this.hintText,
    this.value,
    this.onTap,
    this.height,
    this.brdrW,
    this.brdrClr,
    this.bgClr,
    this.rad,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != null && value!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: (rad ?? 30).brdrRad,
      child: Container(
        height: height,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: bgClr ?? c.cardPrimary,
          borderRadius: (rad ?? 30).brdrRad,
          border: Border.all(
            color: brdrClr ?? c.inputBorder,
            width: brdrW ?? 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? value! : hintText,
                style: TxtStyle.outfitSemiB(fs: 14, w: hasValue ? 400 : 500),
              ),
            ),

            // 👇 Arrow suffix
            SvgIcon(iconPath: IconsPath.arrowForwardSmall, height: 14),
          ],
        ),
      ),
    );
  }
}
