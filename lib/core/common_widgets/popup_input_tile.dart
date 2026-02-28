import '../../app/helper_widgets_export.dart';

class PopupInputTile extends StatelessWidget {
  final String hintText;
  final String? value;
  final VoidCallback? onTap;
  final double? height;

  const PopupInputTile({super.key, required this.hintText, this.value, this.onTap, this.height});

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
          color: c.inputBackground,
          borderRadius: 30.brdrRad,
          border: Border.all(color: c.inputBorder, width: 1.5),
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
