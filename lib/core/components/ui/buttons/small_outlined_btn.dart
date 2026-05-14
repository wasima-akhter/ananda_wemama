import '../../../../app/helper_widgets_export.dart';

class SmallOutlinedBtn extends StatelessWidget {
  final void Function()? onTap;
  final bool isLoading;
  final String btnTxt;
  final Color? btnClr;
  final Color? txtClr;
  const SmallOutlinedBtn({
    super.key,
    this.onTap,
    required this.isLoading,
    required this.btnTxt,
    this.btnClr,
    this.txtClr,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomBtnWTxt(
          style: TxtStyle.interSemiB(fs: 12, w: 500, color: txtClr),
          rad: 30,
          borderClr: c.inputBorder.withOpacity(0.3),
          padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 12.w),
          btnTxt: btnTxt.capEachWord(),
          isLoading: isLoading,
          btnColor: btnClr,
          onTap: onTap,
          outlined: true,
        ),
      ],
    );
  }
}
