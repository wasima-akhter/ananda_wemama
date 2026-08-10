import 'package:we_mama/app/helper_widgets_export.dart';

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
      color: btnColor ?? (isOutlined ? c.inputBackground : c.strokePrimary),
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
    final double fontSize = isOutlined
        ? 13
        : (fs ?? (ScreenSizeX.isTablet ? 12 : 14));

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
                color:
                    txtClr ??
                    (isOutlined ? c.foregroundPrimary : c.textOnPrimary),
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
enum BtnVariant { primary, outlined, ghost, disabled }

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

  final BtnVariant variant;

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
    this.fs,
    this.variant = BtnVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isTallDevice = ScreenSize.isTallHeight;

    final bool isOutlined = variant == BtnVariant.outlined;
    final bool isDisabled = variant == BtnVariant.disabled;
    final bool isGhost = variant == BtnVariant.ghost;

    final borderColor = isOutlined ? newBorderClr : Colors.transparent;

    final bgColor = switch (variant) {
      BtnVariant.primary => c.strokePrimary,
      BtnVariant.outlined => ctransp,
      BtnVariant.ghost => Colors.transparent,
      BtnVariant.disabled => c.inputBackground.withValues(alpha: 0.5),
    };

    final textColor =
        txtClr ??
        switch (variant) {
          BtnVariant.primary => c.backgroundSecondary,
          BtnVariant.outlined => c.strokePrimary,
          BtnVariant.ghost => c.strokePrimary,
          BtnVariant.disabled => c.foregroundSecondary,
        };

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
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
          color: btnColor ?? bgColor,
          borderRadius: (rad ?? 8).brdrRad,

          // ✅ ALWAYS KEEP BORDER STRUCTURE CONSISTENT
          border: Border.all(
            color: borderColor,
            width: 1, // <- IMPORTANT FIX
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
                  style:
                      style ??
                      TxtStyle.poppinsSemiB(
                        fs:
                            fs ??
                            (ScreenSizeX.isTablet
                                ? 12
                                : isTallDevice
                                ? 17
                                : 15),
                        w: 600,
                        h: 1.0,
                        color: textColor,
                      ),
                ),
        ),
      ),
    );
  }
}

class AppCompactButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  final TextStyle? style;
  final bool isLoading;
  final bool isUpperCase;

  final Color? bgColor;
  final Color? textColor;

  final double radius;
  final double horizontalPadding;

  const AppCompactButton({
    super.key,
    required this.onTap,
    required this.text,
    this.style,
    this.isLoading = false,
    this.isUpperCase = false,
    this.bgColor,
    this.textColor,
    this.radius = 20,
    this.horizontalPadding = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding.w,
            vertical: 8.h,
          ),

          decoration: BoxDecoration(
            color: bgColor ?? Color(0xFFF4E7E1),
            borderRadius: BorderRadius.circular(radius),
          ),

          child: isLoading
              ? SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: c.strokePrimary,
                  ),
                )
              : Text(
                  isUpperCase ? text.toUpperCase() : text,
                  style:
                      style ??
                      TxtStyle.poppinsSemiB(
                        fs: 12, // ✅ smaller text
                        w: 600,
                        h: 1,
                        color: textColor ?? c.strokePrimary,
                      ),
                ),
        ),
      ),
    );
  }
}
