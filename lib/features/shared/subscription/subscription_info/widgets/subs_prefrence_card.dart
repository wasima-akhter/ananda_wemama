import '../../../../../app/helper_widgets_export.dart';

class PreferencesCard extends StatelessWidget {
  final List<Widget> children;

  const PreferencesCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.scaffoldBackground,
      brdrClr: c.inputBorder,
      hasBrdr: true,
      rad: 16,
      hp: 18,
      vp: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Preferences", style: TxtStyle.outfit(fs: 18, w: 600, color: c.primary)),

          Gap(16),

          ...children,
        ],
      ),
    );
  }
}
