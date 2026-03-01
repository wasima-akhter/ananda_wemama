import '../../app/helper_widgets_export.dart';

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
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: value ? Icon(Icons.check, size: size * 0.7, color: checkColor) : null,
      ),
    );
  }
}
