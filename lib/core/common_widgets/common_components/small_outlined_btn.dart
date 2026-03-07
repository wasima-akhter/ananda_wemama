import '../../../app/helper_widgets_export.dart';

class SmallOutlinedBtn extends StatelessWidget {
  final void Function()? onTap;
  final bool isLoading;
  final String btnTxt;
  final Color? btnClr;
  const SmallOutlinedBtn({
    super.key,
    this.onTap,
    required this.isLoading,
    required this.btnTxt,
    this.btnClr,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: CustomBtnWTxt(
        txtClr: c.primary,
        style: TxtStyle.interSemiB(fs: 12, w: 500),
        rad: 30,
        borderClr: c.inputBorder.withOpacity(0.3),
        padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 12.w),
        btnTxt: btnTxt.capEachWord(),
        isLoading: isLoading,
        btnColor: btnClr,
        onTap: onTap,
        outlined: true,
      ),
    );
  }
}
