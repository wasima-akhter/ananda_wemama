import '../../app/helper_widgets_export.dart';

class CustomRadio extends StatelessWidget {
  final bool isSelected;

  const CustomRadio({super.key, required this.isSelected});

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
            width: 7.w,
            height: 7.w,
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
