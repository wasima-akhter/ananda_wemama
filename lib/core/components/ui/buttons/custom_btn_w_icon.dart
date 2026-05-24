import 'package:mama_app/app/helper_widgets_export.dart';

import '../media/icons/svg_icon_w_new_stroke.dart';

enum IconPosition { left, right }

enum TextCaseType { normal, upper, lower, capitalize }

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

  final double? spacing;

  final bool? wantUnfocus;

  // ✅ NEW
  final IconPosition iconPosition;
  final TextCaseType textCaseType;

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
    this.spacing,
    this.wantUnfocus,
    this.btnTxtClr,

    // ✅ defaults
    this.iconPosition = IconPosition.left,
    this.textCaseType = TextCaseType.capitalize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (wantUnfocus != false) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        if (!isLoading) {
          onTap?.call();
        }
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
        color: isOutlined
            ? borderClr ?? c.primary.withOpacity(0.6)
            : borderClr ?? ctransp,
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

  Widget _buildInnerContent(
    BuildContext context,
    bool loading,
    bool isOutlined,
  ) {
    final textStyle = isSmall == true
        ? style ?? TxtStyle.inter(fs: 10, color: btnTxtClr ?? c.primary, w: 600)
        : style ??
              TxtStyle.inter(
                fs: 13,
                w: 600,
                color: btnTxtClr ?? (isOutlined ? c.primary : c.textPrimary),
              );

    if (loading) {
      return const LoadingWhite();
    }

    final textWidget = Text(
      _formattedText(btnTxt),
      style: textStyle,
      textAlign: TextAlign.center,
    );

    final iconWidget = _buildIcon();

    // ✅ LEFT ICON → keep old row logic
    if (iconPosition == IconPosition.left) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          SizedBox(width: spacing ?? 12),
          Flexible(child: textWidget),
        ],
      );
    }

    // ✅ RIGHT ICON → perfectly centered text
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(child: textWidget),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(left: spacing ?? 12),
            child: iconWidget,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    if (iconStroke != null) {
      return SvgIconWNewStroke(iconPath: iconPath, strokeWidth: iconStroke);
    }

    if (noIconClr == true) {
      return SvgIcon(
        iconPath: iconPath,
        width: iconw ?? 23,
        height: iconh ?? 23,
      );
    }

    return SvgIconColored(
      iconPath: iconPath,
      width: iconw ?? 23,
      height: iconh ?? 23,
      iconColor: btnTxtClr ?? white,
    );
  }

  String _formattedText(String text) {
    switch (textCaseType) {
      case TextCaseType.upper:
        return text.toUpperCase();

      case TextCaseType.lower:
        return text.toLowerCase();

      case TextCaseType.capitalize:
        return text.capEachWord();

      case TextCaseType.normal:
        return text;
    }
  }
}
