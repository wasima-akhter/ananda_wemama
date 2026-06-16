import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';

class ChildDobField extends StatelessWidget {
  const ChildDobField({super.key, required this.date, this.onTap});

  final String date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date of birth",
          style: TxtStyle.poppinsSemiB(fs: 12, w: 600, h: 1.4, ls: -0.1),
        ),
        Gap(6.h),
        GestureDetector(
          onTap: onTap,
          child: ContainerBordered(
            hp: 10,
            vp: 6,
            hasBrdr: true,
            contClr: ctransp,
            brdrClr: newBorderClr,
            brdrW: 1,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TxtStyle.poppinsSemiB(
                    fs: 11,
                    w: 600,
                    h: 1.4,
                    ls: -0.1,
                    color: c.foregroundPrimary.withValues(alpha: 0.6),
                  ),
                ),
                SvgIconColored(
                  iconPath: Assets.icons.calenderNew,
                  iconColor: c.strokePrimary,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
