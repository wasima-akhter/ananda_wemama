import '../../../../app/helper_widgets_export.dart';

class SmallNavBtn extends StatelessWidget {
  final String text;
  final String? goToPath;
  final VoidCallback? onTap;
  const SmallNavBtn({super.key, required this.text, this.goToPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: onTap ?? () => Get.toNamed(goToPath ?? ''),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerBordered(
            contClr: c.buttonPrimary,
            rad: 30,
            hp: 8,
            vp: 8,
            child: Text(
              text,
              style: TxtStyle.inter(fs: 12, w: 600, color: c.textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
