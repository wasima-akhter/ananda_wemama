import '../../../../../app/helper_widgets_export.dart';

class SubscriptionFeatureRow extends StatelessWidget {
  final String title;
  final bool isIncluded;
  final bool? isCloseWhite;
  final Color? textColor;

  const SubscriptionFeatureRow({
    super.key,
    required this.title,
    required this.isIncluded,
    this.textColor,
    this.isCloseWhite,
  });

  @override
  Widget build(BuildContext context) {
    final clr = textColor ?? c.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isIncluded
            ? SvgIcon(height: 24, iconPath: IconsPath.smallTickBold)
            : SvgIconColored(
                height: 18,
                iconColor: isCloseWhite == true ? white : null,
                iconPath: IconsPath.closeCircle,
              ),
        Gap(itemGap),
        Expanded(
          child: Text(title.capEachWord(), style: TxtStyle.outfit(fs: 13, w: 500, color: clr)),
        ),
      ],
    ).mB(5);
  }
}

class SubscriptionSectionTitle extends StatelessWidget {
  final String title;
  final Color? textColor;

  const SubscriptionSectionTitle({super.key, required this.title, this.textColor});

  @override
  Widget build(BuildContext context) {
    final clr = textColor ?? c.primary;
    return ContainerBordered(
      contClr: white,
      rad: 4,
      vp: 8,
      hp: 12,
      brdrClr: c.inputBorder,
      child: Text(title.toUpperCase(), style: TxtStyle.outfit(fs: 13, w: 600, color: clr)),
    ).mB(12);
  }
}
