import '../../../../../../app/helper_widgets_export.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final Color? tileClr;
  final Color? iconColor;
  final double? iconH;

  const ProfileTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.tileClr,
    this.iconColor,
    this.iconH,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ContainerBordered(
        hp: 12,
        vp: 12, hasBrdr: true,
        brdrClr: c.secondary.withOpacity(0.3),

        boxShadow: boxShadowAllSides,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Container(
                    height: 30,
                    width: 30,
                 
                    color: tileClr ?? bgClr,
                    padding: const EdgeInsets.all(5),
                    child: SvgIconColored(
                      height: iconH ?? 20,
                      //  (iconPath.contains("notification") ? 20.0 : 16.0),
                      iconPath: iconPath,
                      iconColor: iconColor ?? c.primary,
                    ),
                  ),
                ),
                Gap(4),
                Text(title, style: TxtStyle.inter(fs: 11, w: 600)),
              ],
            ),
    
              SvgIconColored(
                iconColor: iconColor ?? c.primary,
                iconPath: IconsPath.arrowForwardSmall,
                height: 24,
              ),
          ],
        ),
      ),
    );
  }
}
