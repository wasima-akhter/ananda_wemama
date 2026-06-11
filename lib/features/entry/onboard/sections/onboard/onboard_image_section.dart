import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';

class OnboardImageSection extends StatelessWidget {
  const OnboardImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeAssetImage(
      assetPath: ImagesPath.onboardingImage,
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }
}
