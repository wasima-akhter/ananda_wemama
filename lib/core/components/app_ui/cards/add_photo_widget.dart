import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../ui/dialogs/popups.dart';

class AddPhotoWidget extends StatelessWidget {
  final XFile? selImage;
  final String? imageUrl;
  final double radius;
  final double? width;
  final double? height;
  final void Function()? onTapAddPhoto;

  const AddPhotoWidget({
    super.key,
    this.selImage,
    this.imageUrl,
    this.radius = 12,
    this.width,
    this.height,
    this.onTapAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final double w = width?.w ?? double.infinity;
    final double h = height?.w ?? S.h * 0.25;
    final bool hasImage = selImage != null || (imageUrl != null && imageUrl!.isNotEmpty);

    if (!hasImage) {
      return CusGestureDetector(
        onTap: onTapAddPhoto,
        child: _RectPlaceholder(w: w, h: h, radius: radius),
      );
    }

    if (selImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius.r),
        child: GestureDetector(
          onTap: () => _openBothViewer(context),
          child: Stack(
            children: [
              Container(
                width: w,
                height: h,
                decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(File(selImage!.path)), fit: BoxFit.cover),
                ),
              ),

              Container(width: w, height: h, color: black.withOpacity(0.15)),

              Positioned(
                top: 10,
                right: 10,
                child: CusCircleIconButton(
                  onTap: onTapAddPhoto, // ❗ still edit only
                  backgroundColor: c.primary.withOpacity(0.3),
                  radius: 20,
                  child: Icon(Icons.edit, size: 22, color: c.primary),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Network image ──
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: Stack(
        children: [
          NetworkImageWidget(
            imageUrl: imageUrl,
            radius: radius,
            width: w,
            height: h,
            isUser: false,
          ),

          Container(width: w, height: h, color: black.withOpacity(0.15)),

          Positioned(
            top: 10,
            right: 10,
            child: CusCircleIconButton(
              onTap: onTapAddPhoto,
              backgroundColor: c.primary.withOpacity(0.3),
              radius: 20,
              child: Icon(Icons.edit, size: 22, color: c.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _openBothViewer(BuildContext context) {
    if (selImage != null) {
      showImageViewer(context: context, imageSource: selImage);
      return;
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      showImageViewer(context: context, imageSource: imageUrl);
    }
  }
}

class _RectPlaceholder extends StatelessWidget {
  final double w;
  final double h;
  final double radius;

  const _RectPlaceholder({required this.w, required this.h, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.r),
        color: c.inputBackground,
        border: Border.all(color: newBorderClr2_30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: c.foregroundPrimary, size: 20.r),
          Gap(4),
          Text(
            Strings.addPhoto,
            style: TxtStyle.outfitSemiB(fs: 10, w: 500,),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
