import '../../app/helper_widgets_export.dart';

class CustomToggleButton extends StatelessWidget {
  final bool value;
  final void Function(bool value) onChanged;
  final double? width;
  final double? height;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final Duration duration;
  final Widget? activeChild;
  final Widget? inactiveChild;
  final double borderRadius;

  const CustomToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.width,
    this.height,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.duration = const Duration(milliseconds: 250),
    this.activeChild,
    this.inactiveChild,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = grey200;
    final inactiveColor = grey200;
    final thumbColor = value ? greyLoc : c.textSecondary;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: duration,
        width: width ?? 60,
        height: height ?? 22,
        // padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          borderRadius: (borderRadius.brdrRad),
        ),
        child: Stack(
          children: [
            // Optional Labels inside the track
            if (activeChild != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: value ? activeChild : const SizedBox(),
                ),
              ),
            if (inactiveChild != null)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: !value ? inactiveChild : const SizedBox(),
                ),
              ),

            // Thumb
            AnimatedAlign(
              duration: duration,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: height ?? 22 + 8,
                height: height ?? 22 - 1,
                decoration: BoxDecoration(
                  color: thumbColor,
                  borderRadius: (borderRadius.brdrRad),
                  // shape: BoxShape.circle,
                  // boxShadow: const [
                  //   BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                  // ],
                ),
                child: Center(
                  child: Text(
                    value ? Strings.on : Strings.off,

                    style: TxtStyle.inter(w: 600, fs: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
