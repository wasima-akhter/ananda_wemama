import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/features/auth/core/auth_button_templates.dart';
import 'package:we_mama/features/auth/core/auth_scaffold.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/helpers/shapes/custom_divider.dart';
import '../controller/finish_setting_profile_controller.dart';

class FinishSettingProfileScreen extends StatelessWidget {
  const FinishSettingProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fspc = FinishSettingProfileController.to;

    final mumStageFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: Obx(() {
        return AuthButton(
          isLoading: fspc.isLoading,
          btnText: Strings.enterWeMama,
          onTap: () async => await fspc.onTapContinue(),
          //  () => Get.toNamed(RoutePaths.welcomeFundingMum),
          //  isLoading: msc.isLoading,
          //  msc.onTapContinue(mumStageFormKey),
        ).mB(10);
      }),

      // appBar: CommonAppBarContent(title: Strings.mumsStage),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button (left aligned)
              Align(
                alignment: Alignment.centerLeft,
                child: CusGestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgIconColored(
                    iconPath: IconsPath.arrowBackSmall,
                    height: 14,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome tetxt
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text(
                              "You are all set,",
                              textAlign: TextAlign.center,
                              style: TxtStyle.dmSerifDisplayRegular(),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Mama!",
                                  textAlign: TextAlign.center,
                                  style: TxtStyle.dmSerifDisplayRegular(),
                                ),
                                SafeAssetImage(
                                  assetPath: Assets.images.congrates.path,
                                  height: 40.h,
                                ),
                              ],
                            ),
                          ],
                        ),

                        //
                      ],
                    ),

                    Gap(itemGap),
                    // if (subtitleText.isNotEmpty)
                    Text(
                      "You are not alone on this journey, We\nare so happy you are here."
                          .capEachWord(),
                      textAlign: TextAlign.center,
                      style: TxtStyle.poppinsSemiBold12Center(),
                    ),
                  ],
                ),
              ),
            ],
          ).getcm,

          Gap(ScreenSize.isSmallWidth ? 0 : 10.h),
          Form(
            key: mumStageFormKey,

            /*
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SafeAssetImage(
                            assetPath: Assets.images.allSetImage.path,
                            fit: BoxFit.fitWidth,
                            height: (ScreenSizeShortestLogic.s * 0.58).clamp(
                              200.0,
                              380.0,
                            ),
                          ),
                          Positioned(
                            bottom: -(ScreenSizeShortestLogic.s * 0.4).clamp(
                              40.0,
                              130.0, //     ScreenSize.isSmallWidth ? 130.0 : 180.0,
                            ),
                            left: 16,
                            right: 16,
                            child: ContainerBordered(
                              contClr: contBgClr,
                              hasBrdr: true,
                              brdrClr: newBorderClr,
                              brdrW: 2,
                              vp: 0,
                              hp: 0,
                              child: Content_(),
                            ).get10cm,
                          ),
                        ],
                      ),

                      // 👇 pushes next content below overlap
                      const SizedBox(height: 40),
                    ],
                  ),
                );

                // Stack(
                //   clipBehavior: Clip.none,
                //   children: [
                //     Container(
                //       child: SafeAssetImage(
                //         assetPath: Assets.images.allSetImage.path,
                //       ),
                //     ),

                //     Align(
                //       alignment: Alignment.bottomCenter,
                //       child: FractionalTranslation(
                //         translation: Offset(
                //           0,
                //           ScreenSize.isSmallWidth ? 1.15 : 0.98,
                //         ), // 👈 pulls list down past image bottom — tweak 0.55 to taste
                //         child: ContainerBordered(
                //           contClr: contBgClr,
                //           hasBrdr: true,
                //           hp: 0,
                //           brdrClr: newBorderClr,
                //           brdrW: 2,
                //           vp: 0,
                //           child: Content_() ).get10cm,
                //       ),
                //     ),
                //   ],
                // );
              },
            ),
         */
            child: LayoutBuilder(
              builder: (context, constraints) {
                print(' Get.height is Get.width : ${Get.width < Get.height} ');
                // 👇 single source of truth — everything derives from this
                final imageHeight =
                    (ScreenSizeShortestLogic.s *
                            (ScreenSize.isSmallWidth ? 0.4 : 0.58))
                        .clamp(180.0, 380.0);
                final overlapOffset =
                    imageHeight *
                    (ScreenSize.isSmallWidth
                        ? 0.8
                        : 0.98); // card always overlaps 98% of image height

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SafeAssetImage(
                            assetPath: Assets.images.allSetImage.path,
                            fit: BoxFit.fitWidth,
                            height: imageHeight,
                          ),
                          Positioned(
                            bottom:
                                -overlapOffset, // 👈 always proportional to image
                            left: 16,
                            right: 16,
                            child: ContainerBordered(
                              contClr: contBgClr,
                              hasBrdr: true,
                              brdrClr: newBorderClr,
                              brdrW: 2,
                              vp: 0,
                              hp: 0,
                              child: Content_(),
                            ).get10cm,
                          ),
                        ],
                      ),

                      // 👇 spacer must also match the overlap so nothing clips below
                      SizedBox(height: overlapOffset + 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Content_ extends StatelessWidget {
  const Content_({super.key});

  @override
  Widget build(BuildContext context) {
    final fspc = FinishSettingProfileController.to;
    return Column(
      mainAxisSize: MainAxisSize.min, // 👈 height grows with content, not fixed
      children: [
        ...List.generate(fspc.featureList.length, (index) {
          final item = fspc.featureList[index];
          return Column(
            children: [
              Container(
                margin: ScreenSize.isSmallWidth ? 8.pa : 12.pa,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: SvgIcon(
                        iconPath: item.leftIcon,
                        height: ScreenSize.isSmallWidth ? 25 : 28,
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Text(
                        item.title.cap,
                        style: TxtStyle.poppinsSemiBold12Center(),
                      ),
                    ),
                  ],
                ),
              ),
              if (index != fspc.featureList.length - 1)
                CustomDivider(isFullWidth: true, clr: newBorderClr, h: 2.3),
            ],
          );
        }),
      ],
    );
  }
}
