import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/ui/dialogs/popups.dart';
import '../../../../../../gen/assets.gen.dart';

class UserPhotoWidget extends StatelessWidget {
  final XFile? selImage;
  final String? imageUrl;

  const UserPhotoWidget({super.key, this.selImage, this.imageUrl});

  void _openViewer(BuildContext context) {
    if (selImage != null) {
      showImageViewer(context: context, imageSource: selImage);
      return;
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      showImageViewer(
        context: context,
        imageSource: makeImageUrl(
          imageUrl: (imageUrl ?? '').startsWith('/')
              ? (imageUrl ?? '').substring(1)
              : (imageUrl ?? ''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = (S.w * 0.2).w;

    final hasImage = selImage != null || (imageUrl != null && imageUrl!.isNotEmpty);

    return GestureDetector(
      onTap: hasImage ? () => _openViewer(context) : null,
      child: _buildContent(size),
    );
  }

  Widget _buildContent(double size) {
    /// 1️⃣ Selected image
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

    /// 2️⃣ Network image
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImageWidget(imageUrl: imageUrl, radius: size / 2, isCircle: true);
    }

    /// 3️⃣ Placeholder (no tap)
    return Container(
      width: size,
      height: size,
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
