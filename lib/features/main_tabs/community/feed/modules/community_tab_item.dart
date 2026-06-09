import '../../../../../app/helper_widgets_export.dart';

class CommunityTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const CommunityTabItem({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selClr = c.primary;
    final unselClr = c.inputBackground;
    final selTxtClr = white;
    final unselTxtClr = c.primary;

    return CusGestureDetector(
      onTap: onTap,
      child: ContainerBordered(
        rad: 8,
        hp: 12,
        vp: 6,
        hasBrdr: isSelected ? null : true,
        contClr: isSelected ? selClr : unselClr,
        child: TextFit(
          title,
          style: TxtStyle.outfitSemiB(
            fs: 14,
            w: 500,
            color: isSelected ? selTxtClr : unselTxtClr,
          ),
        ),
      ),
    );
  }
}
