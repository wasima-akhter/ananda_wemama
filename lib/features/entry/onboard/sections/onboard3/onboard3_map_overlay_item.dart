import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';

import '../../../../../app/helper_widgets_export.dart';

class Onboard3MapSection extends StatelessWidget {
  const Onboard3MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeAssetImage(
      assetPath: ImagesPath.locationMap,
      width: double.infinity,
      height: ScreenSize.isSmallWidth
          ? 200.h
          : 240.h, // 👈 always set, shorter on both
      fit: BoxFit.cover, // 👈 crops vertically to fill width without distortion
    );
  }
}
