import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';
import 'package:mama_app/features/auth/core/auth_button_templates.dart';
import 'package:mama_app/features/auth/core/auth_scaffold.dart';
import 'package:mama_app/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/helpers/shapes/custom_divider.dart';
import '../controller/finish_setting_profile_controller.dart';

class FinishSettingProfileScreen extends StatelessWidget {
  const FinishSettingProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fspc = Get.find<FinishSettingProfileController>();

    final mumStageFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: AuthButton(
        isLoading: false,
        btnText: Strings.enterWeMama,
        onTap: () => fspc.onTapContinue(mumStageFormKey),
        //  () => Get.toNamed(RoutePaths.welcomeFundingMum),
        //  isLoading: msc.isLoading,
        //  msc.onTapContinue(mumStageFormKey),
      ).mB(10),

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(10.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            child: SafeAssetImage(
                              assetPath: Assets.images.allSetImage.path,
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionalTranslation(
                              translation: Offset(
                                0,
                                ScreenSize.isSmallWidth ? 1.15 : 0.98,
                              ), // 👈 pulls list down past image bottom — tweak 0.55 to taste
                              child: ContainerBordered(
                                contClr: contBgClr,
                                hasBrdr: true,
                                hp: 0,
                                brdrClr: newBorderClr,
                                brdrW: 2,
                                vp: 0,
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // 👈 height grows with content, not fixed
                                  children: [
                                    ...List.generate(fspc.featureList.length, (
                                      index,
                                    ) {
                                      final item = fspc.featureList[index];
                                      return Column(
                                        children: [
                                          Container(
                                            margin: ScreenSize.isSmallWidth
                                                ? 8.pa
                                                : 12.pa,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 40.w,
                                                  child: SvgIcon(
                                                    iconPath: item.leftIcon,
                                                    height:
                                                        ScreenSize.isSmallWidth
                                                        ? 25
                                                        : 28,
                                                  ),
                                                ),
                                                Gap(8.w),
                                                Expanded(
                                                  child: Text(
                                                    item.title.cap,
                                                    style:
                                                        TxtStyle.poppinsSemiBold12Center(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (index !=
                                              fspc.featureList.length - 1)
                                            CustomDivider(
                                              isFullWidth: true,
                                              clr: newBorderClr,
                                              h: 2.3,
                                            ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ).get10cm,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Gap(itemGap * 2.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
