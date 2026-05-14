import '../../../../app/helper_widgets_export.dart';

class FloatingBtn extends StatelessWidget {
  final void Function()? onTap;
  final String btnTxt;
  final bool isLoading;
  final Color? btnColor;
  final Color? txtClr;
  const FloatingBtn({
    super.key,
    this.onTap,
    required this.btnTxt,
    required this.isLoading,
    this.btnColor,
    this.txtClr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),

      child: CustomBtnWTxt(
        btnColor: btnColor,
        txtClr: txtClr,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        btnTxt: btnTxt,
        onTap: onTap,
        isLoading: isLoading,
      ),
    );
  }
}
