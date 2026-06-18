import '../../../../../app/helper_widgets_export.dart';

class ContainerBordered extends StatelessWidget {
  final Widget child;
  final Color? brdrClr;
  final Color? contClr;
  final bool? hasBrdr;
  final double? brdrW;
  final double? rad;
  final double? vp;
  final double? hp;
  final double? mv;
  final double? mh;
  final double? h;
  final double? w;
  final int? duration;
  final AlignmentGeometry? alignment;
  final bool? hideAlignment;
  final BoxDecoration? cusDec;
  final List<BoxShadow>? boxShadow;
  final Clip? clipBehavior;

  const ContainerBordered({
    super.key,
    required this.child,
    this.brdrClr,
    this.contClr,
    this.rad,
    this.h,
    this.w,
    this.vp,
    this.hp,
    this.duration,

    this.alignment,
    this.cusDec,
    this.hasBrdr,
    this.brdrW,
    this.boxShadow,
    this.mv,
    this.mh,
    this.clipBehavior,
    this.hideAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return hideAlignment == true
        ? AnimatedContainer(
            clipBehavior: clipBehavior ?? Clip.none,
            duration: Duration(milliseconds: duration ?? 0),
            margin: EdgeInsets.symmetric(
              horizontal: (mh ?? 0.0).w,
              vertical: (mv ?? 0).h,
            ),
            curve: Curves.easeInOut,
            height: h,
            width: w,
            decoration:
                cusDec ??
                BoxDecoration(
                  borderRadius: (rad ?? 12).brdrRad,
                  border: hasBrdr == null
                      ? Border()
                      : Border.all(
                          color: brdrClr ?? c.inputBorder,
                          width: brdrW ?? 0.6,
                        ),
                  color: contClr ?? ctransp,
                  boxShadow: boxShadow,
                ),

            child: child.pHV((hp ?? 5).w, (vp ?? 5).h),
          )
        : AnimatedContainer(
            clipBehavior: clipBehavior ?? Clip.none,
            alignment: alignment ?? Alignment.center,
            duration: Duration(milliseconds: duration ?? 0),
            margin: EdgeInsets.symmetric(
              horizontal: (mh ?? 0.0).w,
              vertical: (mv ?? 0).h,
            ),
            curve: Curves.easeInOut,
            height: h,
            width: w,
            decoration:
                cusDec ??
                BoxDecoration(
                  borderRadius: (rad ?? 12).brdrRad,
                  border: hasBrdr == null
                      ? Border()
                      : Border.all(
                          color: brdrClr ?? c.inputBorder,
                          width: brdrW ?? 0.6,
                        ),
                  color: contClr ?? ctransp,
                  boxShadow: boxShadow,
                ),

            child: child.pHV((hp ?? 5).w, (vp ?? 5).h),
          );
  }
}
