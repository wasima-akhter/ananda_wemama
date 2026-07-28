import 'package:we_mama/gen/assets.gen.dart';

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
                SvgIconColored(
                  iconPath: Assets.icons.tickL2,
                  height: S.w * 0.13,
                  iconColor: c.primary,
                ),
                Gap(itemGap * 3.5),
                Text(
                  "Your Password Has been Changed Successfully".capEachWord(),
                  textAlign: TextAlign.center,
                  style: TxtStyle.outfit(fs: 16, w: 500),
                ),
                Gap(itemGap),
                Text(
                  "Continue to login".capEachWord(),
                  textAlign: TextAlign.center,
                  style: TxtStyle.outfit(fs: 12, color: c.secondary),
                ),
                Gap(itemGap * 2.5),

                CustomBtnWTxt(
                  onTap: () {
                    Get.offAllNamed(RoutePaths.signin);
                  },
                  btnColor: c.primary,
                  isSmall: true,

                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  btnTxt: Strings.continueTxt,

                  // style: TxtStyle.outfitSemiB(
                  //   fs: 12,
                  //   color: c.primary.withValues(alpha: 0.7),
                  //   w: 500,
                  // ),
                  isLoading: false,
                  rad: 30,
                ),
              ],
            ).getcm,
          ),
        ),
      ],
    );
  }
}
