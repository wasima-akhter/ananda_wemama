import '../../../app/helper_widgets_export.dart';

class AddPhotosCard extends StatelessWidget {
  final void Function()? onTap;
  const AddPhotosCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: onTap,
      child: ContainerBordered(
        hasBrdr: true,
        vp: 11,
        hp: 7,
        child: Column(
          children: [
            SvgIconColored(iconPath: IconsPath.addPlusCircle, height: 21),
            Gap(4),
            Text(Strings.addPhoto, style: TxtStyle.outfitxSmNor500),
          ],
        ),
      ),
    );
  }
}
