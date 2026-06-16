import '../../../../app/helper_widgets_export.dart';

class CustomRadio extends StatelessWidget {
  final bool isSelected;
  final double? size;

  const CustomRadio({super.key, required this.isSelected, this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
        ),
        child: Center(
          child: Container(
            width: (size ?? 7).w,
            height: (size ?? 7).w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? c.primary : ctransp, // 🔥 your active color
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRadioWithLabel extends StatelessWidget {
  const CustomRadioWithLabel({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.size,
    this.activeColor,
    this.inactiveColor,
    this.gap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double? size;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final selectedColor = activeColor ?? c.strokePrimary;
    final unselectedColor = inactiveColor ?? c.foregroundPrimary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: selectedColor, width: 1.5),
            ),
            child: selected
                ? CustomRadio(isSelected: true, size: size ?? 10)
                : SizedBox(
                    width: (size ?? 10).w + 2,
                    height: (size ?? 10).w + 2,
                  ),
          ),
          Gap(gap ?? 6.w),
          Text(
            label,
            style: TxtStyle.poppinsSemiB(
              fs: 12,
              w: 600,
              h: 1.4,
              ls: -0.1,
              color: selected ? selectedColor : unselectedColor,
            ),
          ),
        ],
      ),
    );
  }
}
