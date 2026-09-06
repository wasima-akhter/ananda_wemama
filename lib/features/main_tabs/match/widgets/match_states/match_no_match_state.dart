import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';
import '../../controller/match_controller.dart';

class MatchNoMatchState extends StatelessWidget {
  const MatchNoMatchState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 12.h),
      child: Column(
        children: [
          /// Top Image
          SafeAssetImage(
            assetPath:
                Assets.images.noMatchStateImage.path, // replace with your asset
            width: double.infinity,
            height: S.h * 0.23,
            fit: BoxFit.contain,
          ),

          Gap(18.h),

          /// Title
          Column(
            children: [
              Column(
                children: [
                  Text(
                    "No WeMamas nearby",
                    textAlign: TextAlign.center,
                    style: TxtStyle.outfitSemiB(
                      fs: 20,
                      w: 600,

                      color: c.foregroundSecondary,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "right now",
                        textAlign: TextAlign.center,
                        style: TxtStyle.outfitSemiB(
                          fs: 20,
                          w: 600,

                          color: c.foregroundSecondary,
                        ),
                      ),
                      Gap(6),

                      SvgIcon(iconPath: IconsPath.heartGradient),
                    ],
                  ),
                ],
              ),

              Gap(8.h),

              /// Subtitle
              Text(
                "But don't worry — new mums join\nevery day. Your village is growing. 🤎",
                textAlign: TextAlign.center,
                style: TxtStyle.outfitSmSecNor.copyWith(
                  color: c.foregroundSecondary,
                ),
              ),

              Gap(12.h),

              /// Info Card
              ContainerBordered(
                contClr: c.backgroundSecondary,
                hp: 8,
                vp: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 14.w,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          // padding: 8.pa,
                          decoration: BoxDecoration(
                            color: c.bottomSheetBackground,
                            shape: BoxShape.circle,
                          ),
                          child: LovePeopleIcon(size: 50.w),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good things take time",
                            style: TxtStyle.outfitSemiB(w: 600),
                          ),
                          4.verticalSpace,
                          Text(
                            "Keep coming back and you might just find your new bestie here.",
                            textAlign: TextAlign.justify,
                            style: TxtStyle.outfit(fs: 12),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Center(
                        child: SafeAssetImage(
                          assetPath: Assets.images.noMatchLeafImage.path,
                          height: 60.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(16.h),

              /// Button
              CusGestureDetector(
                onTap: mc.startSearching,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    color: c.strokePrimary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: c.bottomSheetBackground,
                          size: 22.sp,
                        ),
                        Gap(5.w),
                        Text(
                          "Try Again",
                          style: TxtStyle.interSemiB(
                            fs: 15,
                            w: 600,
                            color: c.bottomSheetBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Gap(12.h),

              Row(
                children: [
                  Expanded(child: Divider(color: c.bottomSheetBackground)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    // child: const Text("❤️", style: TextStyle(fontSize: 18)),
                    child: SvgIcon(iconPath: IconsPath.heartGradient),
                  ),

                  Expanded(child: Divider(color: c.bottomSheetBackground)),
                ],
              ),

              Gap(8.h),

              Text(
                "In the meantime, explore the community\nand connect in other ways.",
                textAlign: TextAlign.center,
                style: TxtStyle.outfitSmNor,
              ),
            ],
          ).get10cm,
        ],
      ),
    );
  }
}

class LovePeopleIcon extends StatelessWidget {
  const LovePeopleIcon({
    super.key,
    this.size = 60,
    this.color = const Color(0xFF5C2A16),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          children: [
            Gap(4),

            /// Heart
            Icon(Icons.favorite, color: color, size: size * .35),

            /// People
            Icon(
              // iconPath: Assets.icons.userDouble,
              Icons.people_alt_outlined,
              color: color,
              size: size * .52,
            ),
          ],
        ),
      ),
    );
  }
}
