import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/features/entry/onboard/modules/core/onboard_logo_header_row.dart';
import 'package:we_mama/features/post_auth_setup/welcome_funding_mum/controller/welcome_funding_mum_controller.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../auth/core/auth_button_templates.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../../../entry/onboard/modules/core/onboard_heart_icon.dart';

class WelcomeFundingMumScreen extends StatelessWidget {
  const WelcomeFundingMumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WelcomeFundingMumController>();
    return AuthScaffold(
      bottomWidget: AuthButton(
        isLoading: false,
        onTap: () => Get.toNamed(RoutePaths.mainNav),
        //  isLoading: msc.isLoading,
        //  msc.onTapContinue(mumStageFormKey),
      ).mB(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardLogoHeaderRow(),
          Gap(10.h),
          Column(
            children: [
              Text(
                'Welcome, Founding ',
                textAlign: TextAlign.center,
                style: TxtStyle.dmSerifDisplayRegular(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mum',
                    textAlign: TextAlign.center,
                    style: TxtStyle.dmSerifDisplayRegular(),
                  ),
                  Gap(8.w),
                  //
                  OnboardHeartIcon(
                    startColor: Color(0xFF922604),
                    endColor: Color(0xFFFF9191),
                    height: 22,
                  ),
                ],
              ),
              Gap(itemGap),
              Text(
                'Thank you for joining WeMama early.',
                textAlign: TextAlign.center,
                style: TxtStyle.poppinsSemiBold12Center(
                  color: c.foregroundSecondary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Gap(ScreenSize.isSmallWidth ? 0 : itemGap),

          //
          //  heart image long
          // SafeAssetImage(assetPath: ImagesPath.onboardScreenHeart).get10cm,
          // Gap(itemGap),
          SafeAssetImage(
            assetPath: Assets.images.foundingMumNewImage.path,
            height: S.h * 0.2,
          ),

          //
          ContainerBordered(
            contClr: Color(0xFFFBF0E9),
            hasBrdr: true,
            brdrClr: newBorderClr,
            brdrW: 1,
            vp: 8,
            hp: 0,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(controller.infoModels.length, (index) {
                  final item = controller.infoModels[index];
                  final isLast = index == controller.infoModels.length - 1;

                  return Expanded(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            if (!isLast)
                              Positioned(
                                right: 0,
                                top: 10.h,
                                bottom: 10.h,
                                child: Container(width: 1, color: newBorderClr),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                // border: isLast
                                //     ? null
                                //     : Border(
                                //         right: BorderSide(color: Colors.grey, width: 1),
                                //       ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 36.h,
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: newBorderClr,
                                            width: 1.4,
                                          ),
                                        ),
                                        padding: 6.pa,
                                        child: SvgIconColored(
                                          iconPath: item.iconPath,
                                          height: 24,
                                          iconColor: Color(
                                            0xFFC76D46,
                                          ).withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Gap(6.h),

                                  // 👇 fixed 2-line slot — every column now has identical total height
                                  SizedBox(
                                    height: (ScreenSize.isSmallWidth ? 66 : 60)
                                        .h, // 4 lines @ fs:10 with safe padding
                                    child: Text(
                                      item.text,
                                      textAlign: TextAlign.center,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          TxtStyle.poppinsSemiBold12Center(
                                            fs: 10,
                                            color: c.foregroundPrimary
                                                .withValues(alpha: 0.7),
                                          ).copyWith(
                                            letterSpacing: 0.1,
                                            fontWeight: FontWeight.w600,
                                            height:
                                                1.4, // 👈 explicit line-height multiplier — makes height predictable
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Gap(ScreenSize.isSmallWidth ? 8.h : 10.h),
          // badge added
          ContainerBordered(
            contClr: Color(0xFFFBF0E9),
            hasBrdr: true,
            brdrClr: newBorderClr,
            brdrW: 1,
            vp: 8,
            hp: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: S.w * 0.15,
                  child: SvgIcon(
                    iconPath: IconsPath.leaf,
                    height: ScreenSize.isSmallWidth ? 25 : 32,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Badge Added".capEachWord(),
                        style: TxtStyle.outfitSemiB(
                          color: c.primary,
                          fs: ScreenSize.isSmallWidth ? 14 : 15,
                          w: 700,
                        ),
                      ),
                      Gap(4.h),

                      //
                      Row(
                        children: [
                          Text(
                            "Early member".capEachWord(),
                            style: TxtStyle.outfitSemiB(
                              color: c.foregroundSecondary,
                              fs: 11,
                            ),
                          ),

                          Gap(6.w),

                          //
                          CircleAvatar(
                            radius: 3.r,
                            backgroundColor: c.bottomSheetBackground,
                          ),
                          Gap(6.w),
                          //
                          Text(
                            "WeMama Founding Circle".capEachWord(),
                            style: TxtStyle.outfitSemiB(
                              color: c.foregroundSecondary,
                              fs: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Gap(itemGap * 2),
        ],
      ).getcm,
    );
  }
}
