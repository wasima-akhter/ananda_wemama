import '../../../../app/helper_widgets_export.dart';

class SetupSelectField extends StatelessWidget {
  const SetupSelectField({
    super.key,
    required this.title,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.showArrow = true,
  });

  final String title;
  final String value;
  final String placeholder;
  final VoidCallback onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TxtStyle.poppinsSemiB(w: 600, ls: 0.64, fs: 14)),

        Gap(10.h),

        CusGestureDetector(
          onTap: onTap,
          child: ContainerBordered(
            vp: ScreenSize.isSmallWidth ? 8 : 10,
            hp: 14,
            alignment: Alignment.centerLeft,
            hasBrdr: true,
            contClr: inputBgClr,
            brdrClr: newBorderClr,
            brdrW: 1,
            rad: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value.isNotEmpty ? value : placeholder,
                    style: TxtStyle.poppinsSemiBold12Center(
                      color: c.foregroundSecondary.withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (showArrow)
                  SvgIcon(iconPath: IconsPath.arrowForwardSmall, height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
