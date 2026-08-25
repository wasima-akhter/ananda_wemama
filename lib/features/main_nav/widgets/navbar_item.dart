import '../../../app/helper_widgets_export.dart';

class NavbarItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final double width;
  final double height;
  final int currenIndex;

  const NavbarItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.width,
    required this.height,
    required this.currenIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Selected item with icon + label
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgIconColored(
          iconPath: iconPath,
          iconColor: isSelected ? c.navItemSelected : c.navItemUnselected,
          height: height,
          width: width,
        ),
        Text(
          label,
          style: TxtStyle.inter(
            fs: 11,
            w: 500,
            color: isSelected ? c.navItemSelected : c.navItemUnselected,
          ),
        ),
      ],
    );
  }
}
