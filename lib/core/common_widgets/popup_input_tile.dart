import '../../app/helper_widgets_export.dart';

class PopupInputTile extends StatelessWidget {
  final String hintText;
  final String? value;
  final VoidCallback? onTap;
  final double? height;
  final double? brdrW;
  final Color? brdrClr;

  const PopupInputTile({
    super.key,
    required this.hintText,
    this.value,
    this.onTap,
    this.height,
    this.brdrW,
    this.brdrClr,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != null && value!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: 30.brdrRad,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        decoration: BoxDecoration(
          color: c.cardPrimary,
          borderRadius: 30.brdrRad,
          border: Border.all(color: brdrClr ?? c.inputBorder, width: brdrW ?? 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? value! : hintText,
                style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
              ),
            ),

            // 👇 Arrow suffix
            SvgIcon(iconPath: IconsPath.arrowForwardSmall, height: 20),
          ],
        ),
      ),
    );
  }
}
