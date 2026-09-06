import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/media/safe_asset_image/safe_image_asset.dart';

class OnboardImageSection extends StatelessWidget {
  const OnboardImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeAssetImage(
      assetPath: ImagesPath.onboardingImage,

      fit: BoxFit.fitWidth,
    );
  }
}
