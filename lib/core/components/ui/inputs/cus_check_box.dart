import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final Color borderColor;
  final Color checkColor;
  final Color activeColor;
  final double size;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.borderColor,
    required this.checkColor,
    required this.activeColor,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: value ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: value
            ? Icon(Icons.check, size: size * 0.7, color: checkColor)
            : null,
      ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final Color? activeColor;
  final Color? borderColor;
  final Color? checkColor;
  final Color? labelColor;
  final double? size;
  final double borderRadius;
  final double borderWidth;
  final TextStyle? labelStyle;
  final double gap;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.borderColor,
    this.checkColor,
    this.labelColor,
    this.size,
    this.borderRadius = 4,
    this.borderWidth = 2,
    this.labelStyle,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final resolvedActiveColor = activeColor ?? c.secondary;
    final resolvedBorderColor =
        borderColor ?? (value ? resolvedActiveColor : c.secondary);
    final resolvedCheckColor = checkColor ?? c.secondary;

    double size_ = size ?? (ScreenSize.isSmallWidth ? 15 : 18);

    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            width: size_,
            height: size_,
            padding: EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: ctransp,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: resolvedBorderColor,
                width: borderWidth,
              ),
            ),
            child: value
                ? SvgIconColored(
                    iconPath: Assets.icons.checkboxTick,
                    // height: size_ * 0.8,
                    iconColor: resolvedCheckColor,
                  )
                : null,
          ),
          if (label != null) ...[
            SizedBox(width: gap),
            Text(
              label!,
              style:
                  labelStyle ??
                  TxtStyle.outfitSemiB(
                    fs: 11,
                    color: labelColor ?? c.secondary,
                  ),

              //                   font-family: Outfit;
              // font-weight: 500;
              // font-style: Medium;
              // font-size: 14px;
              // leading-trim: NONE;
              // line-height: 100%;
              // letter-spacing: 0%;
              // text-transform: capitalize;
            ),
          ],
        ],
      ),
    );
  }
}
