import '../../../../app/helper_widgets_export.dart';

class ResetPasswordConfirmDialog extends StatelessWidget {
  const ResetPasswordConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 10.w),
          decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
          child: BounceSingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "adasd",
                  textAlign: TextAlign.center,
                  style: TxtStyle.outfitSemiB(fs: 25, w: 500),
                ),
                Gap(itemGap * 2),

                CustomBtnWTxt(
                  outlined: true,
                  borderClr: c.secondary,
                  onTap: () {},

                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  btnTxt: Strings.keepBrowsing,
                  btnColor: ctransp,
                  style: TxtStyle.outfitSemiB(
                    fs: 12,
                    color: c.primary.withValues(alpha: 0.7),
                    w: 500,
                  ),

                  isLoading: false,
                  rad: 12,
                ),
              ],
            ).getcm,
          ),
        ),
      ],
    );
  }
}
