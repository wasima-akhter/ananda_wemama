import '../../../../app/helper_widgets_export.dart';

class ChildDetailsCard extends StatelessWidget {
  const ChildDetailsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(vp: 8, hp: 8, contClr: inputBgClr, child: child);
  }
}
