import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';

class ChildSummaryTile extends StatelessWidget {
  const ChildSummaryTile({
    super.key,
    required this.dob,
    required this.gender,
    this.onEdit,
    this.onDelete,
  });

  final String dob;
  final String gender;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final textStyle = TxtStyle.poppinsSemiB(
      fs: 11,
      w: 600,
      h: 1.4,
      ls: -0.1,
      color: c.foregroundPrimary.withValues(alpha: .7),
    );

    return ContainerBordered(
      vp: 8,
      hp: 8,
      contClr: inputBgClr,
      child: Row(
        children: [
          ContainerBordered(
            rad: 4,
            vp: 4,
            hp: 3,
            contClr: c.backgroundSecondary,
            child: SvgIcon(iconPath: Assets.icons.child, height: 20),
          ),

          Gap(10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(dob, style: textStyle),
                Text(gender, style: textStyle),
              ],
            ),
          ),
          CusGestureDetector(
            onTap: onDelete,
            child: ContainerBordered(
              rad: 4,
              vp: 4,
              hp: 4,
              contClr: c.strokePrimary.withValues(alpha: .2),
              child: SvgIcon(iconPath: Assets.icons.deleteNew, height: 20),
            ),
          ),
          Gap(8.w),

          CusGestureDetector(
            onTap: onEdit,
            child: ContainerBordered(
              rad: 4,
              vp: 5,
              hp: 5,
              contClr: c.strokePrimary.withValues(alpha: .2),
              child: SvgIcon(iconPath: Assets.icons.edit, height: 16),
            ),
          ),
        ],
      ),
    );
  }
}
