import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/ui/dialogs/popups.dart';

class UserPhotoWidget extends StatelessWidget {
  final bool isFromSetup;
  final XFile? selImage;
  final String? imageUrl;
  final double? size_;
  final bool? hasBrdr;

  const UserPhotoWidget({
    super.key,
    this.selImage,
    this.imageUrl,
    this.isFromSetup = false,
    this.size_,
    this.hasBrdr,
  });

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
    final size = size_ ?? (ScreenSize.isSmallWidth ? 80 : 72).w;

    final hasImage =
        selImage != null || (imageUrl != null && imageUrl!.isNotEmpty);

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
          image: DecorationImage(
            image: FileImage(File(selImage!.path)),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // / 2️⃣ Network image
    if (imageUrl != null && imageUrl!.isNotEmpty && isFromSetup == false) {
      return NetworkImageWidget(
        hasShadow: true,
        imageUrl: imageUrl,
        hasBrdr: hasBrdr,
        radius: size / 2,
        isCircle: true,
        isUser: true,
      );
    }

    /// 3️⃣ Placeholder (no tap)
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasBrdr == true ? Border.all(color: c.inputBorder) : null,
        color: c.inputBackground,
      ),
      clipBehavior: Clip.antiAlias,
      child: Icon(Icons.person, size: size / 2, color: c.strokePrimary)
          //  Assets.images.userPlaceholder
          // .image(width: 22.w, height: 22.w, color: c.primary)
          .mAll(size_ != null ? size_! * 0.15 : 10),
    );
  }
}
