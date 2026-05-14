import '../../../../app/helper_widgets_export.dart';

class ActiveTag extends StatelessWidget {
  final bool isActive;
  const ActiveTag({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      rad: 30,
      contClr: isActive ? c.secondary : Colors.grey.shade300,
      vp: 2.5,
      hp: 9,
      child: Text(
        isActive ? Strings.active : Strings.inactive,
        style: TxtStyle.outfitSemiB(fs: 13, w: 400, color: isActive ? c.scaffoldBackground : white),
      ),
    );
  }
}

class ActiveInfo extends StatelessWidget {
  final bool isActive;
  const ActiveInfo({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isActive ? c.secondary.withOpacity(0.3) : Colors.grey.shade300,
      radius: 9,
      child: SvgIconColored(
        iconPath: IconsPath.curvedInfo,

        iconColor: isActive ? null : white,
        height: 11,
      ),
    );
  }
}
