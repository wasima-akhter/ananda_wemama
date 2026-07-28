import 'package:flutter/foundation.dart';
import 'package:we_mama/app/helper_widgets_export.dart';

class CusMaterialBtnWTxt extends StatelessWidget {
  final ValueListenable<bool> isLoading;
  final VoidCallback? onTap;
  final String btnTxt;
  final Color? borderClr;
  final Color? txtClr;
  final Color? btnColor;
  final double? w;
  final double? h;
  final double? hp;
  final double? vp;
  final double? rad;
  final bool? isloadingwhite;
  final bool? isCentered;
  final TextStyle? style;
  const CusMaterialBtnWTxt({
    super.key,
    required this.isLoading,
    this.onTap,
    required this.btnTxt,
    this.borderClr,
    this.txtClr,
    this.btnColor,
    this.w,
    this.h,
    this.rad,
    this.isloadingwhite,
    this.isCentered,
    this.style,
    this.hp,
    this.vp,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, value, child) {
        return Material(
          color: btnColor ?? c.primary,
          shape: RoundedRectangleBorder(borderRadius: (rad ?? 8).brdrRad),
          elevation: 1,
          child: InkWell(
            onTap: () {
              // Unfocus all FocusNodes (hide keyboard)
              FocusScope.of(context).unfocus();

              // Then perform your original action
              if (onTap != null) onTap!();
            },
            borderRadius: (rad ?? 8).brdrRad,
            child: SizedBox(
              width: w ?? 85,
              height: h ?? 40,
              child: Center(
                child: value
                    ? LoadingWhite()
                    : Text(btnTxt, style: TxtStyle.inter(fs: 13, color: txtClr ?? c.textSecondary)),
              ),
            ).mHV(hp ?? 0, vp ?? 0),
          ),
        );
      },
    );
  }
}
