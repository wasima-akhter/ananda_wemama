import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';

class OnboardLogoSection extends StatelessWidget {
  const OnboardLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SafeAssetImage(
          assetPath: ImagesPath.wemamaHandsTitleLogo,
          height: ScreenSize.isSmallWidth ? 90.h : 95.h,
        ),

        Gap(2),

        Text(
          Strings.motherhoodTogether,
          textAlign: TextAlign.center,
          style: TxtStyle.outfitSemiB(
            fs: ScreenSize.isSmallWidth ? 10 : 11,
            w: 500,
            color: c.foregroundPrimary,
            ls: 0.56,
            h: 1.0,
          ),
        ),
      ],
    );
  }
}
