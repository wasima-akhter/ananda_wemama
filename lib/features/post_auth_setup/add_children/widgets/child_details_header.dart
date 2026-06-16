import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';

class ChildDetailsHeader extends StatelessWidget {
  const ChildDetailsHeader({
    super.key,
    this.onDelete,

    // NEW FLEXIBLE ACTION
    this.trailingIcon,
    this.trailingText,
    this.onTrailingTap,
  });

  final VoidCallback? onDelete;

  final Widget? trailingIcon;
  final String? trailingText;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    final hasTrailing =
        trailingIcon != null || trailingText != null || onDelete != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// LEFT SIDE
        Row(
          children: [
            ContainerBordered(
              rad: 4,
              vp: 4,
              hp: 3,
              contClr: c.backgroundSecondary,
              child: SvgIcon(iconPath: Assets.icons.child, height: 20),
            ),
            Gap(8.w),
            Text("Child Details", style: TxtStyle.poppinsSemiB(w: 600)),
          ],
        ),

        /// RIGHT SIDE (OPTIONAL)
        if (hasTrailing)
          GestureDetector(
            onTap: onTrailingTap ?? onDelete,
            child: _buildTrailing(),
          ),
      ],
    );
  }

  Widget _buildTrailing() {
    if (trailingIcon != null) {
      return ContainerBordered(contClr: ctransp, child: trailingIcon!);
    }

    if (trailingText != null) {
      return Text(
        trailingText!,
        style: TxtStyle.poppinsSemiB(fs: 12, w: 600, color: c.strokePrimary),
      );
    }

    // fallback (delete icon)
    return ContainerBordered(
      rad: 4,
      vp: 5,
      hp: 5,
      contClr: c.strokePrimary.withValues(alpha: .2),
      child: SvgIcon(iconPath: Assets.icons.deleteNew, height: 20),
    );
  }
}
