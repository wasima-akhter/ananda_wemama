import '../../../../app/helper_widgets_export.dart';

class JoinBtn extends StatelessWidget {
  final void Function()? onTap;
  final bool isLoading;
  final String btnTxt;
  const JoinBtn({
    super.key,
    this.onTap,
    required this.isLoading,
    required this.btnTxt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomBtnWTxt(
          txtClr: white,
          style: TxtStyle.outfitSemiB(fs: 12, w: 500, color: white),
          rad: 8,
          borderClr: white,
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 18.w),
          btnTxt: btnTxt.capEachWord(),
          isLoading: isLoading,
          btnColor: ctransp,
          onTap: onTap,
          outlined: true,
        ),
      ],
    );
  }
}
