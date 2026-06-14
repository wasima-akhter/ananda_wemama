import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';

import '../../../../../app/helper_widgets_export.dart';

class Onboard3MapSection extends StatelessWidget {
  const Onboard3MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeAssetImage(
      assetPath: ImagesPath.locationMap,
      width: double.infinity,
      height: ScreenSize.isSmallWidth ? 220.h : null,
      fit: BoxFit.fitWidth,
    );
  }
}
