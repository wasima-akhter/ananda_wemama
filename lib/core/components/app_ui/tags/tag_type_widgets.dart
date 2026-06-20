import '../../../../app/helper_widgets_export.dart';

class ActiveTag extends StatelessWidget {
  final bool isActive;
  const ActiveTag({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      rad: 40,
      contClr: isActive ? c.secondary : ctransp,
      hasBrdr: true,
      brdrClr: Colors.grey.shade400,
      vp: 1,
      hp: 10,
      child: Text(
        isActive ? Strings.active : Strings.inactive,
        style: TxtStyle.outfitSemiB(
          fs: 13,
          w: 400,
          color: isActive ? c.scaffoldBackground : Colors.grey.shade500,
        ),
      ).mB(1),
    );
  }
}

class ActiveInfo extends StatelessWidget {
  final bool isActive;
  const ActiveInfo({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isActive
          ? c.secondary.withOpacity(0.3)
          : Colors.grey.shade300,
      radius: 9,
      child: SvgIconColored(
        iconPath: IconsPath.curvedInfo,

        iconColor: isActive ? c.secondary : greyLoc,
        height: 11,
      ),
    );
  }
}
