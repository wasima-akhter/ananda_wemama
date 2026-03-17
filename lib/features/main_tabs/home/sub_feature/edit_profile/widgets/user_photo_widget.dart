import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../gen/assets.gen.dart';

class UserPhotoWidget extends StatelessWidget {
  final XFile? selImage;
  final String? imageUrl;

  const UserPhotoWidget({super.key, this.selImage, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = (S.w * 0.2).w;

    /// 1️⃣ Selected image (preview before upload)
    if (selImage != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgClr,
          image: DecorationImage(image: FileImage(File(selImage!.path)), fit: BoxFit.cover),
        ),
      );
    }

    /// 2️⃣ Network image (from storage / updated profile)
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImageWidget(imageUrl: imageUrl, radius: size / 2, isCircle: true);
    }

    /// 3️⃣ Placeholder
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: c.inputBorder),
        color: c.inputBackground,
      ),
      clipBehavior: Clip.antiAlias,
      child: Assets.images.imagePlaceholder
          .image(width: 22.w, height: 22.w, color: c.primary)
          .mAll(10),
    );
  }
}
