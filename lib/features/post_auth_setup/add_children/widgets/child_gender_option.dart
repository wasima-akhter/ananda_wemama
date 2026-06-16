import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/inputs/custom_radio.dart';

class ChildGenderOption extends StatelessWidget {
  const ChildGenderOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: ContainerBordered(
          alignment: Alignment.centerLeft,
          hp: 10,
          vp: 8,
          hasBrdr: true,
          contClr: ctransp,
          brdrClr: newBorderClr,
          brdrW: 1,
          child: CustomRadioWithLabel(
            label: label,
            selected: selected,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
