import '../../../../../../../app/helper_widgets_export.dart';

class TitleTile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final Color? tileClr;
  final Widget? child;
  final double? hp;

  const TitleTile({super.key, this.title, this.onTap, this.tileClr, this.child, this.hp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ContainerBordered(
        hp: hp ?? 12,
        vp: child != null ? 8 : 22,

        boxShadow: boxShadowAllSides,
        child:
            child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(title ?? '', style: TxtStyle.inter(fs: 11, w: 600))],
                ),
              ],
            ),
      ),
    );
  }
}
