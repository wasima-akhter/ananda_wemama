import 'package:mama_app/app/helper_widgets_export.dart';

class CustomBtnWTxt extends StatelessWidget {
  final VoidCallback? onTap;

  final String btnTxt;
  final TextStyle? style;
  final Color? txtClr;
  final double? fs;

  final Color? btnColor;
  final Color? borderClr;
  final double? brdrW;

  final double? w;
  final double? h;
  final double? rad;
  final EdgeInsetsGeometry? padding;

  final bool isLoading;

  final bool? isUppCase;

  final bool? isSmall;
  final bool? isCentered;
  final bool? outlined;

  const CustomBtnWTxt({
    super.key,
    this.onTap,
    required this.btnTxt,
    this.style,
    this.txtClr,
    this.btnColor,
    this.borderClr,
    this.brdrW,
    this.w,
    this.h,
    this.rad,
    this.padding,
    required this.isLoading,
    this.isSmall,
    this.isCentered,
    this.fs,
    this.outlined,
    this.isUppCase,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: _buildContainer(context));
  }

  Widget _buildContainer(BuildContext context) {
    final EdgeInsetsGeometry btnPadding =
        // isSmall == true
        //     ? EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h)
        //     :
        padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h);

    final bool isOutlined = outlined == true;

    final BoxDecoration btnDecoration = BoxDecoration(
      color: btnColor ?? (isOutlined ? c.inputBackground : c.primary),
      border: Border.all(
        color: isOutlined ? borderClr ?? c.inputBorder : borderClr ?? ctransp,
        width:
            ((isOutlined && borderClr == c.inputBorder) ? 0.7 : (brdrW ?? 1)).w,
      ),
      borderRadius: (rad ?? (isSmall == true ? 30 : 8)).brdrRad,
    );

    return Container(
      width: w?.w,
      height: h?.h,
      padding: btnPadding,
      decoration: btnDecoration,
      child: _buildInnerContent(context, isOutlined),
    );
  }

  Widget _buildInnerContent(BuildContext context, bool isOutlined) {
    final double fontSize = isOutlined ? 13 : (fs ?? 14);

    final textStyle = isSmall == true
        ? style ??
              TxtStyle.outfitSemiB(
                fs: (fs ?? 14),
                color: txtClr ?? c.textOnPrimary,
                w: 600,
              )
        : style ??
              TxtStyle.inter(
                fs: fontSize,
                w: 600,
                color: txtClr ?? (isOutlined ? c.textPrimary : c.textOnPrimary),
              );

    return Center(
      child: isLoading
          ? Container(
              // padding: 2.pv,
              // width: 18.w, height: 18.w,
              child: const LoadingWhite(),
            )
          : FittedBox(
              child: Text(
                isUppCase == true ? btnTxt.toUpperCase() : btnTxt.capEachWord(),
                style: textStyle,
              ),
            ),
    );
  }
}

//
class CustomBtnWTxtNew extends StatelessWidget {
  final VoidCallback? onTap;

  final String btnTxt;
  final TextStyle? style;

  final Color? btnColor;
  final Color? txtClr;

  final double? w;
  final double? h;
  final double? rad;
  final double? fs;
  final EdgeInsetsGeometry? padding;

  final bool isLoading;
  final bool? isUppCase;
  final bool? outlined;

  const CustomBtnWTxtNew({
    super.key,
    this.onTap,
    required this.btnTxt,
    this.style,
    this.btnColor,
    this.txtClr,
    this.w,
    this.h,
    this.rad,
    this.padding,
    required this.isLoading,
    this.isUppCase,
    this.outlined,
    this.fs,
  });

  @override
  Widget build(BuildContext context) {
    final isTallDevice = ScreenSize.isTallHeight;

    final defaultStyle = TxtStyle.poppinsSemiB(
      fs: fs ?? (isTallDevice ? 17 : 15),
      w: 600,
      h: 1.0,
      ls: 0,
      color: txtClr ?? c.backgroundSecondary,
    );

    final bool isOutlined = outlined == true;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w?.w,
        height: h?.h,
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: ScreenSize.isSmallWidth ? 13.h : 12.h,
            ),
        decoration: BoxDecoration(
          color: btnColor ?? (isOutlined ? c.inputBackground : c.primary),
          borderRadius: (rad ?? 8).brdrRad,
          border: Border.all(
            color: isOutlined ? c.inputBorder : Colors.transparent,
          ),
        ),
        child: Center(
          child: isLoading
              ? const LoadingWhite()
              : Text(
                  isUppCase == true
                      ? btnTxt.toUpperCase()
                      : btnTxt.capEachWord(),
                  textAlign: TextAlign.center,
                  style: style ?? defaultStyle,
                ),
        ),
      ),
    );
  }
}
