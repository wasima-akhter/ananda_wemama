import '../../../../app/helper_widgets_export.dart';

class LifestyleTag extends StatelessWidget {
  final String item;
  final void Function()? onTap;
  final bool isSelected;
  const LifestyleTag({super.key, required this.item, this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerBordered(
            hp: 10,
            vp: 6,
            rad: 30,
            contClr: isSelected ? c.primary : c.cardPrimary,
            child: Text(
              item.capEachWord(),
              style: TxtStyle.outfit(
                fs: 12,
                w: isSelected ? 600 : 500,
                color: isSelected ? white : c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
