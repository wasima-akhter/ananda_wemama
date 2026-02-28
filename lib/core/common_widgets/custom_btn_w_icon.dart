import 'package:mama_app/app/helper_widgets_export.dart';

import 'svg_icon_w_new_stroke.dart';

class CustomBtnWIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final String btnTxt;
  final Color? btnTxtClr;
  final Color? borderClr;
  final Color? btnColor;
  final double? w;
  final double? h;
  final double? rad;
  final double? brdrW;
  final bool isLoading;
  final bool? isSmall;
  final bool? outlined;
  final String iconPath;
  final double? iconw;
  final double? iconh;
  final double? iconStroke;
  final bool? noIconClr;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? txtLeftP;
  final bool? wantUnfocus;

  const CustomBtnWIcon({
    super.key,
    this.onTap,
    required this.btnTxt,
    this.borderClr,
    this.btnColor,
    this.w,
    this.h,
    this.rad,
    this.brdrW,
    required this.isLoading,
    this.isSmall,
    this.outlined,
    required this.iconPath,
    this.iconw,
    this.iconh,
    this.iconStroke,
    this.noIconClr,
    this.style,
    this.padding,
    this.txtLeftP,
    this.wantUnfocus,
    this.btnTxtClr,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (wantUnfocus != false) FocusManager.instance.primaryFocus?.unfocus();
        if (!isLoading) onTap?.call();
      },
      child: _buildContainer(context, isLoading),
    );
  }

  Widget _buildContainer(BuildContext context, bool loading) {
    final EdgeInsetsGeometry btnPadding = isSmall == true
        ? const EdgeInsets.symmetric(horizontal: 9, vertical: 9)
        : padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 16);

    final bool isOutlined = outlined == true;

    final BoxDecoration btnDecoration = BoxDecoration(
      color: isOutlined ? bgClr : btnColor ?? greyLoc,
      border: Border.all(
        color: isOutlined ? borderClr ?? c.primary.withOpacity(0.6) : borderClr ?? ctransp,
        width: (isOutlined && borderClr == c.primary) ? 0.7 : brdrW ?? 1,
      ),
      borderRadius: (rad ?? (isSmall == true ? 30 : 8)).brdrRad,
    );

    return Container(
      width: w,
      height: h,
      padding: btnPadding,
      decoration: btnDecoration,
      child: _buildInnerContent(context, loading, isOutlined),
    );
  }

  Widget _buildInnerContent(BuildContext context, bool loading, bool isOutlined) {
    final textStyle = isSmall == true
        ? style ?? TxtStyle.inter(fs: 10, color: btnTxtClr ?? c.primary, w: 600)
        : style ??
              TxtStyle.inter(
                fs: 13,
                w: 600,
                color: btnTxtClr ?? (isOutlined ? c.primary : c.textPrimary),
              );

    if (loading) return const Loading();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Builder(
          builder: (context) {
            if (iconStroke != null) {
              return SvgIconWNewStroke(iconPath: iconPath, strokeWidth: iconStroke);
            } else {
              return noIconClr == true
                  ? SvgIcon(iconPath: iconPath, width: iconw ?? 23, height: iconh ?? 23)
                  : SvgIconColored(
                      iconPath: iconPath,
                      width: iconw ?? 23,
                      height: iconh ?? 23,
                      iconColor: btnTxtClr ?? c.textPrimary,
                    );
            }
          },
        ),
        Text(btnTxt.capEachWord(), style: textStyle).mOnly(left: txtLeftP ?? 15),
      ],
    );
  }
}
